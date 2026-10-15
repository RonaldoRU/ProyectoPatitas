<?php

namespace App\Http\Controllers;

use App\Models\ArticuloInventario;
use App\Services\AuditoriaService;
use App\Services\InventarioLotesService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class ArticuloInventarioController extends Controller
{
    public function index(Request $request, InventarioLotesService $inventario): JsonResponse
    {
        $this->authorizeAdministrator($request);

        $articulos = ArticuloInventario::query()
            ->select([
                'id',
                'nombre',
                'categoria',
                'unidad_medida',
                'stock_actual',
                'stock_minimo_alerta',
                'created_at',
                'updated_at',
            ])
            ->orderBy('categoria')
            ->orderBy('nombre')
            ->get();
        $stocksDisponibles = $inventario->stocksDisponibles($articulos);
        $articulos->each(function (ArticuloInventario $articulo) use ($stocksDisponibles): void {
            $articulo->setAttribute(
                'stock_actual',
                number_format(($stocksDisponibles[$articulo->getKey()] ?? 0) / 100, 2, '.', ''),
            );
        });

        return response()->json(['articulos' => $articulos]);
    }

    public function store(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $this->authorizeAdministrator($request);
        $validated = $this->validatedData($request);

        $articulo = DB::transaction(function () use ($request, $validated, $auditoria): ArticuloInventario {
            $articulo = ArticuloInventario::query()->create([
                ...$validated,
                'stock_actual' => 0,
            ]);

            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar artículo de inventario',
                'inventario',
                entidad: $articulo,
                contexto: ['campos_registrados' => array_keys($validated)],
            );

            return $articulo;
        });

        return response()->json(['articulo' => $articulo], 201);
    }

    public function update(
        Request $request,
        ArticuloInventario $articuloInventario,
        AuditoriaService $auditoria,
    ): JsonResponse {
        $this->authorizeAdministrator($request);
        $validated = $this->validatedData($request, $articuloInventario);

        DB::transaction(function () use ($request, $articuloInventario, $validated, $auditoria): void {
            $articuloInventario->update($validated);
            $auditoria->registrar(
                $request,
                $request->user(),
                'Modificar artículo de inventario',
                'inventario',
                entidad: $articuloInventario,
                contexto: [
                    'campos_modificados' => array_values(array_intersect(
                        array_keys($articuloInventario->getChanges()),
                        array_keys($validated),
                    )),
                ],
            );
        });

        return response()->json(['articulo' => $articuloInventario->refresh()]);
    }

    /**
     * @return array{nombre: string, categoria: string, unidad_medida: string, stock_minimo_alerta: int|float|string}
     */
    private function validatedData(Request $request, ?ArticuloInventario $articulo = null): array
    {
        return $request->validate([
            'nombre' => [
                'required',
                'string',
                'max:150',
                Rule::unique('articulo_inventarios', 'nombre')->ignore($articulo?->getKey()),
            ],
            'categoria' => ['required', 'string', 'max:50'],
            'unidad_medida' => ['required', 'string', 'max:20'],
            'stock_minimo_alerta' => ['required', 'numeric', 'decimal:0,2', 'min:0', 'max:99999999.99'],
        ], [
            'nombre.unique' => 'Ya existe un artículo con ese nombre en el catálogo.',
        ]);
    }

    private function authorizeAdministrator(Request $request): void
    {
        abort_unless($request->user()?->rol === 'Administrador', 403);
    }
}
