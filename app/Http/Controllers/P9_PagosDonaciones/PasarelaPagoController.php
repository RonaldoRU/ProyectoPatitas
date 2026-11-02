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
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
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
                'tipo_persona' => 'Natural',
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

        $stripeData = null;
        if ($canal === 'Tarjeta' && config('services.stripe.secret')) {
            try {
                $stripeRes = Http::asForm()
                    ->withToken(config('services.stripe.secret'))
                    ->post('https://api.stripe.com/v1/payment_intents', [
                        'amount' => (int) round($monto * 100),
                        'currency' => 'usd',
                        'automatic_payment_methods' => ['enabled' => 'true'],
                        'description' => "Donacion Refugio - {$donante->nombre} ({$concepto})",
                        'metadata' => [
                            'transaccion_id' => $transaccionId,
                            'aporte_id' => (string) $aporte->id,
                        ],
                    ]);

                if ($stripeRes->successful()) {
                    $stripeClientSecret = $stripeRes->json('client_secret');
                    $stripePaymentIntentId = $stripeRes->json('id');
                    $aporte->update([
                        'observaciones' => "Canal: Tarjeta (Stripe Sandbox) | Estado: Pendiente | Concepto: {$concepto} | Stripe ID: {$stripePaymentIntentId}",
                    ]);

                    $stripeData = [
                        'client_secret' => $stripeClientSecret,
                        'payment_intent_id' => $stripePaymentIntentId,
                        'publishable_key' => config('services.stripe.key'),
                    ];
                }
            } catch (\Throwable $e) {
                Log::warning('Error comunicando con Stripe API: '.$e->getMessage());
            }
        }

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
                'stripe' => $stripeData ? true : false,
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
            'stripe' => $stripeData,
        ], 201);
    }

    /**
     * CU27: Webhook para confirmar acreditación bancaria automática (Soporta Simple QR y Stripe).
     */
    public function webhook(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        // Soporte para webhook nativo de Stripe
        if ($request->has('type')) {
            $eventType = $request->input('type');
            if ($eventType === 'payment_intent.succeeded') {
                $object = $request->input('data.object', []);
                $stripeId = $object['id'] ?? null;
                $transaccionId = $object['metadata']['transaccion_id'] ?? null;

                $aporte = null;
                if ($transaccionId) {
                    $aporte = AporteDinero::query()->where('comprobante', $transaccionId)->first();
                }
                if (! $aporte && $stripeId) {
                    $aporte = AporteDinero::query()->where('observaciones', 'like', "%{$stripeId}%")->first();
                }

                if ($aporte) {
                    $obsActualizada = str_replace('Estado: Pendiente', 'Estado: Confirmado', (string) $aporte->observaciones);
                    $obsActualizada .= ' | Stripe Webhook: Acreditado';
                    $aporte->update(['observaciones' => $obsActualizada]);

                    $auditoria->registrar(
                        $request,
                        null,
                        'Confirmación automática por Webhook Stripe',
                        'pasarela_pagos',
                        entidad: $aporte,
                        contexto: ['stripe_id' => $stripeId, 'estado' => 'Confirmado'],
                    );

                    return response()->json(['status' => 'success'], 200);
                }
            }

            return response()->json(['status' => 'ignored'], 200);
        }

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
     * CU27 FA2: Confirmar pago con tarjeta en Stripe Sandbox.
     */
    public function confirmarTarjeta(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'id' => ['required', 'integer', 'exists:aporte_dineros,id'],
            'payment_method' => ['nullable', 'string', 'max:100'],
        ]);

        $aporte = AporteDinero::findOrFail($validated['id']);
        $obsActual = (string) $aporte->observaciones;

        $paymentIntentId = null;
        if (preg_match('/Stripe ID:\s*(pi_[a-zA-Z0-9]+)/', $obsActual, $matches)) {
            $paymentIntentId = $matches[1];
        }

        $stripeStatus = 'succeeded';
        if ($paymentIntentId && config('services.stripe.secret')) {
            try {
                $confirmRes = Http::asForm()
                    ->withToken(config('services.stripe.secret'))
                    ->post("https://api.stripe.com/v1/payment_intents/{$paymentIntentId}/confirm", [
                        'payment_method' => $validated['payment_method'] ?? 'pm_card_visa',
                        'return_url' => url('/pasarela-pagos'),
                    ]);

                if ($confirmRes->failed()) {
                    $errorMsg = $confirmRes->json('error.message') ?? 'Error al procesar tarjeta con Stripe.';

                    return response()->json(['mensaje' => $errorMsg], 422);
                }

                $stripeStatus = $confirmRes->json('status', 'succeeded');
            } catch (\Throwable $e) {
                Log::error('Stripe confirm error: '.$e->getMessage());

                return response()->json(['mensaje' => 'No se pudo comunicar con Stripe Sandbox.'], 502);
            }
        }

        $obsActualizada = str_replace('Estado: Pendiente', 'Estado: Confirmado', $obsActual);
        if ($paymentIntentId) {
            $obsActualizada .= " | Stripe Status: {$stripeStatus}";
        } else {
            $obsActualizada .= ' | Tarjeta Aprobada (Simulación)';
        }

        $aporte->update(['observaciones' => $obsActualizada]);

        $auditoria->registrar(
            $request,
            $request->user(),
            'Confirmación de pago con tarjeta en Stripe Sandbox',
            'pasarela_pagos',
            entidad: $aporte,
            contexto: [
                'transaccion_id' => $aporte->comprobante,
                'stripe_id' => $paymentIntentId,
                'estado' => 'Confirmado',
            ],
        );

        return response()->json([
            'mensaje' => '¡Pago con tarjeta procesado y confirmado exitosamente en Stripe Sandbox!',
            'aporte' => $aporte->fresh(),
            'stripe_status' => $stripeStatus,
        ]);
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

        $montoFloat = (float) $aporte->monto;
        $centavos = round(($montoFloat - floor($montoFloat)) * 100);
        $literal = $this->numeroALetras(floor($montoFloat)).' '.str_pad((string) $centavos, 2, '0', STR_PAD_LEFT).'/100 Bolivianos';

        $canal = 'Caja Central (Efectivo)';
        if (str_contains((string) $aporte->observaciones, 'Canal: QR') || str_contains((string) $aporte->comprobante, 'QR')) {
            $canal = 'Pasarela Digital (Simple QR Interoperable)';
        } elseif (str_contains((string) $aporte->observaciones, 'Canal: Tarjeta')) {
            $canal = 'Pasarela Digital (Stripe Sandbox - Tarjeta Débito/Crédito)';
        }

        $comprobante = [
            'numero_recibo' => 'REC-'.str_pad((string) $aporte->id, 6, '0', STR_PAD_LEFT),
            'transaccion_referencia' => $aporte->comprobante,
            'fecha_emision' => $aporte->fecha_recepcion,
            'hora_emision' => $aporte->created_at ? $aporte->created_at->format('H:i:s') : '12:00:00',
            'albergue' => 'Albergue Los Angelitos de Edgar',
            'albergue_nit' => 'NIT: 4892019018 • Personería Jurídica N° 342/2021',
            'albergue_direccion' => 'Av. San Martín #450, Santa Cruz de la Sierra, Bolivia',
            'donante' => [
                'nombre' => $aporte->donacion?->donante?->nombre ?? 'Donante Solidario',
                'telefono' => $aporte->donacion?->donante?->telefono ?? 'Sin teléfono',
                'tipo_persona' => $aporte->donacion?->donante?->tipo_persona ?? 'Natural',
            ],
            'monto' => $montoFloat,
            'monto_literal' => $literal,
            'moneda' => 'BOB',
            'canal' => $canal,
            'cajero_responsable' => $aporte->donacion?->usuario?->nombre ?? 'Caja Central Albergue',
            'detalle' => $aporte->observaciones,
            'sello_digital' => hash('sha256', $aporte->comprobante.$aporte->monto.$aporte->fecha_recepcion),
            'qr_validacion' => url('/api/pasarela/comprobante/'.$aporte->id),
        ];

        return response()->json(['comprobante' => $comprobante]);
    }

    private function numeroALetras(float|int $numero): string
    {
        $unidades = ['', 'Uno', 'Dos', 'Tres', 'Cuatro', 'Cinco', 'Seis', 'Siete', 'Ocho', 'Nueve'];
        $decenas = ['', 'Diez', 'Veinte', 'Treinta', 'Cuarenta', 'Cincuenta', 'Sesenta', 'Setenta', 'Ochenta', 'Noventa'];
        $dieces = ['Diez', 'Once', 'Doce', 'Trece', 'Catorce', 'Quince', 'Dieciséis', 'Diecisiete', 'Dieciocho', 'Diecinueve'];
        $centenas = ['', 'Ciento', 'Doscientos', 'Trescientos', 'Cuatrocientos', 'Quinientos', 'Seiscientos', 'Setecientos', 'Ochocientos', 'Novecientos'];

        $num = (int) $numero;
        if ($num === 0) {
            return 'Cero';
        }
        if ($num === 100) {
            return 'Cien';
        }

        $resultado = '';
        if ($num >= 1000) {
            $miles = intdiv($num, 1000);
            $resultado .= ($miles === 1 ? 'Mil ' : $unidades[$miles].' Mil ');
            $num %= 1000;
        }

        if ($num >= 100) {
            $c = intdiv($num, 100);
            $resultado .= $centenas[$c].' ';
            $num %= 100;
        }

        if ($num >= 10 && $num < 20) {
            $resultado .= $dieces[$num - 10].' ';
        } elseif ($num >= 20) {
            $d = intdiv($num, 10);
            $u = $num % 10;
            if ($u === 0) {
                $resultado .= $decenas[$d].' ';
            } else {
                $resultado .= $decenas[$d].' y '.$unidades[$u].' ';
            }
        } elseif ($num > 0) {
            $resultado .= $unidades[$num].' ';
        }

        return trim($resultado);
    }

    /**
     * CU29: Conciliar y arquear transacciones financieras.
     */
    public function conciliacion(Request $request): JsonResponse
    {
        $desde = $request->query('desde');
        $hasta = $request->query('hasta');

        $query = AporteDinero::query()->with(['donacion.donante']);

        if ($desde && $hasta) {
            $query->whereBetween('fecha_recepcion', [$desde, $hasta]);
        }

        $aportes = $query->orderByDesc('id')->get();

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

        $obsActual = (string) $aporte->observaciones;
        $stripeRefundId = null;

        // Si fue pagado por Stripe, solicitar reembolso a la API de Stripe Sandbox
        if (preg_match('/Stripe ID:\s*(pi_[a-zA-Z0-9]+)/', $obsActual, $matches) && config('services.stripe.secret')) {
            $stripePaymentIntentId = $matches[1];
            try {
                $refundRes = Http::asForm()
                    ->withToken(config('services.stripe.secret'))
                    ->post('https://api.stripe.com/v1/refunds', [
                        'payment_intent' => $stripePaymentIntentId,
                        'reason' => 'requested_by_customer',
                    ]);

                if ($refundRes->successful()) {
                    $stripeRefundId = $refundRes->json('id');
                }
            } catch (\Throwable $e) {
                Log::warning('Error en reembolso Stripe: '.$e->getMessage());
            }
        }

        $obsNueva = preg_replace('/Estado: [A-Za-z]+/', 'Estado: Reembolsado', $obsActual);
        $obsNueva .= ' | Justificación Reembolso: '.$validated['justificacion'];
        if ($stripeRefundId) {
            $obsNueva .= " | Stripe Refund ID: {$stripeRefundId}";
        }
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
                'stripe_refund_id' => $stripeRefundId,
            ],
        );

        return response()->json([
            'mensaje' => 'Transacción anulada y reembolsada exitosamente.'.($stripeRefundId ? ' Reembolso procesado en Stripe Sandbox.' : ''),
            'aporte' => $aporte->fresh(),
        ]);
    }
}
