<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Modelo Mascota: Representa a los animales rescatados registrados en el albergue.
 * Maneja datos como nombre, raza, edad, especie, estado médico/adopción y su historial clínico.
 */
class Mascota extends Model
{
    /**
     * Atributos que se pueden asignar masivamente.
     */
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

    /**
     * Relación: Una mascota puede tener múltiples registros en su historial clínico.
     */
    public function historialesClinicos(): HasMany
    {
        return $this->hasMany(HistorialClinico::class, 'id_mascota');
    }
}
