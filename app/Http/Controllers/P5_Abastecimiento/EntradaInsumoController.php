<?php

namespace App\Http\Controllers\P5_Abastecimiento;

use App\Http\Controllers\Controller;
use App\Models\ArticuloInventario;
use App\Models\Compra;
use App\Models\DetalleCompra;
use App\Models\DetalleDonacionInsumo;
use App\Models\Donacion;
use App\Models\Donante;
use App\Models\Proveedor;
use App\Services\AuditoriaService;
use App\Services\InventarioLotesService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

/**
 * Paquete P5: Abastecimiento, Salidas y Proveedores
 * Casos de Uso:
 * - CU12: Registrar Entrada de Insumos / Compras
 */
class EntradaInsumoController extends Controller
{
    private const PERSONAL_AUTORIZADO = ['Administrador', 'Recepcionista'];

    public function catalogos(Request $request, InventarioLotesService $inventario): JsonResponse
    {
        $this->authorizeStaff($request);

        $articulos = ArticuloInventario::query()
            ->select(['id', 'nombre', 'categoria', 'unidad_medida', 'stock_actual'])
            ->orderBy('nombre')
            ->get();

        return response()->json([
            'articulos' => $articulos->map(fn (ArticuloInventario $articulo): array => [
                'id' => $articulo->getKey(),
                'nombre' => $articulo->nombre,
                'categoria' => $articulo->categoria,
                'unidad_medida' => $articulo->unidad_medida,
                'stock_actual' => $articulo->stock_actual,
                'requiere_vencimiento' => $inventario->esMedicamento(
                    (string) $articulo->categoria,
                    (string) $articulo->nombre,
                ),
            ]),
            'proveedores' => Proveedor::query()
                ->where('activo', true)
                ->select(['id', 'nombre_empresa', 'tipo_insumo_provisto'])
                ->orderBy('nombre_empresa')
                ->get(),
            'donantes' => Donante::query()
                ->select(['id', 'nombre', 'tipo_persona'])
                ->orderBy('nombre')
                ->get(),
        ]);
    }

    public function store(
        Request $request,
        AuditoriaService $auditoria,
        InventarioLotesService $inventario,
    ): JsonResponse {
        $this->authorizeStaff($request);

        $tipo = $request->input('tipo');
        $esCompra = $tipo === 'compra';
        $esDonacion = $tipo === 'donacion';

        $rules = [
            'tipo' => ['required', Rule::in(['compra', 'donacion'])],
            'fecha' => ['required', 'date'],
            'numero_documento' => [
                Rule::requiredIf($esCompra),
                'nullable',
                'string',
                'max:100',
            ],
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
                'max:999999',
            ],
            'lineas.*.fecha_vencimiento' => ['nullable', 'date'],
        ];

        if ($esCompra) {
            $rules += [
                'id_proveedor' => [
                    'required',
                    'integer',
                    Rule::exists('proveedors', 'id')->where('activo', true),
                ],
                'lineas.*.costo_unitario' => [
                    'required',
                    'numeric',
                    'decimal:0,2',
                    'min:0',
                    'max:999999.99',
                ],
            ];
        }

        if ($esDonacion) {
            $rules += [
                'id_donante' => ['required_without:donante', 'nullable', 'integer', 'exists:donantes,id'],
                'donante' => ['required_without:id_donante', 'nullable', 'array'],
                'donante.nombre' => ['required_with:donante', 'string', 'max:255'],
                'donante.telefono' => ['required_with:donante', 'string', 'max:255'],
                'donante.tipo_persona' => ['required_with:donante', 'string', 'max:255'],
            ];
        }

        $validated = $request->validate($rules, [
            'lineas.*.cantidad.integer' => 'Cada cantidad debe ser un número entero.',
            'lineas.*.cantidad.min' => 'Cada cantidad debe ser un número entero mayor que cero.',
            'lineas.*.costo_unitario.required' => 'Indica el costo unitario de cada artículo comprado.',
        ]);

        $montoTotalEnCentavos = $esCompra
            ? $this->calculatePurchaseTotalInCents($validated['lineas'])
            : 0;

        if ($montoTotalEnCentavos > 9_999_999_999) {
            throw ValidationException::withMessages([
                'lineas' => 'El total de la compra supera el máximo permitido.',
            ]);
        }

