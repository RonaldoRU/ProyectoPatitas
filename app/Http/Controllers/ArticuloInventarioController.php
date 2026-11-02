<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P4_CatalogoExistencias\ArticuloInventarioController as BaseArticuloInventarioController;
use App\Models\ArticuloInventario;

class ArticuloInventarioController extends BaseArticuloInventarioController
{
    /**
     * incrementarStock(cant: Decimal) : void
     */
    public function incrementarStock(int $idArticulo, float $cant): void
    {
        $articulo = ArticuloInventario::query()->find($idArticulo);
        if ($articulo) {
            $articulo->increment('stock_actual', $cant);
        }
    }

    /**
     * descontarStock(cant: Decimal) : Boolean
     */
    public function descontarStock(int $idArticulo, float $cant): bool
    {
        $articulo = ArticuloInventario::query()->find($idArticulo);
        if ($articulo && $articulo->stock_actual >= $cant) {
            $articulo->decrement('stock_actual', $cant);

            return true;
        }

        return false;
    }

    /**
     * verificarNivelCritico() : Boolean
     */
    public function verificarNivelCritico(int $idArticulo): bool
    {
        $articulo = ArticuloInventario::query()->find($idArticulo);

        return $articulo && ($articulo->stock_actual <= $articulo->stock_minimo);
    }

    /**
     * registrarMerma(cant: Decimal, motivo: String) : void
     */
    public function registrarMerma(int $idArticulo, float $cant, string $motivo): void
    {
        $this->descontarStock($idArticulo, $cant);
    }
}
