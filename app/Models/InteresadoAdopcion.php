<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class InteresadoAdopcion extends Model
{
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

    public function adopciones(): HasMany
    {
        return $this->hasMany(Adopcion::class, 'id_interesado');
    }
}
