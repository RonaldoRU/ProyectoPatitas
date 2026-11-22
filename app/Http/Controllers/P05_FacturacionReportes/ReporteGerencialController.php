<?php

namespace App\Http\Controllers\P05_FacturacionReportes;

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
    /**
     * CU25: Generar Indicadores y Estadísticas Semestrales
     * Calcula comparativa de rescates vs adopciones, donaciones monetarias y rotación de insumos médicos.
     */
    public function index(Request $request): JsonResponse
    {
        $this->authorizeAdmin($request);

        $now = Carbon::now();
        $minIngreso = DB::table('mascotas')->min('fecha_ingreso');
        $defaultDesde = $minIngreso ? Carbon::parse((string) $minIngreso)->startOfMonth() : $now->copy()->subMonths(11)->startOfMonth();
        $fechaDesdeInput = $request->query('fecha_desde');
        $fechaHastaInput = $request->query('fecha_hasta');
        $especieFiltro = trim((string) $request->query('especie', ''));

        $desde = $fechaDesdeInput ? Carbon::parse((string) $fechaDesdeInput)->startOfDay() : $defaultDesde->copy()->startOfDay();
        $hasta = $fechaHastaInput ? Carbon::parse((string) $fechaHastaInput)->endOfDay() : $now->copy()->endOfDay();

        if ($desde->gt($hasta)) {
            [$desde, $hasta] = [$hasta->copy()->startOfDay(), $desde->copy()->endOfDay()];
        }

        $meses = [];
        $cursor = $desde->copy()->startOfMonth();
        $finMes = $hasta->copy()->startOfMonth();
        $maxMeses = 24;
        $iteraciones = 0;

        while ($cursor->lte($finMes) && $iteraciones < $maxMeses) {
            $inicio = $cursor->copy()->startOfMonth()->toDateString();
            $fin = $cursor->copy()->endOfMonth()->toDateString();
            $nombreMes = $cursor->translatedFormat('F Y');

            $adopciones = DB::table('adopcions')
                ->join('mascotas', 'adopcions.id_mascota', '=', 'mascotas.id')
                ->whereRaw("LOWER(mascotas.estado_actual) LIKE '%adoptad%'")
                ->whereBetween('adopcions.fecha_adopcion', [$inicio, $fin])
                ->distinct('adopcions.id_mascota')
                ->count('adopcions.id_mascota');

            $rescates = DB::table('mascotas')
                ->whereBetween('fecha_ingreso', [$inicio, $fin])
                ->when($especieFiltro !== '', fn ($q) => $q->where('especie', $especieFiltro))
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

            $cursor->addMonth();
            $iteraciones++;
        }

        $mascotasRescatadas = DB::table('mascotas')
            ->select('id', 'nombre', 'especie', 'raza', 'sexo', 'edad', 'estado_actual', 'zona_rescate', 'fecha_ingreso')
            ->whereBetween('fecha_ingreso', [$desde->toDateString(), $hasta->toDateString()])
            ->when($especieFiltro !== '', fn ($q) => $q->where('especie', $especieFiltro))
            ->orderByDesc('fecha_ingreso')
            ->orderByDesc('id')
            ->get();

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

        // Tasa global real de adopción calculada desde la ficha de mascotas rescatadas (máximo 100%)
        $totalRescates = DB::table('mascotas')->count();
        $totalAdopciones = DB::table('mascotas')
            ->whereRaw("LOWER(estado_actual) LIKE '%adoptad%'")
            ->count();
        $tasaAdopcion = $totalRescates > 0
            ? min(100.0, round(($totalAdopciones / $totalRescates) * 100, 1))
            : 0.0;

        return response()->json([
            'periodo' => [
                'fecha_desde' => $desde->toDateString(),
                'fecha_hasta' => $hasta->toDateString(),
                'especie' => $especieFiltro,
            ],
            'evolucion_mensual' => $meses,
            'mascotas_rescatadas' => $mascotasRescatadas,
            'top_insumos_consumidos' => $topInsumos,
            'poblacion_por_estado' => $poblacionPorEstado,
            'poblacion_por_especie' => $poblacionPorEspecie,
            'indicadores_clave' => [
                'total_rescates_historico' => $totalRescates,
                'total_rescates_periodo' => $mascotasRescatadas->count(),
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
        abort_unless(in_array($request->user()?->rol, ['Administrador', 'Recepcionista'], true), 403);
    }
}
