<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SalidaInventario extends Model
{
    protected $fillable = [
        'motivo',
        'id_usuario',
        'fecha_salida',
        'id_historial_clinico',
    ];

    public function historialClinico(): BelongsTo
    {
        return $this->belongsTo(HistorialClinico::class, 'id_historial_clinico');
    }
}
