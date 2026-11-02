<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P5_Abastecimiento\SalidaInventarioController as BaseSalidaInventarioController;
use App\Models\ArticuloInventario;
use App\Models\SalidaInventario;

class SalidaInventarioController extends BaseSalidaInventarioController
{
    /**
     * registrarDespacho() : Int
     */
    public function registrarDespacho(array $datos): int
    {
        $salida = SalidaInventario::query()->create($datos);

        return $salida->id;
    }

    /**
     * validarDisponibilidadStock() : Boolean
     */
    public function validarDisponibilidadStock(int $idArticulo, int $cantidadSolicitada): bool
    {
        $articulo = ArticuloInventario::query()->find($idArticulo);

        return $articulo && ($articulo->stock_actual >= $cantidadSolicitada);
    }
}
