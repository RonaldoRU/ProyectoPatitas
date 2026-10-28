<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Adopcion extends Model
{
    protected $fillable = [
        'fecha_adopcion',
        'id_interesado',
        'id_mascota',
    ];

    public function interesado(): BelongsTo
    {
        return $this->belongsTo(InteresadoAdopcion::class, 'id_interesado');
    }

    public function mascota(): BelongsTo
    {
        return $this->belongsTo(Mascota::class, 'id_mascota');
    }

    public function seguimientos(): HasMany
    {
        return $this->hasMany(SeguimientoAdopcion::class, 'id_adopcion');
    }
}
