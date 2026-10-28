<?php

namespace App\Http\Controllers\P10_IndicadoresGerenciales;

use App\Http\Controllers\Controller;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Paquete P10: Indicadores Gerenciales y Reportes Estadísticos
 * Casos de Uso:
 * - CU25: Generar Reportes Estadísticos e Indicadores Gerenciales
 */
class ReporteGerencialController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $this->authorizeAdmin($request);

        $now = Carbon::now();
        $meses = [];

        // Generar métricas de los últimos 6 meses
        for ($i = 5; $i >= 0; $i--) {
            $mes = $now->copy()->subMonths($i);
            $inicio = $mes->copy()->startOfMonth()->toDateString();
            $fin = $mes->copy()->endOfMonth()->toDateString();
            $nombreMes = $mes->translatedFormat('F Y');

            $adopciones = DB::table('adopcions')
                ->whereBetween('fecha_adopcion', [$inicio, $fin])
                ->count();

            $rescates = DB::table('mascotas')
                ->whereBetween('fecha_ingreso', [$inicio, $fin])
                ->count();

            $ingresosMonetarios = (float) (DB::table('aporte_dineros')
                ->whereBetween('fecha_recepcion', [$inicio, $fin])
                ->sum('monto') ?? 0);

            $meses[] = [
                'mes' => $nombreMes,
                'adopciones' => $adopciones,
                'rescates' => $rescates,
                'ingresos_donaciones' => $ingresosMonetarios,
            ];
        }

        // Top artículos e insumos consumidos (rotación de inventario)
        $topInsumos = DB::table('detalle_salidas')
            ->join('articulo_inventarios', 'detalle_salidas.id_articulo', '=', 'articulo_inventarios.id')
            ->select(
                'articulo_inventarios.nombre',
                'articulo_inventarios.categoria',
                'articulo_inventarios.unidad_medida',
                DB::raw('SUM(detalle_salidas.cantidad) as total_consumido')
            )
            ->groupBy('articulo_inventarios.id', 'articulo_inventarios.nombre', 'articulo_inventarios.categoria', 'articulo_inventarios.unidad_medida')
            ->orderByDesc('total_consumido')
            ->limit(5)
            ->get();

        // Distribución de población actual de animales
        $poblacionPorEstado = DB::table('mascotas')
            ->select('estado_actual', DB::raw('count(*) as total'))
            ->groupBy('estado_actual')
            ->get();

        $poblacionPorEspecie = DB::table('mascotas')
            ->select('especie', DB::raw('count(*) as total'))
            ->groupBy('especie')
            ->get();

        // Tasa global de adopción vs rescate
        $totalRescates = DB::table('mascotas')->count();
        $totalAdopciones = DB::table('adopcions')->count();
        $tasaAdopcion = $totalRescates > 0 ? round(($totalAdopciones / $totalRescates) * 100, 1) : 0;

        return response()->json([
            'evolucion_mensual' => $meses,
            'top_insumos_consumidos' => $topInsumos,
            'poblacion_por_estado' => $poblacionPorEstado,
            'poblacion_por_especie' => $poblacionPorEspecie,
            'indicadores_clave' => [
                'total_rescates_historico' => $totalRescates,
                'total_adopciones_historico' => $totalAdopciones,
                'tasa_adopcion_porcentaje' => $tasaAdopcion,
                'total_donaciones_monto' => (float) (DB::table('aporte_dineros')->sum('monto') ?? 0),
            ],
        ]);
    }

    public function exportar(Request $request): JsonResponse
    {
        $this->authorizeAdmin($request);

        $datos = $this->index($request)->getData(true);

        return response()->json([
            'titulo' => 'Informe Gerencial Consolidado - Los Angelitos de Edgar',
            'fecha_generacion' => Carbon::now()->toDateTimeString(),
            'generado_por' => $request->user()?->nombre ?? 'Administrador',
            'datos' => $datos,
        ]);
    }

    private function authorizeAdmin(Request $request): void
    {
        abort_unless($request->user()?->rol === 'Administrador', 403);
    }
}
