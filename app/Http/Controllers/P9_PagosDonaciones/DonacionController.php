<?php

namespace App\Http\Controllers\P9_PagosDonaciones;

use App\Http\Controllers\Controller;
use App\Models\AporteDinero;
use App\Models\ArticuloInventario;
use App\Models\DetalleDonacionInsumo;
use App\Models\Donacion;
use App\Models\Donante;
use App\Services\AuditoriaService;
use App\Services\InventarioLotesService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

/**
 * Paquete P9: Pasarela de Pagos, Donaciones Monetarias y Recibos Digitales
 * Casos de Uso:
 * - CU23: Registrar Recepción de Donaciones Físicas y Monetarias
 */
class DonacionController extends Controller
{
    public function index(): JsonResponse
    {
        $donaciones = Donacion::query()
            ->with([
                'donante:id,nombre,telefono,tipo_persona',
                'usuario:id,nombre',
                'aportesDinero',
                'detallesInsumos.articulo:id,nombre,unidad_medida',
            ])
            ->orderByDesc('id')
            ->get();

        return response()->json(['donaciones' => $donaciones]);
    }

    public function store(
        Request $request,
        AuditoriaService $auditoria,
        InventarioLotesService $inventario,
    ): JsonResponse {
        $validated = $request->validate([
            'tipo_aporte' => ['required', Rule::in(['Insumos', 'Dinero'])],
            'fecha' => ['required', 'date'],
            'numero_documento' => ['nullable', 'string', 'max:100'],
            'id_donante' => ['nullable', 'integer', 'exists:donantes,id'],
            'donante' => ['required_without:id_donante', 'nullable', 'array'],
            'donante.nombre' => ['required_with:donante', 'string', 'max:255'],
            'donante.telefono' => ['required_with:donante', 'string', 'max:50'],
            'donante.tipo_persona' => ['required_with:donante', 'string', 'max:50'],
            // Si es dinero
            'monto' => ['required_if:tipo_aporte,Dinero', 'nullable', 'numeric', 'min:0.01'],
            'comprobante' => ['nullable', 'string', 'max:100'],
            'observaciones' => ['nullable', 'string', 'max:500'],
            // Si son insumos
            'lineas' => ['required_if:tipo_aporte,Insumos', 'nullable', 'array', 'min:1'],
            'lineas.*.id_articulo' => ['required_with:lineas', 'integer', 'exists:articulo_inventarios,id'],
            'lineas.*.cantidad' => ['required_with:lineas', 'numeric', 'min:0.01'],
            'lineas.*.fecha_vencimiento' => ['nullable', 'date'],
        ]);

        $donacion = DB::transaction(function () use ($request, $validated, $auditoria, $inventario): Donacion {
            $donanteId = $validated['id_donante'] ?? null;
            if ($donanteId === null && isset($validated['donante'])) {
                $donante = Donante::query()->create($validated['donante']);
                $donanteId = $donante->id;
            }

            $donacion = Donacion::query()->create([
                'tipo_aporte' => $validated['tipo_aporte'],
                'fecha' => $validated['fecha'],
                'numero_documento' => $validated['numero_documento'] ?? 'DON-'.now()->format('YmdHis'),
                'id_donante' => $donanteId,
                'id_usuario' => $request->user()->getKey(),
            ]);

            if ($validated['tipo_aporte'] === 'Dinero') {
                AporteDinero::query()->create([
                    'monto' => $validated['monto'],
                    'fecha_recepcion' => $validated['fecha'],
                    'comprobante' => $validated['comprobante'] ?? $donacion->numero_documento,
                    'observaciones' => $validated['observaciones'] ?? 'Donación en efectivo / presencial',
                    'id_donacion' => $donacion->id,
                ]);
            } else {
                foreach ($validated['lineas'] as $linea) {
                    $articulo = ArticuloInventario::lockForUpdate()->findOrFail($linea['id_articulo']);
                    $articulo->increment('stock_actual', $linea['cantidad']);

                    $detalle = DetalleDonacionInsumo::query()->create([
                        'id_donacion' => $donacion->id,
                        'id_articulo' => $articulo->id,
                        'cantidad' => $linea['cantidad'],
                        'fecha_vencimiento' => $linea['fecha_vencimiento'] ?? null,
                    ]);

                    $inventario->crearLoteDonacion($detalle);
                }
            }

            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar donación '.strtolower($validated['tipo_aporte']),
                'donaciones',
                entidad: $donacion,
                contexto: [
                    'tipo' => $validated['tipo_aporte'],
                    'documento' => $donacion->numero_documento,
                ],
            );

            return $donacion;
        });

        return response()->json([
            'mensaje' => 'Donación registrada correctamente y recibo generado.',
            'donacion' => $donacion->load(['donante', 'aportesDinero', 'detallesInsumos.articulo']),
        ], 201);
    }

    public function show(Donacion $donacion): JsonResponse
    {
        return response()->json([
            'donacion' => $donacion->load(['donante', 'usuario', 'aportesDinero', 'detallesInsumos.articulo']),
        ]);
    }
}
