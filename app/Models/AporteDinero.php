<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AporteDinero extends Model
{
    //
    protected $fillable = [
        'monto',
        'fecha_recepcion',
        'comprobante',
        'observaciones',
        'id_donacion',
    ];
}
