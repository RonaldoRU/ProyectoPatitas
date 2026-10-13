<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

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
}
