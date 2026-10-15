<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Donacion extends Model
{
    protected $fillable = [
        'id_usuario',
        'tipo_aporte',
        'fecha',
        'numero_documento',
        'id_donante',
    ];

    public function donante(): BelongsTo
    {
        return $this->belongsTo(Donante::class, 'id_donante');
    }
}
