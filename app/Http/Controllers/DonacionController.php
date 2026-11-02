<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P9_PagosDonaciones\DonacionController as BaseDonacionController;
use App\Models\Donacion;

class DonacionController extends BaseDonacionController
{
    /**
     * registrarRecepcion() : Int
     */
    public function registrarRecepcion(array $datos): int
    {
        $donacion = Donacion::query()->create($datos);

        return $donacion->id;
    }

    /**
     * emitirReciboDonacion() : void
     */
    public function emitirReciboDonacion(int $idDonacion): string
    {
        $donacion = Donacion::query()->with('donante')->findOrFail($idDonacion);

        return "RECIBO-DONACION-{$donacion->id}.pdf";
    }

    /**
     * totalizarPorPeriodo(desde: Date, hasta: Date) : Decimal
     */
    public function totalizarPorPeriodo(string $desde, string $hasta): float
    {
        return (float) Donacion::query()
            ->whereHas('aporteDinero')
            ->with('aporteDinero')
            ->whereDate('fecha', '>=', $desde)
            ->whereDate('fecha', '<=', $hasta)
            ->get()
            ->sum(fn ($d) => $d->aporteDinero?->monto ?? 0);
    }
}
