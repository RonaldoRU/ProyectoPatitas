<?php

namespace App\Http\Controllers\P9_PagosDonaciones;

use App\Http\Controllers\Controller;
use App\Models\AporteDinero;
use App\Models\Donacion;
use App\Models\Donante;
use App\Services\AuditoriaService;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

/**
 * Paquete P9: Pasarela de Pagos, Donaciones Monetarias y Recibos Digitales
 * Casos de Uso:
 * - CU26: Procesar Pago / Donación Monetaria (QR / Tarjeta / Transferencia)
 * - CU27: Verificar y Confirmar Transacción Monetaria (Webhook / Callback / Manual)
 * - CU28: Emitir y Descargar Comprobante / Recibo Digital
 * - CU29: Conciliar y Arquear Transacciones Financieras
 * - CU30: Gestionar Anulación o Reembolso de Transacción
 */
class PasarelaPagoController extends Controller
{
    /**
     * CU26: Iniciar intención de pago o donación con generación de QR dinámico.
     */
    public function iniciarPago(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'monto' => ['required', 'numeric', 'min:1'],
            'canal' => ['required', 'string', 'in:QR,Tarjeta,Transferencia,Efectivo'],
            'concepto' => ['nullable', 'string', 'max:255'],
            'donante_nombre' => ['required', 'string', 'max:255'],
            'donante_telefono' => ['nullable', 'string', 'max:50'],
            'donante_email' => ['nullable', 'email', 'max:255'],
        ]);

        $transaccionId = 'TXN-'.strtoupper(Str::random(10));
        $monto = (float) $validated['monto'];
        $canal = $validated['canal'];
        $concepto = $validated['concepto'] ?? 'Aporte solidario para el albergue';

        // Buscar o crear donante
        $donante = Donante::query()->firstOrCreate(
            ['nombre' => $validated['donante_nombre']],
            [
                'telefono' => $validated['donante_telefono'] ?? 'Sin teléfono',
                'tipo_persona' => 'Particular',
            ]
        );

        $usuarioId = $request->user()?->getKey() ?? 1;

        $donacion = Donacion::query()->create([
            'tipo_aporte' => 'Dinero',
            'fecha' => Carbon::today()->toDateString(),
            'numero_documento' => $transaccionId,
            'id_donante' => $donante->id,
            'id_usuario' => $usuarioId,
        ]);

        $aporte = AporteDinero::query()->create([
            'monto' => $monto,
            'fecha_recepcion' => Carbon::today()->toDateString(),
            'comprobante' => $transaccionId,
            'observaciones' => "Canal: {$canal} | Estado: Pendiente | Concepto: {$concepto}",
            'id_donacion' => $donacion->id,
        ]);

        // Generar payload dinámico para QR Bancario (ejemplo estándar Simple QR Bolivia / Pagos Móviles)
        $qrPayload = sprintf(
            'STK-PAY|%s|%.2f|BOB|%s|Los Angelitos de Edgar|%s',
            $transaccionId,
            $monto,
            $concepto,
            Carbon::now()->toIso8601String()
        );

        $auditoria->registrar(
            $request,
            $request->user(),
            'Iniciar pago/donación digital',
            'pasarela_pagos',
            entidad: $aporte,
            contexto: [
                'transaccion_id' => $transaccionId,
                'monto' => $monto,
                'canal' => $canal,
                'estado' => 'Pendiente',
            ],
        );

        return response()->json([
            'transaccion_id' => $transaccionId,
            'monto' => $monto,
            'canal' => $canal,
            'concepto' => $concepto,
            'estado' => 'Pendiente',
            'qr_payload' => $qrPayload,
            'aporte_id' => $aporte->id,
            'donante' => $donante->only(['id', 'nombre', 'telefono']),
        ], 201);
    }

    /**
     * CU27: Webhook para confirmar acreditación bancaria automática.
     */
    public function webhook(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'transaccion_id' => ['required', 'string'],
            'estado' => ['required', 'string', 'in:CONFIRMED,FAILED'],
            'firma' => ['nullable', 'string'],
        ]);

        $aporte = AporteDinero::query()
            ->where('comprobante', $validated['transaccion_id'])
            ->first();

        if (! $aporte) {
            return response()->json(['mensaje' => 'Transacción no encontrada.'], 404);
        }

        if ($validated['estado'] === 'CONFIRMED') {
            $obsActualizada = str_replace('Estado: Pendiente', 'Estado: Confirmado', (string) $aporte->observaciones);
            $aporte->update(['observaciones' => $obsActualizada]);

            $auditoria->registrar(
                $request,
                null,
                'Confirmación automática por Webhook',
                'pasarela_pagos',
                entidad: $aporte,
                contexto: ['transaccion_id' => $validated['transaccion_id'], 'estado' => 'Confirmado'],
            );

            return response()->json(['mensaje' => 'Transacción confirmada exitosamente.', 'estado' => 'Confirmado']);
        }

        return response()->json(['mensaje' => 'Notificación procesada.'], 200);
    }

    /**
     * CU27 FA1: Confirmación manual por cajero / recepcionista.
     */
    public function confirmarManual(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'id' => ['required', 'integer', 'exists:aporte_dineros,id'],
            'numero_comprobante_banco' => ['required', 'string', 'max:100'],
        ]);

        $aporte = AporteDinero::findOrFail($validated['id']);
        $obsActualizada = str_replace('Estado: Pendiente', 'Estado: Confirmado', (string) $aporte->observaciones);
        $obsActualizada .= ' | Ref Banco: '.$validated['numero_comprobante_banco'];
        $aporte->update(['observaciones' => $obsActualizada]);

        $auditoria->registrar(
            $request,
            $request->user(),
            'Confirmación manual de pago por cajero',
            'pasarela_pagos',
            entidad: $aporte,
            contexto: ['ref_banco' => $validated['numero_comprobante_banco']],
        );

        return response()->json([
            'mensaje' => 'Pago confirmado manualmente con éxito.',
            'aporte' => $aporte->fresh(),
        ]);
    }

    /**
     * CU28: Emitir y descargar comprobante / recibo digital.
     */
    public function generarComprobante(int $id): JsonResponse
    {
        $aporte = AporteDinero::with(['donacion.donante', 'donacion.usuario'])->findOrFail($id);

        $comprobante = [
            'numero_recibo' => 'REC-'.str_pad((string) $aporte->id, 6, '0', STR_PAD_LEFT),
            'transaccion_referencia' => $aporte->comprobante,
            'fecha_emision' => $aporte->fecha_recepcion,
            'albergue' => 'Albergue Los Angelitos de Edgar',
            'donante' => [
                'nombre' => $aporte->donacion?->donante?->nombre ?? 'Anónimo',
                'telefono' => $aporte->donacion?->donante?->telefono,
            ],
            'monto' => (float) $aporte->monto,
            'moneda' => 'BOB',
            'detalle' => $aporte->observaciones,
            'sello_digital' => hash('sha256', $aporte->comprobante.$aporte->monto.$aporte->fecha_recepcion),
            'qr_validacion' => url('/api/pasarela/comprobante/'.$aporte->id),
        ];

        return response()->json(['comprobante' => $comprobante]);
    }

    /**
     * CU29: Conciliar y arquear transacciones financieras.
     */
    public function conciliacion(Request $request): JsonResponse
    {
        $desde = $request->query('desde', Carbon::now()->startOfMonth()->toDateString());
        $hasta = $request->query('hasta', Carbon::now()->endOfMonth()->toDateString());

        $aportes = AporteDinero::query()
            ->with(['donacion.donante'])
            ->whereBetween('fecha_recepcion', [$desde, $hasta])
            ->orderByDesc('id')
            ->get();

        $arqueoCanales = [
            'QR' => ['cantidad' => 0, 'total' => 0.0],
            'Tarjeta' => ['cantidad' => 0, 'total' => 0.0],
            'Transferencia' => ['cantidad' => 0, 'total' => 0.0],
            'Efectivo' => ['cantidad' => 0, 'total' => 0.0],
        ];

        $totalGeneral = 0.0;
        $totalConfirmado = 0.0;
        $totalPendiente = 0.0;
        $totalReembolsado = 0.0;

        foreach ($aportes as $a) {
            $monto = (float) $a->monto;
            $obs = (string) $a->observaciones;

            $canal = 'Efectivo';
            if (str_contains($obs, 'Canal: QR')) {
                $canal = 'QR';
            } elseif (str_contains($obs, 'Canal: Tarjeta')) {
                $canal = 'Tarjeta';
            } elseif (str_contains($obs, 'Canal: Transferencia')) {
                $canal = 'Transferencia';
            }

            $estado = 'Confirmado';
            if (str_contains($obs, 'Estado: Pendiente')) {
                $estado = 'Pendiente';
                $totalPendiente += $monto;
            } elseif (str_contains($obs, 'Estado: Reembolsado')) {
                $estado = 'Reembolsado';
                $totalReembolsado += $monto;
            } else {
                $totalConfirmado += $monto;
            }

            $totalGeneral += $monto;

            if (isset($arqueoCanales[$canal])) {
                $arqueoCanales[$canal]['cantidad']++;
                $arqueoCanales[$canal]['total'] += $monto;
            }
        }

        return response()->json([
            'periodo' => ['desde' => $desde, 'hasta' => $hasta],
            'resumen' => [
                'total_transacciones' => $aportes->count(),
                'total_general' => round($totalGeneral, 2),
                'total_confirmado' => round($totalConfirmado, 2),
                'total_pendiente' => round($totalPendiente, 2),
                'total_reembolsado' => round($totalReembolsado, 2),
            ],
            'por_canal' => $arqueoCanales,
            'transacciones' => $aportes,
        ]);
    }

    /**
     * CU30: Gestionar anulación o reembolso de transacción.
     */
    public function reembolso(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'id' => ['required', 'integer', 'exists:aporte_dineros,id'],
            'justificacion' => ['required', 'string', 'max:500'],
        ]);

        $aporte = AporteDinero::findOrFail($validated['id']);

        if (str_contains((string) $aporte->observaciones, 'Estado: Reembolsado')) {
            throw ValidationException::withMessages([
                'id' => 'Esta transacción ya fue reembolsada con anterioridad.',
            ]);
        }

        $obsNueva = preg_replace('/Estado: [A-Za-z]+/', 'Estado: Reembolsado', (string) $aporte->observaciones);
        $obsNueva .= ' | Justificación Reembolso: '.$validated['justificacion'];
        $aporte->update(['observaciones' => $obsNueva]);

        $auditoria->registrar(
            $request,
            $request->user(),
            'Gestionar anulación / reembolso de transacción',
            'pasarela_pagos',
            entidad: $aporte,
            contexto: [
                'justificacion' => $validated['justificacion'],
                'monto' => $aporte->monto,
                'comprobante' => $aporte->comprobante,
            ],
        );

        return response()->json([
            'mensaje' => 'Transacción anulada y reembolsada exitosamente.',
            'aporte' => $aporte->fresh(),
        ]);
    }
}
