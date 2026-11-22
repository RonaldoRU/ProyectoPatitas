<?php

namespace App\Http\Controllers\P05_FacturacionReportes;

use App\Http\Controllers\Controller;
use App\Models\CierrePeriodoReporte;
use App\Models\FacturaCompra;
use App\Models\FacturaLegal;
use App\Models\Proveedor;
use App\Services\AuditoriaForenseService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Paquete P13: Reportes Gerenciales y Fiscales
 * - CU36: Generar Libro de Compras y Ventas IVA Tributario
 */
class LibroIvaController extends Controller
{
    private const PERSONAL_AUTORIZADO = ['Administrador', 'Recepcionista'];

    public function index(Request $request): JsonResponse
    {
        abort_unless(in_array($request->user()?->rol, self::PERSONAL_AUTORIZADO, true), 403);

        $anio = (int) ($request->input('anio') ?: now()->year);
        $mes = (int) ($request->input('mes') ?: now()->month);

        $ventasRaw = FacturaLegal::query()
            ->whereYear('fecha_emision', $anio)
            ->whereMonth('fecha_emision', $mes)
            ->orderBy('numero_factura')
            ->get();

        $ventas = $ventasRaw->map(static function (FacturaLegal $f, int $idx): array {
            $anulada = $f->estado === 'ANULADA';

            return [
                'correlativo' => $idx + 1,
                'fecha' => $f->fecha_emision->format('d/m/Y'),
                'numero_factura' => $f->numero_factura,
                'numero_autorizacion' => $f->numero_autorizacion,
                'estado_iva' => $anulada ? 'A' : 'V',
                'nit_ci_cliente' => $anulada ? '0' : $f->nit_ci_cliente,
                'razon_social' => $anulada ? 'ANULADA' : $f->razon_social_cliente,
                'importe_total' => $anulada ? 0.0 : (float) $f->importe_total,
                'importe_base_cf' => $anulada ? 0.0 : (float) $f->importe_base_cf,
                'debito_fiscal' => $anulada ? 0.0 : (float) $f->debito_fiscal,
                'codigo_control' => $f->codigo_control,
            ];
        });

        $comprasRaw = FacturaCompra::query()
            ->whereYear('fecha_factura', $anio)
            ->whereMonth('fecha_factura', $mes)
            ->orderBy('fecha_factura')
            ->orderBy('id')
            ->get();

        $compras = $comprasRaw->map(static fn (FacturaCompra $c, int $idx): array => [
            'id' => $c->id,
            'correlativo' => $idx + 1,
            'fecha' => $c->fecha_factura->format('d/m/Y'),
            'nit_proveedor' => $c->nit_proveedor,
            'razon_social_proveedor' => $c->razon_social_proveedor,
            'numero_factura' => $c->numero_factura,
            'numero_autorizacion' => $c->numero_autorizacion,
            'codigo_control' => $c->codigo_control ?? '0',
            'importe_total' => (float) $c->importe_total,
            'importe_base_cf' => (float) $c->importe_base_cf,
            'credito_fiscal' => (float) $c->credito_fiscal,
        ]);

        $totalDebitoFiscal = round((float) $ventas->sum('debito_fiscal'), 2);
        $totalCreditoFiscal = round((float) $compras->sum('credito_fiscal'), 2);

        return response()->json([
            'anio' => $anio,
            'mes' => $mes,
            'ventas' => $ventas,
            'compras' => $compras,
            'proveedores' => Proveedor::query()
                ->selectRaw('id, nombre_empresa as nombre, COALESCE(identificacion, \'0\') as nit, nombre_empresa, identificacion')
                ->orderBy('nombre_empresa')
                ->get(),
            'resumen' => [
                'total_ventas' => round((float) $ventas->sum('importe_total'), 2),
                'total_debito_fiscal' => $totalDebitoFiscal,
                'total_compras' => round((float) $compras->sum('importe_total'), 2),
                'total_credito_fiscal' => $totalCreditoFiscal,
                'saldo_iva' => round($totalDebitoFiscal - $totalCreditoFiscal, 2),
            ],
        ]);
    }

