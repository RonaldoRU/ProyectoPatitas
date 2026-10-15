<?php

namespace App\Http\Controllers;

use App\Models\ArticuloInventario;
use App\Models\HistorialClinico;
use App\Models\Mascota;
use App\Models\SalidaInventario;
use App\Services\AuditoriaService;
use App\Services\InventarioLotesService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class HistorialClinicoController extends Controller
{
    public function catalogos(Request $request, InventarioLotesService $inventario): JsonResponse
    {
        $this->authorizeVeterinarian($request);

        $articulos = ArticuloInventario::query()
            ->select(['id', 'nombre', 'categoria', 'unidad_medida', 'stock_actual'])
            ->orderBy('nombre')
            ->get();
        $stocksDisponibles = $inventario->stocksDisponibles($articulos);

        return response()->json([
            'mascotas' => Mascota::query()
                ->select(['id', 'nombre', 'especie', 'raza', 'estado_actual'])
                ->orderBy('nombre')
                ->get(),
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
        $this->authorizeVeterinarian($request);

        $validated = $request->validate([
            'fecha_atencion' => ['required', 'date_format:Y-m-d'],
            'id_mascota' => ['required', 'integer', 'exists:mascotas,id'],
            'diagnostico' => ['required', 'string', 'max:255'],
            'observacion' => ['required', 'string', 'max:255'],
            'tipo_procedimiento' => ['required', 'string', 'max:255'],
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
            'lineas.*.cantidad.integer' => 'Cada cantidad utilizada debe ser un número entero.',
            'lineas.*.cantidad.min' => 'Cada cantidad utilizada debe ser mayor que cero.',
        ]);

        $atencion = DB::transaction(function () use ($request, $validated, $auditoria, $inventario): array {
            $mascota = Mascota::query()
                ->lockForUpdate()
                ->find($validated['id_mascota']);

            if ($mascota === null) {
                throw ValidationException::withMessages([
                    'id_mascota' => 'La mascota seleccionada ya no está disponible.',
                ]);
            }

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
            $stocksDisponibles = $inventario->stocksDisponibles($articulos->values());

            $articulosActualizados = [];
            $articulosRegistrados = [];

            foreach ($validated['lineas'] as $index => $linea) {
                $articulo = $articulos->get((int) $linea['id_articulo']);

                if ($articulo === null) {
                    throw ValidationException::withMessages([
                        "lineas.{$index}.id_articulo" => 'El artículo seleccionado ya no está disponible.',
                    ]);
                }

                $stockEnCentavos = $stocksDisponibles[$articulo->getKey()] ?? 0;

                if ((int) $linea['cantidad'] * 100 > $stockEnCentavos) {
                    throw ValidationException::withMessages([
                        "lineas.{$index}.cantidad" => sprintf(
                            'Stock insuficiente para %s. Disponible: %s %s.',
                            $articulo->nombre,
                            $this->formatCents($stockEnCentavos),
                            $articulo->unidad_medida,
                        ),
                    ]);
                }

                $articulosRegistrados[] = sprintf('%s x %s', $articulo->nombre, $linea['cantidad']);
            }

            $historial = HistorialClinico::query()->create([
                'fecha_atencion' => $validated['fecha_atencion'],
                'diagnostico' => $validated['diagnostico'],
                'observacion' => $validated['observacion'],
                'tipo_procedimiento' => $validated['tipo_procedimiento'],
                'id_mascota' => $mascota->getKey(),
                'id_usuario' => $request->user()->getKey(),
            ]);

            $salida = SalidaInventario::query()->create([
                'motivo' => 'Consumo clínico de atención #'.$historial->getKey(),
                'fecha_salida' => $validated['fecha_atencion'],
                'id_usuario' => $request->user()->getKey(),
                'id_historial_clinico' => $historial->getKey(),
            ]);

            foreach ($validated['lineas'] as $index => $linea) {
                $articulo = $articulos->get((int) $linea['id_articulo']);
                $stockResultante = $inventario->registrarConsumo(
                    $articulo,
                    (int) $linea['cantidad'],
                    $salida,
                    "lineas.{$index}.cantidad",
                );
                $articulosActualizados[] = [
                    'id' => $articulo->getKey(),
                    'nombre' => $articulo->nombre,
                    'cantidad' => (int) $linea['cantidad'],
                    'stock_actual' => $this->formatCents($stockResultante),
                ];
            }

            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar atención clínica y consumir inventario',
                'historial_clinico',
                entidad: $historial,
                descripcion: 'Se registró una atención veterinaria y se descontaron los insumos utilizados.',
                contexto: [
                    'mascota' => $mascota->nombre,
                    'id_mascota' => (int) $mascota->getKey(),
                    'salida_inventario_id' => (int) $salida->getKey(),
                    'articulos' => $articulosRegistrados,
                ],
            );

            return [
                'id' => $historial->getKey(),
                'fecha_atencion' => $historial->fecha_atencion,
                'mascota' => $mascota->nombre,
                'diagnostico' => $historial->diagnostico,
                'tipo_procedimiento' => $historial->tipo_procedimiento,
                'salida_inventario_id' => $salida->getKey(),
                'articulos_actualizados' => $articulosActualizados,
            ];
        });

        return response()->json(['atencion' => $atencion], 201);
    }

    private function decimalToCents(int|float|string $value): int
    {
        $decimal = number_format((float) $value, 2, '.', '');
        [$whole, $fraction] = array_pad(explode('.', $decimal, 2), 2, '00');

        return ((int) $whole * 100) + (int) $fraction;
    }

    private function formatCents(int $value): string
    {
        return intdiv($value, 100).'.'.str_pad((string) ($value % 100), 2, '0', STR_PAD_LEFT);
    }

    private function authorizeVeterinarian(Request $request): void
    {
        abort_unless($request->user()?->rol === 'Veterinario', 403);
    }
}
