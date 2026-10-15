<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

class HistorialClinico extends Model
{
    protected $fillable = [
        'fecha_atencion',
        'diagnostico',
        'observacion',
        'tipo_procedimiento',
        'id_mascota',
        'id_usuario',
    ];

    public function mascota(): BelongsTo
    {
        return $this->belongsTo(Mascota::class, 'id_mascota');
    }

    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario');
    }

    public function salidaInventario(): HasOne
    {
        return $this->hasOne(SalidaInventario::class, 'id_historial_clinico');
    }
}
