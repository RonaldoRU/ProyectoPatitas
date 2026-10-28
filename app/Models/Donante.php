<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Donante extends Model
{
    protected $fillable = [
        'nombre',
        'telefono',
        'tipo_persona',
    ];

    public function donaciones(): HasMany
    {
        return $this->hasMany(Donacion::class, 'id_donante');
    }
}
