<?php

namespace App\Services;

use App\Models\ArticuloInventario;
use App\Models\DetalleCompra;
use App\Models\DetalleDonacionInsumo;
use App\Models\DetalleSalida;
use App\Models\DetalleSalidaLote;
use App\Models\InventarioLote;
use App\Models\SalidaInventario;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use LogicException;

class InventarioLotesService
{
    public function esMedicamento(string $categoria, ?string $nombre = null): bool
    {
        $textoNormalizado = Str::ascii(Str::lower($categoria.' '.($nombre ?? '')));

        return Str::contains($textoNormalizado, [
            'medic',
            'farmac',
            'antibiot',
            'analges',
            'antiparasit',
            'desparasit',
            'antiinflam',
            'vacun',
            'jarabe',
            'capsul',
            'comprimid',
            'tableta',
            'insulina',
        ]);
    }

    public function crearLoteCompra(DetalleCompra $detalle): InventarioLote
    {
        return InventarioLote::query()->create([
            'id_articulo' => $detalle->id_articulo,
            'id_detalle_compra' => $detalle->getKey(),
            'fecha_vencimiento' => $detalle->fecha_vencimiento,
            'cantidad_inicial' => $detalle->cantidad,
            'cantidad_disponible' => $detalle->cantidad,
        ]);
    }

    public function crearLoteDonacion(DetalleDonacionInsumo $detalle): InventarioLote
    {
        return InventarioLote::query()->create([
            'id_articulo' => $detalle->id_articulo,
            'id_detalle_donacion' => $detalle->getKey(),
            'fecha_vencimiento' => $detalle->fecha_vencimiento,
            'cantidad_inicial' => $detalle->cantidad,
            'cantidad_disponible' => $detalle->cantidad,
        ]);
    }

    public function stockDisponible(ArticuloInventario $articulo): int
    {
        return $this->stocksDisponibles(collect([$articulo]))[$articulo->getKey()];
    }

    /**
     * @param  Collection<int, ArticuloInventario>  $articulos
     * @return array<int, int>
     */
    public function stocksDisponibles(Collection $articulos): array
    {
        $articulosMedicamento = $articulos
            ->filter(fn (ArticuloInventario $articulo): bool => $this->esMedicamento(
                (string) $articulo->categoria,
                (string) $articulo->nombre,
            ));
        $lotesPorArticulo = $articulosMedicamento->isEmpty()
            ? collect()
            : DB::table('inventario_lotes')
                ->selectRaw('id_articulo, SUM(cantidad_disponible) as cantidad_disponible')
                ->whereIn('id_articulo', $articulosMedicamento->pluck('id'))
                ->whereNotNull('fecha_vencimiento')
                ->whereDate('fecha_vencimiento', '>=', Carbon::today())
                ->groupBy('id_articulo')
                ->pluck('cantidad_disponible', 'id_articulo');

        return $articulos->mapWithKeys(function (ArticuloInventario $articulo) use ($lotesPorArticulo): array {
            $stockActual = $this->decimalToCents($articulo->stock_actual);
            $stock = $this->esMedicamento((string) $articulo->categoria, (string) $articulo->nombre)
                ? min(
                    $stockActual,
                    $this->decimalToCents($lotesPorArticulo->get($articulo->getKey(), '0.00')),
                )
                : $stockActual;

            return [$articulo->getKey() => $stock];
        })->all();
    }

    public function registrarConsumo(
        ArticuloInventario $articulo,
        int $cantidad,
        SalidaInventario $salida,
        string $errorKey,
    ): int {
        $esMedicamento = $this->esMedicamento((string) $articulo->categoria, (string) $articulo->nombre);
        $stockActual = $this->decimalToCents($articulo->stock_actual);
        $lotes = $this->lotesUtilizables($articulo, lock: true);
        $cantidadEnCentavos = $cantidad * 100;
        $sumaLotes = $lotes->sum(
            fn (InventarioLote $lote): int => $this->decimalToCents($lote->cantidad_disponible),
        );
        $stockSinLote = $esMedicamento ? 0 : max(0, $stockActual - $sumaLotes);
        $stockUtilizable = min($stockActual, $sumaLotes + $stockSinLote);

        if ($cantidadEnCentavos > $stockUtilizable) {
            throw ValidationException::withMessages([
                $errorKey => sprintf(
                    $esMedicamento
                        ? 'Stock vigente insuficiente para %s. Disponible: %s %s.'
                        : 'Stock insuficiente para %s. Disponible: %s %s.',
                    $articulo->nombre,
                    $this->formatCents($stockUtilizable),
                    $articulo->unidad_medida,
                ),
            ]);
        }

        $detalleSalida = DetalleSalida::query()->create([
            'id_articulo' => $articulo->getKey(),
            'cantidad' => $cantidad,
            'id_salida' => $salida->getKey(),
        ]);

        $distribucion = $this->descontarDeLotes($lotes, $cantidadEnCentavos);
        foreach ($distribucion as $asignacion) {
            DetalleSalidaLote::query()->create([
                'id_detalle_salida' => $detalleSalida->getKey(),
                'id_inventario_lote' => $asignacion['lote']->getKey(),
                'cantidad' => $this->formatCents($asignacion['cantidad_centavos']),
            ]);
        }

        $cantidadEnLotes = array_sum(array_column($distribucion, 'cantidad_centavos'));
        if ($cantidadEnCentavos - $cantidadEnLotes > $stockSinLote * 100) {
            throw new LogicException('La distribución del consumo excedió el saldo registrado por lote.');
        }

        $articulo->decrement('stock_actual', $cantidad);

        return $esMedicamento
            ? $this->stockDisponible($articulo)
            : $stockActual - $cantidadEnCentavos;
    }