        $entrada = DB::transaction(function () use (
            $request,
            $validated,
            $esCompra,
            $montoTotalEnCentavos,
            $auditoria,
            $inventario,
        ): array {
            $proveedorId = null;
            $donanteId = null;

            if ($esCompra) {
                $proveedor = Proveedor::query()
                    ->where('activo', true)
                    ->whereKey($validated['id_proveedor'])
                    ->lockForUpdate()
                    ->first();

                if ($proveedor === null) {
                    throw ValidationException::withMessages([
                        'id_proveedor' => 'Selecciona un proveedor activo del directorio.',
                    ]);
                }

                $proveedorId = $proveedor->getKey();
            } else {
                $donanteId = isset($validated['id_donante'])
                    ? (int) $validated['id_donante']
                    : Donante::query()->create($validated['donante'])->getKey();
            }

            $registro = $esCompra
                ? Compra::query()->create([
                    'monto_total' => $this->formatCents($montoTotalEnCentavos),
                    'fecha_compra' => $validated['fecha'],
                    'numero_documento' => $validated['numero_documento'],
                    'id_proveedor' => $proveedorId,
                    'id_usuario' => $request->user()->getKey(),
                ])
                : Donacion::query()->create([
                    'tipo_aporte' => 'Insumos',
                    'fecha' => $validated['fecha'],
                    'numero_documento' => $validated['numero_documento'] ?? null,
                    'id_donante' => $donanteId,
                    'id_usuario' => $request->user()->getKey(),
                ]);

            $articulosActualizados = [];
            $articulosRegistrados = [];

            foreach ($validated['lineas'] as $index => $linea) {
                $articulo = ArticuloInventario::query()
                    ->whereKey($linea['id_articulo'])
                    ->lockForUpdate()
                    ->firstOrFail();

                if ($inventario->esMedicamento((string) $articulo->categoria, (string) $articulo->nombre)) {
                    if (empty($linea['fecha_vencimiento'])) {
                        throw ValidationException::withMessages([
                            "lineas.{$index}.fecha_vencimiento" => 'La fecha de vencimiento es obligatoria para los medicamentos.',
                        ]);
                    }

                    if (Carbon::parse($linea['fecha_vencimiento'])->lt(Carbon::today())) {
                        throw ValidationException::withMessages([
                            "lineas.{$index}.fecha_vencimiento" => 'No se puede registrar un medicamento ya vencido.',
                        ]);
                    }
                }

                $stockResultanteEnCentavos = $this->decimalToCents($articulo->stock_actual)
                    + $this->decimalToCents($linea['cantidad']);

                if ($stockResultanteEnCentavos > 9_999_999_999) {
                    throw ValidationException::withMessages([
                        "lineas.{$index}.cantidad" => "La cantidad supera el máximo de stock para {$articulo->nombre}.",
                    ]);
                }

                $articulo->increment('stock_actual', $linea['cantidad']);

                if ($esCompra) {
                    $detalle = DetalleCompra::query()->create([
                        'costo_unitario' => $linea['costo_unitario'],
                        'fecha_vencimiento' => $linea['fecha_vencimiento'] ?? null,
                        'cantidad' => $linea['cantidad'],
                        'id_compra' => $registro->getKey(),
                        'id_articulo' => $articulo->getKey(),
                    ]);

                    $inventario->crearLoteCompra($detalle);
                } else {
                    $detalle = DetalleDonacionInsumo::query()->create([
                        'fecha_vencimiento' => $linea['fecha_vencimiento'] ?? null,
                        'cantidad' => $linea['cantidad'],
                        'id_donacion' => $registro->getKey(),
                        'id_articulo' => $articulo->getKey(),
                    ]);

                    $inventario->crearLoteDonacion($detalle);
                }

                $articulosActualizados[] = [
                    'id' => $articulo->getKey(),
                    'stock_actual' => $this->formatCents($stockResultanteEnCentavos),
                ];
                $articulosRegistrados[] = $articulo->nombre;
            }

            $auditoria->registrar(
                $request,
                $request->user(),
                $esCompra ? 'Registrar entrada por compra' : 'Registrar entrada por donación',
                'inventario',
                entidad: $registro,
                descripcion: $esCompra
                    ? 'Se registró una compra y se actualizó el stock de sus artículos.'
                    : 'Se registró una donación de insumos y se actualizó el stock de sus artículos.',
                contexto: [
                    'tipo_entrada' => $esCompra ? 'compra' : 'donacion',
                    'numero_documento' => $validated['numero_documento'] ?? null,
                    'cantidad_lineas' => count($validated['lineas']),
                    'articulos' => $articulosRegistrados,
                    'monto_total' => $esCompra
                        ? $this->formatCents($montoTotalEnCentavos)
                        : null,
                ],
            );

            return [
                'id' => $registro->getKey(),
                'tipo' => $esCompra ? 'compra' : 'donacion',
                'fecha' => $validated['fecha'],
                'numero_documento' => $validated['numero_documento'] ?? null,
                'monto_total' => $esCompra ? $this->formatCents($montoTotalEnCentavos) : null,
                'articulos' => $articulosRegistrados,
                'articulos_actualizados' => $articulosActualizados,
            ];
        });

        return response()->json(['entrada' => $entrada], 201);
    }

    /**
     * @param  array<int, array{cantidad: int|float|string, costo_unitario: int|float|string}>  $lineas
     */
    private function calculatePurchaseTotalInCents(array $lineas): int
    {
        $totalEnCentavos = 0;

        foreach ($lineas as $linea) {
            $producto = $this->decimalToCents($linea['cantidad'])
                * $this->decimalToCents($linea['costo_unitario']);
            $totalEnCentavos += intdiv($producto, 100) + (($producto % 100) >= 50 ? 1 : 0);
        }

        return $totalEnCentavos;
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

    private function authorizeStaff(Request $request): void
    {
        abort_unless(
            in_array($request->user()?->rol, self::PERSONAL_AUTORIZADO, true),
            403,
        );
    }
}
