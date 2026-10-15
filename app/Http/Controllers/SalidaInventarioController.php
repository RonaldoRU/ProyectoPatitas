<?php

namespace App\Http\Controllers;

use App\Models\ArticuloInventario;
use App\Models\SalidaInventario;
use App\Services\AuditoriaService;
use App\Services\InventarioLotesService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class SalidaInventarioController extends Controller
{
    private const PERSONAL_AUTORIZADO = ['Recepcionista', 'Voluntario'];

    public function catalogos(Request $request, InventarioLotesService $inventario): JsonResponse
    {
        $this->authorizeStaff($request);

        $articulos = ArticuloInventario::query()
            ->select(['id', 'nombre', 'categoria', 'unidad_medida', 'stock_actual'])
            ->orderBy('nombre')
            ->get();
        $stocksDisponibles = $inventario->stocksDisponibles($articulos);

        return response()->json([
            'articulos' => $articulos->map(fn (ArticuloInventario $articulo): array => [
                'id' => $articulo->getKey(),
                'nombre' => $articulo->nombre,
                'categoria' => $articulo->categoria,
                'unidad_medida' => $articulo->unidad_medida,
                'stock_actual' => ($stocksDisponibles[$articulo->getKey()] ?? 0) / 100,
            ]),
        ]);
    }

    public function store(
        Request $request,
        AuditoriaService $auditoria,
        InventarioLotesService $inventario,
    ): JsonResponse {
        $this->authorizeStaff($request);

        $validated = $request->validate([
            'motivo' => ['required', 'string', 'max:143'],
            'destino' => ['required', 'string', 'max:100'],
            'fecha_salida' => ['required', 'date'],
            'lineas' => ['required', 'array', 'min:1', 'max:100'],
            'lineas.*.id_articulo' => [
                'required',
                'integer',
                'distinct',
                'exists:articulo_inventarios,id',
            ],
            'lineas.*.cantidad' => [
                'required',
                'integer',
                'min:1',
                'max:99999999',
            ],
        ], [
            'lineas.*.cantidad.integer' => 'La cantidad a retirar debe ser un número entero.',
            'lineas.*.cantidad.min' => 'La cantidad a retirar debe ser un número entero mayor que cero.',
        ]);

        $salida = DB::transaction(function () use ($request, $validated, $auditoria, $inventario): array {
            $idsArticulos = collect($validated['lineas'])
                ->pluck('id_articulo')
                ->map(fn (int|string $id): int => (int) $id)
                ->sort()
                ->values();
            $articulos = ArticuloInventario::query()
                ->whereIn('id', $idsArticulos)
                ->orderBy('id')
                ->lockForUpdate()
                ->get()
                ->keyBy('id');

            $salida = SalidaInventario::query()->create([
                'motivo' => $validated['motivo'].' | Destino: '.$validated['destino'],
                'fecha_salida' => $validated['fecha_salida'],
                'id_usuario' => $request->user()->getKey(),
            ]);
            $articulosActualizados = [];
            $articulosRegistrados = [];

            foreach ($validated['lineas'] as $index => $linea) {
                $articulo = $articulos->get((int) $linea['id_articulo']);

                if ($articulo === null) {
                    throw ValidationException::withMessages([
                        "lineas.{$index}.id_articulo" => 'El artículo seleccionado ya no está disponible.',
                    ]);
                }

                $stockResultante = $inventario->registrarConsumo(
                    $articulo,
                    (int) $linea['cantidad'],
                    $salida,
                    "lineas.{$index}.cantidad",
                );

                $articulosActualizados[] = [
                    'id' => $articulo->getKey(),
                    'stock_actual' => $this->formatCents($stockResultante),
                ];
                $articulosRegistrados[] = $articulo->nombre;
            }

            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar salida de inventario',
                'inventario',
                entidad: $salida,
                descripcion: 'Se registró el consumo de artículos y se descontó el stock.',
                contexto: [
                    'motivo' => $validated['motivo'],
                    'destino' => $validated['destino'],
                    'fecha_salida' => $validated['fecha_salida'],
                    'cantidad_lineas' => count($validated['lineas']),
                    'articulos' => $articulosRegistrados,
                ],
            );

            return [
                'id' => $salida->getKey(),
                'motivo' => $validated['motivo'],
                'destino' => $validated['destino'],
                'fecha_salida' => $validated['fecha_salida'],
                'articulos' => $articulosRegistrados,
                'articulos_actualizados' => $articulosActualizados,
            ];
        });

        return response()->json(['salida' => $salida], 201);
    }

    private function formatCents(int $value): string
    {
        return intdiv($value, 100).'.'.str_pad((string) ($value % 100), 2, '0', STR_PAD_LEFT);
    }

    private function authorizeStaff(Request $request): void
    {
        abort_unless(
            in_array($request->user()?->rol, self::PERSONAL_AUTORIZADO, true),
            403,
        );
    }
}