    /**
     * @return array{
     *     stock_anterior: string,
     *     stock_nuevo: string,
     *     saldo_disponible_anterior: string,
     *     saldo_disponible_nuevo: string,
     *     lotes: list<array{lote: InventarioLote, cantidad: string}>
     * }
     */
    public function descontarPorMerma(ArticuloInventario $articulo, int $cantidad): array
    {
        $esMedicamento = $this->esMedicamento((string) $articulo->categoria, (string) $articulo->nombre);
        $stockActual = $this->decimalToCents($articulo->stock_actual);
        $lotes = $this->lotesUtilizables($articulo, lock: true);
        $sumaLotes = $lotes->sum(
            fn (InventarioLote $lote): int => $this->decimalToCents($lote->cantidad_disponible),
        );
        $stockDisponible = $esMedicamento ? min($stockActual, $sumaLotes) : $stockActual;
        $cantidadEnCentavos = $cantidad * 100;

        if ($cantidadEnCentavos > $stockDisponible) {
            throw ValidationException::withMessages([
                'cantidad' => sprintf(
                    'La merma supera el stock disponible de %s. Disponible: %s %s.',
                    $articulo->nombre,
                    $this->formatCents($stockDisponible),
                    $articulo->unidad_medida,
                ),
            ]);
        }

        $distribucion = $this->descontarDeLotes($lotes, $cantidadEnCentavos);
        $cantidadEnLotes = array_sum(array_column($distribucion, 'cantidad_centavos'));

        if ($cantidadEnCentavos - $cantidadEnLotes > max(0, $stockActual - $sumaLotes)) {
            throw new LogicException('La distribución de la merma excedió el saldo registrado por lote.');
        }

        $articulo->decrement('stock_actual', $cantidad);
        $articulo->refresh();
        $stockDisponibleNuevo = $this->stockDisponible($articulo);

        return [
            'stock_anterior' => $this->formatCents($stockActual),
            'stock_nuevo' => $this->formatCents($stockActual - $cantidadEnCentavos),
            'saldo_disponible_anterior' => $this->formatCents($stockDisponible),
            'saldo_disponible_nuevo' => $this->formatCents($stockDisponibleNuevo),
            'lotes' => array_map(
                fn (array $asignacion): array => [
                    'lote' => $asignacion['lote'],
                    'cantidad' => $this->formatCents($asignacion['cantidad_centavos']),
                ],
                $distribucion,
            ),
        ];
    }

    /**
     * @return array{proximos: list<array<string, int|string|null>>, vencidos: list<array<string, int|string|null>>, sin_fecha: list<array<string, int|string|null>>}
     */
    public function alertas(?Carbon $fechaActual = null): array
    {
        $hoy = ($fechaActual ?? Carbon::today())->copy()->startOfDay();
        $lotes = InventarioLote::query()
            ->with('articulo:id,nombre,categoria,unidad_medida')
            ->where('cantidad_disponible', '>', 0)
            ->where(function (Builder $query) use ($hoy): void {
                $query->whereNull('fecha_vencimiento')
                    ->orWhereDate('fecha_vencimiento', '<=', $hoy->copy()->addDays(30));
            })
            ->orderByRaw('CASE WHEN fecha_vencimiento IS NULL THEN 1 ELSE 0 END')
            ->orderBy('fecha_vencimiento')
            ->orderBy('id')
            ->get()
            ->filter(fn (InventarioLote $lote): bool => $lote->articulo !== null
                && $this->esMedicamento(
                    (string) $lote->articulo->categoria,
                    (string) $lote->articulo->nombre,
                ))
            ->unique('id')
            ->values();

        $grupos = [
            'proximos' => [],
            'vencidos' => [],
            'sin_fecha' => [],
        ];

        foreach ($lotes as $lote) {
            $fechaVencimiento = $lote->fecha_vencimiento?->toDateString();
            $diasRestantes = $fechaVencimiento === null
                ? null
                : (int) $hoy->diffInDays($lote->fecha_vencimiento, false);
            $estado = $fechaVencimiento === null
                ? 'sin_fecha'
                : ($diasRestantes < 0 ? 'vencido' : 'proximo');
            $origen = $lote->id_detalle_compra !== null
                ? 'Compra #'.$lote->id_detalle_compra
                : ($lote->id_detalle_donacion !== null
                    ? 'Donación #'.$lote->id_detalle_donacion
                    : 'Stock previo sin lote');

            $grupo = match ($estado) {
                'proximo' => 'proximos',
                'vencido' => 'vencidos',
                default => 'sin_fecha',
            };

            $grupos[$grupo][] = [
                'id' => (int) $lote->getKey(),
                'articulo' => $lote->articulo->nombre,
                'origen' => $origen,
                'fecha_vencimiento' => $fechaVencimiento,
                'dias_restantes' => $diasRestantes,
                'cantidad_disponible' => (string) $lote->cantidad_disponible,
                'unidad_medida' => $lote->articulo->unidad_medida,
            ];
        }

        return $grupos;
    }

