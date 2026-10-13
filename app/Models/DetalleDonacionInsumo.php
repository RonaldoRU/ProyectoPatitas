<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DetalleDonacionInsumo extends Model
{
    protected $fillable = [
        'fecha_vencimiento',
        'cantidad',
        'id_donacion',
        'id_articulo',
    ];
    //
}
