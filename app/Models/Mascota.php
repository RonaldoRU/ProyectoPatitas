<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

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

    public function historialesClinicos(): HasMany
    {
        return $this->hasMany(HistorialClinico::class, 'id_mascota');
    }
}
