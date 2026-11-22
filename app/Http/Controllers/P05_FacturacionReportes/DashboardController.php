<?php

namespace App\Http\Controllers\P05_FacturacionReportes;

use App\Http\Controllers\Controller;
use App\Models\ArticuloInventario;
use App\Services\InventarioLotesService;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Controlador Principal de Indicadores Operativos y Inteligencia del Refugio (Dashboard BI)
 */
class DashboardController extends Controller
{
    /**
     * Obtiene métricas detalladas, proyecciones, alertas de farmacia, ingresos con fotos y auditoría en vivo.
     */
    public function getDashboardData(Request $request, InventarioLotesService $inventario): JsonResponse
    {
        $today = Carbon::now();

        $animalesRefugio = DB::table('mascotas')
            ->whereNotIn('estado_actual', ['Adoptado', 'Fallecido'])
            ->count();

        $listosAdopcion = DB::table('mascotas')
            ->whereIn('estado_actual', ['Disponible', 'Disponible para Adopción'])
            ->count();

        $enTratamiento = DB::table('mascotas')
            ->whereIn('estado_actual', ['En Recuperación', 'En tratamiento', 'En Tratamiento'])
            ->count();

        $totalMascotas = DB::table('mascotas')->count();

        $adopcionesMes = DB::table('adopcions')
            ->join('mascotas', 'adopcions.id_mascota', '=', 'mascotas.id')
            ->whereRaw("LOWER(mascotas.estado_actual) LIKE '%adoptad%'")
            ->whereBetween('adopcions.fecha_adopcion', [
                $today->copy()->startOfMonth()->toDateString(),
                $today->copy()->endOfMonth()->toDateString(),
            ])
            ->distinct('adopcions.id_mascota')
            ->count('adopcions.id_mascota');

        $totalAdopciones = DB::table('mascotas')
            ->whereRaw("LOWER(estado_actual) LIKE '%adoptad%'")
            ->count();
        $postulantesCount = Schema::hasTable('interesado_adopcions') ? DB::table('interesado_adopcions')->count() : 0;
        $donacionesBs = Schema::hasTable('aporte_dineros') ? (float) DB::table('aporte_dineros')->sum('monto') : 0.0;
        $donacionesCount = Schema::hasTable('donacions') ? DB::table('donacions')->count() : 0;
        $facturacionBs = Schema::hasTable('facturas_legales')
            ? (float) DB::table('facturas_legales')->where('estado', 'EMITIDA')->sum('importe_total')
            : 0.0;
        $facturasEmitidas = Schema::hasTable('facturas_legales')
            ? DB::table('facturas_legales')->where('estado', 'EMITIDA')->count()
            : 0;
        $gastosComprasBs = Schema::hasTable('compras') ? (float) DB::table('compras')->sum('monto_total') : 0.0;
        $atencionesClinicas = Schema::hasTable('historial_clinicos') ? DB::table('historial_clinicos')->count() : 0;
        $prescripcionesActivas = Schema::hasTable('prescripciones_dosificacion') ? DB::table('prescripciones_dosificacion')->count() : 0;
        $visitasSeguimiento = Schema::hasTable('seguimiento_adopcions') ? DB::table('seguimiento_adopcions')->count() : 0;

        $stats = [
            'animales_refugio' => $animalesRefugio,
            'listos_adopcion' => $listosAdopcion,
            'adopciones_mes' => $adopcionesMes,
            'alertas_stock' => $this->countLowStockAlerts($inventario),
            'total_mascotas' => $totalMascotas,
            'en_tratamiento' => $enTratamiento,
            'total_adopciones' => $totalAdopciones,
            'postulantes_evaluados' => $postulantesCount,
            'donaciones_total_bs' => round($donacionesBs, 2),
            'donaciones_count' => $donacionesCount,
            'facturacion_total_bs' => round($facturacionBs, 2),
            'facturas_emitidas' => $facturasEmitidas,
            'gastos_compras_bs' => round($gastosComprasBs, 2),
            'atenciones_clinicas' => $atencionesClinicas,
            'prescripciones_activas' => $prescripcionesActivas,
            'visitas_seguimiento' => $visitasSeguimiento,
        ];

        $ultimosIngresos = DB::table('mascotas')
            ->select('id', 'nombre', 'especie', 'raza', 'edad', 'sexo', 'zona_rescate', 'fecha_ingreso', 'estado_actual', 'foto')
            ->orderByDesc('fecha_ingreso')
            ->limit(6)
            ->get();

        $auditoriaReciente = Schema::hasTable('bitacoras')
            ? DB::table('bitacoras')
                ->select('id', 'tipo_accion', 'modulo', 'descripcion', 'usuario_nombre', 'created_at')
                ->orderByDesc('id')
                ->limit(5)
                ->get()
            : [];

        $mesesNombres = [
            1 => 'Ene', 2 => 'Feb', 3 => 'Mar', 4 => 'Abr', 5 => 'May', 6 => 'Jun',
            7 => 'Jul', 8 => 'Ago', 9 => 'Sep', 10 => 'Oct', 11 => 'Nov', 12 => 'Dic',
        ];
        $evolucionMensual = [];
        foreach ([6, 7, 8, 9, 10, 11] as $mNum) {
            $inicioM = Carbon::create(2026, $mNum, 1)->startOfMonth()->toDateString();
            $finM = Carbon::create(2026, $mNum, 1)->endOfMonth()->toDateString();

            $gastoM = Schema::hasTable('compras')
                ? (float) DB::table('compras')->whereBetween('fecha_compra', [$inicioM, $finM])->sum('monto_total')
                : 0.0;
            $ingresoM = Schema::hasTable('aporte_dineros')
                ? (float) DB::table('aporte_dineros')->whereBetween('fecha_recepcion', [$inicioM, $finM])->sum('monto')
                : 0.0;
            $factM = Schema::hasTable('facturas_legales')
                ? (float) DB::table('facturas_legales')
                    ->where('estado', 'EMITIDA')
                    ->whereBetween('fecha_emision', [$inicioM.' 00:00:00', $finM.' 23:59:59'])
                    ->sum('importe_total')
                : 0.0;
            $adopM = DB::table('adopcions')
                ->join('mascotas', 'adopcions.id_mascota', '=', 'mascotas.id')
                ->whereRaw("LOWER(mascotas.estado_actual) LIKE '%adoptad%'")
                ->whereBetween('adopcions.fecha_adopcion', [$inicioM, $finM])
                ->distinct('adopcions.id_mascota')
                ->count('adopcions.id_mascota');
            $rescM = DB::table('mascotas')->whereBetween('fecha_ingreso', [$inicioM, $finM])->count();

            $evolucionMensual[] = [
                'mes' => $mesesNombres[$mNum],
                'etiqueta' => $mNum >= 10 ? 'Consolidado' : 'Histórico',
                'gastos_bs' => round($gastoM, 2),
                'ingresos_bs' => round($ingresoM + $factM, 2),
                'adopciones' => $adopM,
                'rescates' => $rescM,
            ];
        }

        $user = $request->user();
        $puedeVerVencimientos = in_array($user?->rol, ['Administrador', 'Veterinario'], true);

        return response()->json([
            'stats' => $stats,
            'ultimos_ingresos' => $ultimosIngresos,
            'alertas_vencimiento' => $puedeVerVencimientos
                ? $inventario->alertas($today)
                : ['proximos' => [], 'vencidos' => [], 'sin_fecha' => []],
            'evolucion_mensual' => $evolucionMensual,
            'auditoria_reciente' => $auditoriaReciente,
            'user' => [
                'nombre' => $user?->nombre ?? 'Administrador',
                'rol' => $user?->rol ?? 'Staff',
            ],
        ]);
    }

    private function countLowStockAlerts(InventarioLotesService $inventario): int
    {
        $articulos = ArticuloInventario::query()
            ->select(['id', 'categoria', 'stock_actual', 'stock_minimo_alerta'])
            ->get();
        $stocksDisponibles = $inventario->stocksDisponibles($articulos);

        return $articulos->filter(fn (ArticuloInventario $articulo): bool => ($stocksDisponibles[$articulo->getKey()] ?? 0) / 100
            <= (float) $articulo->stock_minimo_alerta)->count();
    }
}
