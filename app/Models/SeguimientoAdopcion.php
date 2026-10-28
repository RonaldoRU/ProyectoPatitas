<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SeguimientoAdopcion extends Model
{
    protected $table = 'seguimiento_adopcions';

    protected $fillable = [
        'estado_seguimiento',
        'fecha_programada',
        'fecha_realizada',
        'fotografia',
        'reporte_bienestar',
        'id_adopcion',
        'id_usuario',
    ];

    public function adopcion(): BelongsTo
    {
        return $this->belongsTo(Adopcion::class, 'id_adopcion');
    }

    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario');
    }
}
