<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function getDashboardData(Request $request): JsonResponse
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
            'alertas_stock' => DB::table('articulo_inventarios')
                ->whereRaw('stock_actual <= stock_minimo_alerta')
                ->count(),
        ];

        $ultimosIngresos = DB::table('mascotas')
            ->select('nombre', 'especie', 'zona_rescate', 'fecha_ingreso', 'estado_actual')
            ->orderByDesc('fecha_ingreso')
            ->limit(3)
            ->get();

        $user = $request->user();

        return response()->json([
            'stats' => $stats,
            'ultimos_ingresos' => $ultimosIngresos,
            'user' => [
                'nombre' => $user?->nombre ?? 'Administrador',
                'rol' => $user?->rol ?? 'Staff',
            ],
        ]);
    }
}
