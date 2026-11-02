<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P5_Abastecimiento\DetalleCompraController as BaseDetalleCompraController;
use App\Models\DetalleCompra;

class DetalleCompraController extends BaseDetalleCompraController
{
    /**
     * insertarRenglonCompra() : void
     */
    public function insertarRenglonCompra(int $idCompra, int $idArticulo, int $cantidad, float $precioUnitario): DetalleCompra
    {
        $subtotal = $this->calcularSubtotal($cantidad, $precioUnitario);

        return DetalleCompra::query()->create([
            'id_compra' => $idCompra,
            'id_articulo' => $idArticulo,
            'cantidad' => $cantidad,
            'precio_unitario' => $precioUnitario,
            'subtotal' => $subtotal,
        ]);
    }

    /**
     * calcularSubtotal() : Decimal
     */
    public function calcularSubtotal(int $cantidad, float $precioUnitario): float
    {
        return round($cantidad * $precioUnitario, 2);
    }
}
