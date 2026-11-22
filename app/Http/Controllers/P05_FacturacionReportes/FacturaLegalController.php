<?php

namespace App\Http\Controllers\P05_FacturacionReportes;

use App\Http\Controllers\Controller;
use App\Models\CierrePeriodoReporte;
use App\Models\DetalleFacturaLegal;
use App\Models\DosificacionFiscal;
use App\Models\FacturaLegal;
use App\Services\AuditoriaForenseService;
use App\Services\Facturacion\CodigoControlService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

/**
 * Paquete P11: Facturación Legal y Normativa Tributaria
 * - CU32: Emitir Factura Legal Computarizada / Electrónica con Código de Control y QR
 * - CU33: Anular Factura Legal y Notificar al Libro de Ventas IVA
 */
class FacturaLegalController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        abort_unless(in_array($request->user()?->rol, ['Administrador', 'Recepcionista'], true), 403);

        $query = FacturaLegal::query()
            ->with(['detalles', 'emisor:id,nombre', 'anulador:id,nombre', 'dosificacion:id,nit_emisor,leyenda_tributaria'])
            ->orderByDesc('id');

        if ($request->filled('estado')) {
            $query->where('estado', $request->string('estado'));
        }

        if ($request->filled('buscar')) {
            $buscar = trim((string) $request->input('buscar'));
            $query->where(function ($q) use ($buscar): void {
                $q->where('nit_ci_cliente', 'ilike', "%{$buscar}%")
                    ->orWhere('razon_social_cliente', 'ilike', "%{$buscar}%")
                    ->orWhereRaw('CAST(numero_factura AS TEXT) ILIKE ?', ["%{$buscar}%"]);
            });
        }

        return response()->json([
            'facturas' => $query->limit(100)->get(),
            'dosificacion_activa' => DosificacionFiscal::query()->where('activa', true)->first(),
        ]);
    }

    public function store(
        Request $request,
        CodigoControlService $codigoControlService,
        AuditoriaForenseService $auditoria
    ): JsonResponse {
        abort_unless(in_array($request->user()?->rol, ['Administrador', 'Recepcionista'], true), 403);

        $validated = $request->validate([
            'nit_ci_cliente' => ['required', 'string', 'max:20'],
            'complemento_ci' => ['nullable', 'string', 'max:5'],
            'razon_social_cliente' => ['required', 'string', 'max:200'],
            'descuento' => ['nullable', 'numeric', 'min:0'],
            'items' => ['required', 'array', 'min:1'],
            'items.*.concepto' => ['required', 'string', 'max:255'],
            'items.*.cantidad' => ['required', 'numeric', 'gt:0'],
            'items.*.precio_unitario' => ['required', 'numeric', 'gte:0'],
            'items.*.referencia_tipo' => ['nullable', 'string', 'max:30'],
            'items.*.referencia_id' => ['nullable', 'integer'],
        ]);

        $dosificacion = DosificacionFiscal::query()->where('activa', true)->first();

        if ($dosificacion === null) {
            return response()->json([
                'mensaje' => 'No existe una dosificación fiscal activa. Configura una en CU31.',
            ], 422);
        }

        if ($dosificacion->fecha_limite_emision->isBefore(today())) {
            return response()->json([
                'mensaje' => 'La dosificación fiscal activa superó su fecha límite de emisión.',
            ], 422);
        }

        if ($dosificacion->correlativo_actual > $dosificacion->numero_final) {
            return response()->json([
                'mensaje' => 'Se alcanzó el límite máximo de numeración de la dosificación activa.',
            ], 422);
        }

        $factura = DB::transaction(function () use ($validated, $dosificacion, $request, $codigoControlService, $auditoria): FacturaLegal {
            $dosificacionLock = DosificacionFiscal::query()->lockForUpdate()->findOrFail($dosificacion->id);
            $numeroFactura = $dosificacionLock->correlativo_actual;

            $subtotal = 0.0;
            $itemsPreparados = [];
            foreach ($validated['items'] as $item) {
                $sub = round((float) $item['cantidad'] * (float) $item['precio_unitario'], 2);
                $subtotal += $sub;
                $itemsPreparados[] = [
                    'concepto' => trim($item['concepto']),
                    'cantidad' => (float) $item['cantidad'],
                    'precio_unitario' => (float) $item['precio_unitario'],
                    'subtotal' => $sub,
                    'referencia_tipo' => $item['referencia_tipo'] ?? null,
                    'referencia_id' => $item['referencia_id'] ?? null,
                ];
            }

            $descuento = round((float) ($validated['descuento'] ?? 0), 2);
            $importeTotal = max(0.0, round($subtotal - $descuento, 2));
            $importeBaseCf = $importeTotal;
            $debitoFiscal = round($importeBaseCf * 0.13, 2);

            $ahora = now();
            $codigoControl = $codigoControlService->generar(
                $dosificacionLock->numero_autorizacion,
                $numeroFactura,
                $validated['nit_ci_cliente'],
                $ahora->format('Ymd'),
                $importeTotal,
                (string) $dosificacionLock->llave_dosificacion
            );

            $cadenaQr = implode('|', [
                $dosificacionLock->nit_emisor,
                $numeroFactura,
                $dosificacionLock->numero_autorizacion,
                $ahora->format('d/m/Y'),
                number_format($importeTotal, 2, '.', ''),
                number_format($importeBaseCf, 2, '.', ''),
                $codigoControl,
                trim($validated['nit_ci_cliente']),
                '0.00',
                '0.00',
                number_format($descuento, 2, '.', ''),
            ]);

            $nueva = FacturaLegal::query()->create([
                'dosificacion_id' => $dosificacionLock->id,
                'numero_factura' => $numeroFactura,
                'numero_autorizacion' => $dosificacionLock->numero_autorizacion,
                'fecha_emision' => $ahora,
                'nit_ci_cliente' => trim($validated['nit_ci_cliente']),
                'complemento_ci' => $validated['complemento_ci'] ?? null,
                'razon_social_cliente' => trim($validated['razon_social_cliente']),
                'subtotal' => $subtotal,
                'descuento' => $descuento,
                'importe_total' => $importeTotal,
                'importe_base_cf' => $importeBaseCf,
                'debito_fiscal' => $debitoFiscal,
                'codigo_control' => $codigoControl,
                'cadena_qr' => $cadenaQr,
                'estado' => 'EMITIDA',
                'usuario_emisor_id' => $request->user()->id,
            ]);

            foreach ($itemsPreparados as $item) {
                DetalleFacturaLegal::query()->create([
                    'factura_id' => $nueva->id,
                    ...$item,
                ]);
            }

            $dosificacionLock->increment('correlativo_actual');

            $auditoria->registrar(
                $request,
                'INFO',
                'P11_FacturacionLegal',
                'EMITIR_FACTURA',
                'facturas_legales',
                $nueva->id,
                null,
                [
                    'numero_factura' => $numeroFactura,
                    'importe_total' => $importeTotal,
                    'codigo_control' => $codigoControl,
                ]
            );

            return $nueva->load(['detalles', 'emisor:id,nombre', 'dosificacion:id,nit_emisor,leyenda_tributaria']);
        });

        return response()->json([
            'mensaje' => 'Factura legal emitida correctamente.',
            'factura' => $factura,
        ], 201);
    }

    public function anular(Request $request, FacturaLegal $factura, AuditoriaForenseService $auditoria): JsonResponse
    {
        abort_unless(in_array($request->user()?->rol, ['Administrador', 'Recepcionista'], true), 403);

        $validated = $request->validate([
            'motivo_anulacion' => ['required', 'string', 'min:5', 'max:500'],
            'password' => ['required', 'string'],
        ]);

        if (! Hash::check($validated['password'], (string) $request->user()->password)) {
            $auditoria->registrar(
                $request,
                'WARNING',
                'P11_FacturacionLegal',
                'ANULACION_PASSWORD_INVALIDA',
                'facturas_legales',
                $factura->id
            );

            return response()->json([
                'mensaje' => 'Contraseña de confirmación incorrecta.',
            ], 422);
        }

        if ($factura->estado === 'ANULADA') {
            return response()->json([
                'mensaje' => 'La factura ya fue anulada previamente.',
            ], 422);
        }

        $periodoCerrado = CierrePeriodoReporte::query()
            ->where('anio', $factura->fecha_emision->year)
            ->where('mes', $factura->fecha_emision->month)
            ->where('tipo_reporte', 'LIBRO_VENTAS')
            ->where('periodo_cerrado', true)
            ->exists();

        if ($periodoCerrado) {
            return response()->json([
                'mensaje' => 'El periodo fiscal de esta factura ya se encuentra cerrado.',
            ], 422);
        }

        $anterior = [
            'estado' => $factura->estado,
            'importe_total' => $factura->importe_total,
        ];

        $factura->update([
            'estado' => 'ANULADA',
            'motivo_anulacion' => trim($validated['motivo_anulacion']),
            'fecha_anulacion' => now(),
            'usuario_anulador_id' => $request->user()->id,
        ]);

        $auditoria->registrar(
            $request,
            'CRITICAL',
            'P11_FacturacionLegal',
            'ANULAR_FACTURA',
            'facturas_legales',
            $factura->id,
            $anterior,
            [
                'estado' => 'ANULADA',
                'motivo_anulacion' => $factura->motivo_anulacion,
            ]
        );

        return response()->json([
            'mensaje' => 'Factura anulada y reflejada con importe cero en el Libro de Ventas IVA.',
            'factura' => $factura->fresh(['detalles', 'emisor:id,nombre', 'anulador:id,nombre']),
        ]);
    }
}
