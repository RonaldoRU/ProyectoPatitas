<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Mascota extends Model
{
    protected $fillable = [
        'nombre',
        'raza',
        'edad',
        'especie',
        'estado_actual',
        'fecha_ingreso',
        'sexo',
        'zona_rescate',
        'foto',
    ];
    //
}
