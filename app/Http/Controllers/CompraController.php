<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P5_Abastecimiento\CompraController as BaseCompraController;
use App\Models\Compra;

class CompraController extends BaseCompraController
{
    /**
     * registrarCabeceraCompra() : Int
     */
    public function registrarCabeceraCompra(array $datos): int
    {
        $compra = Compra::query()->create($datos);

        return $compra->id;
    }

    /**
     * calcularTotalCompra() : Decimal
     */
    public function calcularTotalCompra(int $idCompra): float
    {
        $compra = Compra::query()->with('detalles')->find($idCompra);
        if (! $compra) {
            return 0.0;
        }

        return (float) $compra->detalles->sum('subtotal');
    }
}
