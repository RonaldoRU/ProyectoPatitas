<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class HistorialClinico extends Model
{
    protected $fillable = [
        'fecha_atencion',
        'diagnostico',
        'observacion',
        'tipo_procedimiento',
        'id_mascota',
        'id_usuario',
    ];
    //
}