    public function storeCompra(Request $request, AuditoriaForenseService $auditoria): JsonResponse
    {
        abort_unless(in_array($request->user()?->rol, self::PERSONAL_AUTORIZADO, true), 403);

        $validated = $request->validate([
            'proveedor_id' => ['required', 'integer', 'exists:proveedors,id'],
            'fecha_factura' => ['required', 'date'],
            'nit_proveedor' => ['required', 'string', 'max:20'],
            'razon_social_proveedor' => ['required', 'string', 'max:200'],
            'numero_factura' => ['required', 'string', 'max:30'],
            'numero_autorizacion' => ['required', 'string', 'max:50'],
            'codigo_control' => ['nullable', 'string', 'max:30'],
            'importe_total' => ['required', 'numeric', 'gt:0'],
            'importe_exento' => ['nullable', 'numeric', 'min:0'],
        ]);

        $total = round((float) $validated['importe_total'], 2);
        $exento = round((float) ($validated['importe_exento'] ?? 0), 2);
        $baseCf = max(0.0, round($total - $exento, 2));
        $creditoFiscal = round($baseCf * 0.13, 2);

        $compra = FacturaCompra::query()->create([
            'proveedor_id' => $validated['proveedor_id'],
            'fecha_factura' => $validated['fecha_factura'],
            'nit_proveedor' => trim($validated['nit_proveedor']),
            'razon_social_proveedor' => trim($validated['razon_social_proveedor']),
            'numero_factura' => trim($validated['numero_factura']),
            'numero_autorizacion' => trim($validated['numero_autorizacion']),
            'codigo_control' => $validated['codigo_control'] ?? null,
            'importe_total' => $total,
            'importe_exento' => $exento,
            'importe_base_cf' => $baseCf,
            'credito_fiscal' => $creditoFiscal,
            'registrado_por' => $request->user()->id,
        ]);

        $auditoria->registrar(
            $request,
            'INFO',
            'P13_ReportesFiscales',
            'REGISTRAR_FACTURA_COMPRA',
            'facturas_compras',
            $compra->id,
            null,
            ['numero_factura' => $compra->numero_factura, 'credito_fiscal' => $creditoFiscal]
        );

        return response()->json([
            'mensaje' => 'Factura de compra registrada para el Libro de Compras IVA.',
            'compra' => $compra,
        ], 201);
    }

    public function exportarCsv(Request $request): StreamedResponse
    {
        abort_unless(in_array($request->user()?->rol, self::PERSONAL_AUTORIZADO, true), 403);

        $tipo = $request->string('tipo')->toString() === 'compras' ? 'compras' : 'ventas';
        $data = $this->index($request)->getData(true);
        $filas = $tipo === 'compras' ? $data['compras'] : $data['ventas'];

        $hash = hash('sha256', json_encode($filas) ?: '');
        CierrePeriodoReporte::query()->create([
            'anio' => (int) $data['anio'],
            'mes' => (int) $data['mes'],
            'tipo_reporte' => $tipo === 'compras' ? 'LIBRO_COMPRAS' : 'LIBRO_VENTAS',
            'periodo_cerrado' => false,
            'hash_documento' => $hash,
            'generado_por' => $request->user()->id,
        ]);

        $filename = "libro-{$tipo}-iva-{$data['anio']}-{$data['mes']}.csv";

        return response()->streamDownload(function () use ($tipo, $filas): void {
            $out = fopen('php://output', 'w');
            if ($out === false) {
                return;
            }
            if ($tipo === 'ventas') {
                fputcsv($out, ['Nro', 'Fecha', 'Nro Factura', 'Nro Autorizacion', 'Estado', 'NIT/CI', 'Razon Social', 'Importe Total', 'Base CF', 'Debito Fiscal 13%', 'Codigo Control'], '|');
                foreach ($filas as $f) {
                    fputcsv($out, [
                        $f['correlativo'],
                        $f['fecha'],
                        $f['numero_factura'],
                        $f['numero_autorizacion'],
                        $f['estado_iva'],
                        $f['nit_ci_cliente'],
                        $f['razon_social'],
                        number_format((float) $f['importe_total'], 2, '.', ''),
                        number_format((float) $f['importe_base_cf'], 2, '.', ''),
                        number_format((float) $f['debito_fiscal'], 2, '.', ''),
                        $f['codigo_control'],
                    ], '|');
                }
            } else {
                fputcsv($out, ['Nro', 'Fecha', 'NIT Proveedor', 'Razon Social', 'Nro Factura', 'Nro Autorizacion', 'Codigo Control', 'Importe Total', 'Base CF', 'Credito Fiscal 13%'], '|');
                foreach ($filas as $c) {
                    fputcsv($out, [
                        $c['correlativo'],
                        $c['fecha'],
                        $c['nit_proveedor'],
                        $c['razon_social_proveedor'],
                        $c['numero_factura'],
                        $c['numero_autorizacion'],
                        $c['codigo_control'],
                        number_format((float) $c['importe_total'], 2, '.', ''),
                        number_format((float) $c['importe_base_cf'], 2, '.', ''),
                        number_format((float) $c['credito_fiscal'], 2, '.', ''),
                    ], '|');
                }
            }
            fclose($out);
        }, $filename, ['Content-Type' => 'text/csv; charset=UTF-8']);
    }
}
