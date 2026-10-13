<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DetalleSalida extends Model
{
    protected $fillable = [
        'id_articulo',
        'cantidad',
        'id_salida',
    ];
    //
}
