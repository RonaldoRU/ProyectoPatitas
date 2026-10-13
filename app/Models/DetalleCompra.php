<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DetalleCompra extends Model
{
    protected $fillable = [
        'costo_unitario',
        'fecha_vencimiento',
        'cantidad',
        'id_compra',
        'id_articulo',
    ];
    //
}
