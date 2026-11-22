<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Modelo Donante: Entidad que aporta donaciones físicas o monetarias al refugio.
 * Puede ser de tipo persona Natural o Jurídica (empresas, fundaciones).
 */
class Donante extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'nombre',
        'telefono',
        'tipo_persona',
    ];

    /**
     * Relación: Donaciones realizadas por este donante.
     */
    public function donaciones(): HasMany
    {
        return $this->hasMany(Donacion::class, 'id_donante');
    }
}
