<?php

namespace App\Http\Controllers\P05_FacturacionReportes;

use App\Http\Controllers\Controller;
use App\Models\CierrePeriodoReporte;
use App\Models\FacturaCompra;
use App\Models\FacturaLegal;
use App\Services\AuditoriaForenseService;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Paquete P13: Reportes Gerenciales y Fiscales
 * - CU37: Exportar Estados Financieros y Rendición de Cuentas para Entidades Reguladoras
 */
class RendicionCuentasController extends Controller
{
    private const PERSONAL_AUTORIZADO = ['Administrador', 'Recepcionista'];

    public function index(Request $request): JsonResponse
    {
        abort_unless(in_array($request->user()?->rol, self::PERSONAL_AUTORIZADO, true), 403);

        $fechaInicio = $request->input('fecha_inicio') ?: Carbon::now()->startOfYear()->toDateString();
        $fechaFin = $request->input('fecha_fin') ?: Carbon::now()->toDateString();
        $plantilla = $request->input('plantilla') ?: 'Informe Semestral Entidad Pública';

        $ingresosDonaciones = (float) (DB::table('aporte_dineros')
            ->whereBetween('fecha_recepcion', [$fechaInicio, $fechaFin])
            ->sum('monto') ?? 0);

        $ingresosFacturacion = (float) FacturaLegal::query()
            ->where('estado', 'EMITIDA')
            ->whereDate('fecha_emision', '>=', $fechaInicio)
            ->whereDate('fecha_emision', '<=', $fechaFin)
            ->sum('importe_total');

        $egresosFacturasCompras = (float) FacturaCompra::query()
            ->whereDate('fecha_factura', '>=', $fechaInicio)
            ->whereDate('fecha_factura', '<=', $fechaFin)
            ->sum('importe_total');

        $egresosComprasInventario = (float) (DB::table('compras')
            ->whereBetween('fecha_compra', [$fechaInicio, $fechaFin])
            ->sum('monto_total') ?? 0);

        $valorInventarioActual = (float) (DB::table('articulo_inventarios')
            ->selectRaw('COALESCE(SUM(stock_actual), 0) as unidades')
            ->value('unidades') ?? 0);

        $totalIngresos = round($ingresosDonaciones + $ingresosFacturacion, 2);
        $totalEgresos = round($egresosFacturasCompras + $egresosComprasInventario, 2);
        $saldoNeto = round($totalIngresos - $totalEgresos, 2);

        $cadenaIntegridad = implode('|', [
            $plantilla,
            $fechaInicio,
            $fechaFin,
            number_format($totalIngresos, 2, '.', ''),
            number_format($totalEgresos, 2, '.', ''),
            number_format($saldoNeto, 2, '.', ''),
        ]);
        $hashSha256 = hash('sha256', $cadenaIntegridad);

        $historialCierres = CierrePeriodoReporte::query()
            ->with('generador:id,nombre')
            ->where('tipo_reporte', 'RENDICION_CUENTAS')
            ->orderByDesc('id')
            ->limit(15)
            ->get();

        return response()->json([
            'plantilla' => $plantilla,
            'fecha_inicio' => $fechaInicio,
            'fecha_fin' => $fechaFin,
            'ingresos' => [
                'donaciones_monetarias' => round($ingresosDonaciones, 2),
                'servicios_facturados' => round($ingresosFacturacion, 2),
                'total' => $totalIngresos,
            ],
            'egresos' => [
                'facturas_compras_iva' => round($egresosFacturasCompras, 2),
                'compras_abastecimiento' => round($egresosComprasInventario, 2),
                'total' => $totalEgresos,
            ],
            'balance' => [
                'saldo_neto' => $saldoNeto,
                'unidades_inventario_actual' => round($valorInventarioActual, 2),
            ],
            'hash_integridad' => $hashSha256,
            'historial_emisiones' => $historialCierres,
        ]);
    }

    public function emitirOficial(Request $request, AuditoriaForenseService $auditoria): JsonResponse
    {
        abort_unless(in_array($request->user()?->rol, self::PERSONAL_AUTORIZADO, true), 403);

        $datos = $this->index($request)->getData(true);
        $fechaFin = Carbon::parse((string) $datos['fecha_fin']);

        $cierre = CierrePeriodoReporte::query()->create([
            'anio' => $fechaFin->year,
            'mes' => $fechaFin->month,
            'tipo_reporte' => 'RENDICION_CUENTAS',
            'periodo_cerrado' => false,
            'hash_documento' => (string) $datos['hash_integridad'],
            'generado_por' => $request->user()->id,
        ]);

        $auditoria->registrar(
            $request,
            'INFO',
            'P13_ReportesFiscales',
            'EMITIR_RENDICION_CUENTAS',
            'cierres_periodos_reportes',
            $cierre->id,
            null,
            ['hash_documento' => $cierre->hash_documento, 'plantilla' => $datos['plantilla']]
        );

        return response()->json([
            'mensaje' => 'Rendición de cuentas certificada con sello SHA-256.',
            'cierre' => $cierre,
            'datos' => $datos,
        ], 201);
    }
}
