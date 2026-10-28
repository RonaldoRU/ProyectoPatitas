<?php

namespace App\Http\Controllers\P6_AutomatizacionClinica;

use App\Http\Controllers\Controller;
use App\Models\ArticuloInventario;
use App\Models\InventarioLote;
use App\Services\AuditoriaService;
use App\Services\InventarioLotesService;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * Paquete P6: Automatización Clínica y Control de Vencimientos
 * Casos de Uso:
 * - CU15: Descargo de Stock Automático por Consumo Clínico
 * - CU16: Controlar y Alertar Vencimiento de Fármacos (a 30 y 60 días)
 */
class AutomatizacionClinicaController extends Controller
{
    public function alertasVencimiento(Request $request, InventarioLotesService $inventario): JsonResponse
    {
        $today = Carbon::today();
        $dentroDe30Dias = $today->copy()->addDays(30);
        $dentroDe60Dias = $today->copy()->addDays(60);

        // Consultar lotes vigentes de fármacos e insumos clínicos
        $lotes = InventarioLote::query()
            ->with('articulo:id,nombre,categoria,unidad_medida,stock_actual')
            ->whereNotNull('fecha_vencimiento')
            ->where('cantidad_disponible', '>', 0)
            ->orderBy('fecha_vencimiento')
            ->get();

        $vencidos = [];
        $criticos30Dias = [];
        $preventivos60Dias = [];
        $normales = [];

        foreach ($lotes as $lote) {
            $fechaVencimiento = Carbon::parse($lote->fecha_vencimiento);
            $diasRestantes = $today->diffInDays($fechaVencimiento, false);

            $item = [
                'id_lote' => $lote->id,
                'articulo_id' => $lote->id_articulo,
                'nombre' => $lote->articulo?->nombre ?? 'Desconocido',
                'categoria' => $lote->articulo?->categoria ?? 'Fármaco',
                'unidad_medida' => $lote->articulo?->unidad_medida ?? 'unidad',
                'cantidad_disponible' => $lote->cantidad_disponible,
                'fecha_vencimiento' => $lote->fecha_vencimiento,
                'dias_restantes' => $diasRestantes,
            ];

            if ($fechaVencimiento->lt($today)) {
                $item['estado'] = 'Vencido';
                $item['nivel_urgencia'] = 'critico';
                $vencidos[] = $item;
            } elseif ($fechaVencimiento->lte($dentroDe30Dias)) {
                $item['estado'] = 'Alerta Crítica (<= 30 días)';
                $item['nivel_urgencia'] = 'alta';
                $criticos30Dias[] = $item;
            } elseif ($fechaVencimiento->lte($dentroDe60Dias)) {
                $item['estado'] = 'Alerta Preventiva (<= 60 días)';
                $item['nivel_urgencia'] = 'media';
                $preventivos60Dias[] = $item;
            } else {
                $item['estado'] = 'Óptimo';
                $item['nivel_urgencia'] = 'baja';
                $normales[] = $item;
            }
        }

        return response()->json([
            'resumen' => [
                'total_vencidos' => count($vencidos),
                'total_criticos_30' => count($criticos30Dias),
                'total_preventivos_60' => count($preventivos60Dias),
                'total_vigentes' => count($normales),
            ],
            'alertas' => [
                'vencidos' => $vencidos,
                'criticos_30_dias' => $criticos30Dias,
                'preventivos_60_dias' => $preventivos60Dias,
                'optimos' => $normales,
            ],
        ]);
    }

    public function descargoStockClinico(
        Request $request,
        InventarioLotesService $inventario,
        AuditoriaService $auditoria,
    ): JsonResponse {
        $validated = $request->validate([
            'id_articulo' => ['required', 'integer', 'exists:articulo_inventarios,id'],
            'cantidad' => ['required', 'integer', 'min:1'],
            'motivo' => ['nullable', 'string', 'max:255'],
        ]);

        $articulo = ArticuloInventario::findOrFail($validated['id_articulo']);

        return response()->json([
            'mensaje' => 'Verificación de descargo clínico completada.',
            'articulo' => $articulo->only(['id', 'nombre', 'stock_actual', 'unidad_medida']),
            'stock_disponible' => $inventario->stockDisponible($articulo) / 100,
        ]);
    }
}
