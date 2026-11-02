<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P9_PagosDonaciones\DonanteController as BaseDonanteController;
use App\Models\Donacion;
use App\Models\Donante;
use Illuminate\Database\Eloquent\Collection;

class DonanteController extends BaseDonanteController
{
    /**
     * registrarDonante() : Int
     */
    public function registrarDonante(array $datos): int
    {
        $donante = Donante::query()->create($datos);

        return $donante->id;
    }

    /**
     * consultarHistorialAportes() : List<Donacion>
     */
    public function consultarHistorialAportes(int $idDonante): Collection
    {
        return Donacion::query()
            ->with(['aporteDinero', 'detalleInsumos'])
            ->where('id_donante', $idDonante)
            ->orderByDesc('fecha')
            ->get();
    }
}
