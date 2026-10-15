<?php

namespace App\Http\Controllers;

use App\Models\ArticuloInventario;
use App\Services\InventarioLotesService;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function getDashboardData(Request $request, InventarioLotesService $inventario): JsonResponse
    {
        $today = Carbon::now();

        $stats = [
            'animales_refugio' => DB::table('mascotas')
                ->whereNotIn('estado_actual', ['Adoptado', 'Fallecido'])
                ->count(),
            'listos_adopcion' => DB::table('mascotas')
                ->where('estado_actual', 'Disponible')
                ->count(),
            'adopciones_mes' => DB::table('adopcions')
                ->whereBetween('fecha_adopcion', [
                    $today->copy()->startOfMonth()->toDateString(),
                    $today->copy()->endOfMonth()->toDateString(),
                ])
                ->count(),
            'alertas_stock' => $this->countLowStockAlerts($inventario),
        ];

        $ultimosIngresos = DB::table('mascotas')
            ->select('nombre', 'especie', 'zona_rescate', 'fecha_ingreso', 'estado_actual')
            ->orderByDesc('fecha_ingreso')
            ->limit(3)
            ->get();

        $user = $request->user();
        $puedeVerVencimientos = in_array($user?->rol, ['Administrador', 'Veterinario'], true);

        return response()->json([
            'stats' => $stats,
            'ultimos_ingresos' => $ultimosIngresos,
            'alertas_vencimiento' => $puedeVerVencimientos
                ? $inventario->alertas($today)
                : ['proximos' => [], 'vencidos' => [], 'sin_fecha' => []],
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
