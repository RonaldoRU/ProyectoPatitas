<?php

namespace App\Http\Controllers;

use App\Models\AjusteInventario;
use App\Models\AjusteInventarioLote;
use App\Models\ArticuloInventario;
use App\Services\AuditoriaService;
use App\Services\InventarioLotesService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AjusteInventarioController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $this->authorizeAdministrator($request);

        $ajustes = AjusteInventario::query()
            ->with('articulo:id,nombre,unidad_medida')
            ->orderByDesc('created_at')
            ->orderByDesc('id')
            ->limit(50)
            ->get([
                'id',
                'id_articulo',
                'usuario_nombre',
                'cantidad',
                'saldo_disponible_anterior',
                'saldo_disponible_nuevo',
                'motivo',
                'created_at',
            ]);

        return response()->json(['ajustes' => $ajustes]);
    }

    public function store(
        Request $request,
        InventarioLotesService $inventario,
        AuditoriaService $auditoria,
    ): JsonResponse {
        $this->authorizeAdministrator($request);

        $validated = $request->validate([
            'id_articulo' => ['required', 'integer', 'exists:articulo_inventarios,id'],
            'cantidad' => ['required', 'integer', 'min:1', 'max:99999999'],
            'motivo' => ['required', 'string', 'max:1000'],
        ], [
            'cantidad.integer' => 'La cantidad de merma debe ser un número entero.',
            'motivo.required' => 'El motivo de la merma es obligatorio.',
        ]);

        $articuloId = (int) $validated['id_articulo'];
        $cantidad = (int) $validated['cantidad'];
        $motivo = (string) $validated['motivo'];

        $resultado = DB::transaction(function () use (
            $request,
            $articuloId,
            $cantidad,
            $motivo,
            $inventario,
            $auditoria,
        ): array {
            $articulo = ArticuloInventario::query()
                ->lockForUpdate()
                ->findOrFail($articuloId);
            $stock = $inventario->descontarPorMerma($articulo, $cantidad);
            $ajuste = AjusteInventario::query()->create([
                'id_articulo' => $articulo->getKey(),
                'id_usuario' => $request->user()->getKey(),
                'usuario_nombre' => $request->user()->nombre,
                'cantidad' => $cantidad,
                'stock_anterior' => $stock['stock_anterior'],
                'stock_nuevo' => $stock['stock_nuevo'],
                'saldo_disponible_anterior' => $stock['saldo_disponible_anterior'],
                'saldo_disponible_nuevo' => $stock['saldo_disponible_nuevo'],
                'motivo' => $motivo,
            ]);

            foreach ($stock['lotes'] as $asignacion) {
                AjusteInventarioLote::query()->create([
                    'id_ajuste_inventario' => $ajuste->getKey(),
                    'id_inventario_lote' => $asignacion['lote']->getKey(),
                    'cantidad' => $asignacion['cantidad'],
                ]);
            }

            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar merma de inventario',
                'inventario',
                entidad: $ajuste,
                contexto: [
                    'articulo' => $articulo->nombre,
                    'cantidad' => $cantidad,
                    'stock_anterior' => $stock['saldo_disponible_anterior'],
                    'stock_nuevo' => $stock['saldo_disponible_nuevo'],
                    'motivo' => $motivo,
                ],
            );

            return [
                'ajuste' => $ajuste->load('articulo:id,nombre,unidad_medida'),
                'stock_actual' => $stock['saldo_disponible_nuevo'],
            ];
        });

        return response()->json($resultado, 201);
    }

    private function authorizeAdministrator(Request $request): void
    {
        abort_unless($request->user()?->rol === 'Administrador', 403);
    }
}
