<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Modelo SeguimientoAdopcion: Monitorea las visitas post-adopción a las mascotas adoptadas.
 * Registra fechas programadas/realizadas, reporte de bienestar animal, fotografías de prueba y estado.
 */
class SeguimientoAdopcion extends Model
{
    protected $table = 'seguimiento_adopcions';

    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'estado_seguimiento',
        'fecha_programada',
        'fecha_realizada',
        'fotografia',
        'reporte_bienestar',
        'id_adopcion',
        'id_usuario',
    ];

    /**
     * Relación: Adopción vinculada al seguimiento.
     */
    public function adopcion(): BelongsTo
    {
        return $this->belongsTo(Adopcion::class, 'id_adopcion');
    }

    /**
     * Relación: Voluntario o veterinario que realizó la visita de seguimiento.
     */
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario');
    }
}
