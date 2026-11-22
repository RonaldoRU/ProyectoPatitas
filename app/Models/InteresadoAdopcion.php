<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Modelo InteresadoAdopcion: Representa a los postulantes o interesados en adoptar una mascota.
 * Almacena su información de contacto, datos de vivienda, evaluación socioambiental y estado (Pendiente, Aprobado, Rechazado).
 */
class InteresadoAdopcion extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'ci',
        'nombre',
        'direccion',
        'telefono',
        'situacion_casa',
        'referencias',
        'puntaje_evaluacion',
        'estado',
    ];

    /**
     * Relación: Adopciones formalizadas con este interesado.
     */
    public function adopciones(): HasMany
    {
        return $this->hasMany(Adopcion::class, 'id_interesado');
    }
}
