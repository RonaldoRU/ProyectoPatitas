<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SalidaInventario extends Model
{
    protected $fillable = [
        'motivo',
        'id_usuario',
        'fecha_salida',
    ];
}
