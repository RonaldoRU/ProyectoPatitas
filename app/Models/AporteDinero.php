<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AporteDinero extends Model
{
    protected $fillable = [
        'monto',
        'fecha_recepcion',
        'comprobante',
        'observaciones',
        'id_donacion',
    ];

    public function donacion(): BelongsTo
    {
        return $this->belongsTo(Donacion::class, 'id_donacion');
    }
}
