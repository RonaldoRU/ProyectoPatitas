<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Compra extends Model
{
    protected $fillable = [
        'monto_total',
        'fecha_compra',
        'id_proveedor',
        'id_usuario',
    ];
    //
}
