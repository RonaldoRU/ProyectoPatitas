<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P5_Abastecimiento\DetalleSalidaController as BaseDetalleSalidaController;
use App\Models\DetalleSalida;

class DetalleSalidaController extends BaseDetalleSalidaController
{
    /**
     * insertarRenglonSalida() : void
     */
    public function insertarRenglonSalida(int $idSalida, int $idArticulo, int $cantidad): DetalleSalida
    {
        return DetalleSalida::query()->create([
            'id_salida' => $idSalida,
            'id_articulo' => $idArticulo,
            'cantidad' => $cantidad,
        ]);
    }
}