    /**
     * @return array{lotes: int, cantidad: string, articulos: int}
     */
    public function procesarVencidos(AuditoriaService $auditoria): array
    {
        return DB::transaction(function () use ($auditoria): array {
            $hoy = Carbon::today();
            $lotesVencidos = InventarioLote::query()
                ->with('articulo')
                ->whereDate('fecha_vencimiento', '<', $hoy)
                ->where('cantidad_disponible', '>', 0)
                ->orderBy('id_articulo')
                ->orderBy('fecha_vencimiento')
                ->orderBy('id')
                ->lockForUpdate()
                ->get()
                ->filter(fn (InventarioLote $lote): bool => $lote->articulo !== null
                    && $this->esMedicamento(
                        (string) $lote->articulo->categoria,
                        (string) $lote->articulo->nombre,
                    ))
                ->values();

            if ($lotesVencidos->isEmpty()) {
                return ['lotes' => 0, 'cantidad' => '0.00', 'articulos' => 0];
            }

            $articulosPorId = $lotesVencidos
                ->pluck('articulo')
                ->filter()
                ->unique('id')
                ->keyBy('id');
            $lotesPorArticulo = $lotesVencidos->groupBy('id_articulo');
            $totalCentavos = 0;
            $idsLotes = [];

            foreach ($lotesPorArticulo as $articuloId => $lotes) {
                $articulo = $articulosPorId->get($articuloId);

                if ($articulo === null) {
                    continue;
                }

                $cantidadArticulo = $lotes->sum(
                    fn (InventarioLote $lote): int => $this->decimalToCents($lote->cantidad_disponible),
                );
                $stockActual = $this->decimalToCents($articulo->stock_actual);

                if ($cantidadArticulo > $stockActual) {
                    throw new LogicException(
                        "El saldo de lotes vencidos supera el stock registrado para {$articulo->nombre}.",
                    );
                }

                $articulo->decrement('stock_actual', $cantidadArticulo / 100);
                $totalCentavos += $cantidadArticulo;

                foreach ($lotes as $lote) {
                    $cantidad = $this->decimalToCents($lote->cantidad_disponible);
                    $lote->increment('cantidad_vencida', $cantidad / 100);
                    $lote->update(['cantidad_disponible' => '0.00']);
                    $idsLotes[] = (string) $lote->getKey();
                }
            }

            $primerLote = $lotesVencidos->first();
            $auditoria->registrar(
                request(),
                null,
                'Dar de baja lotes de medicamentos vencidos',
                'inventario',
                entidad: $primerLote,
                descripcion: 'El sistema retiró del stock los lotes vencidos y conservó su trazabilidad.',
                contexto: [
                    'lotes' => $idsLotes,
                    'cantidad_lotes' => count($idsLotes),
                    'cantidad_retirada' => $this->formatCents($totalCentavos),
                ],
                nombreUsuario: 'Sistema automático',
            );

            return [
                'lotes' => count($idsLotes),
                'cantidad' => $this->formatCents($totalCentavos),
                'articulos' => $lotesPorArticulo->count(),
            ];
        });
    }

    private function lotesUtilizables(ArticuloInventario $articulo, bool $lock = false): Collection
    {
        $query = InventarioLote::query()
            ->where('id_articulo', $articulo->getKey())
            ->where('cantidad_disponible', '>', 0)
            ->orderByRaw('CASE WHEN fecha_vencimiento IS NULL THEN 1 ELSE 0 END')
            ->orderBy('fecha_vencimiento')
            ->orderBy('id');

        if ($this->esMedicamento((string) $articulo->categoria, (string) $articulo->nombre)) {
            $query->whereNotNull('fecha_vencimiento')
                ->whereDate('fecha_vencimiento', '>=', Carbon::today());
        }

        if ($lock) {
            $query->lockForUpdate();
        }

        return $query->get();
    }

    /**
     * @return list<array{lote: InventarioLote, cantidad_centavos: int}>
     */
    private function descontarDeLotes(Collection $lotes, int $cantidadEnCentavos): array
    {
        $cantidadPendiente = $cantidadEnCentavos;
        $distribucion = [];

        foreach ($lotes as $lote) {
            if ($cantidadPendiente === 0) {
                break;
            }

            $cantidadLote = min(
                $cantidadPendiente,
                $this->decimalToCents($lote->cantidad_disponible),
            );

            if ($cantidadLote === 0) {
                continue;
            }

            $lote->decrement('cantidad_disponible', $cantidadLote / 100);
            $distribucion[] = [
                'lote' => $lote,
                'cantidad_centavos' => $cantidadLote,
            ];
            $cantidadPendiente -= $cantidadLote;
        }

        return $distribucion;
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
}
