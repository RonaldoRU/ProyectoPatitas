<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P9_PagosDonaciones\DetalleDonacionInsumoController as BaseDetalleDonacionInsumoController;
use App\Models\ArticuloInventario;
use App\Models\DetalleDonacionInsumo;

class DetalleDonacionInsumoController extends BaseDetalleDonacionInsumoController
{
    /**
     * registrarInsumoDonado() : void
     */
    public function registrarInsumoDonado(int $idDonacion, int $idArticulo, int $cantidad): DetalleDonacionInsumo
    {
        return DetalleDonacionInsumo::query()->create([
            'id_donacion' => $idDonacion,
            'id_articulo' => $idArticulo,
            'cantidad' => $cantidad,
        ]);
    }

    /**
     * incorporarAlStock() : void
     */
    public function incorporarAlStock(int $idDetalleDonacion): void
    {
        $detalle = DetalleDonacionInsumo::query()->find($idDetalleDonacion);
        if ($detalle) {
            $articulo = ArticuloInventario::query()->find($detalle->id_articulo);
            if ($articulo) {
                $articulo->increment('stock_actual', $detalle->cantidad);
            }
        }
    }
}
