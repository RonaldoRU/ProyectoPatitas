<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SeguimientoAdopcion extends Model
{
    protected $table = 'seguimiento_adopcions';

    protected $fillable = [
        'estado_seguimiento',
        'fecha_programada',
        'fecha_realizada',
        'fotografia',
        'reporte_bienestar',
        'id_adopcion',
        'id_usuario',
    ];
}
