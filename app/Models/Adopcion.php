<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Modelo Adopcion: Registra la formalización de la entrega de una mascota a un adoptante aprobado.
 * Vincula al interesado, a la mascota y contiene el historial de visitas de seguimiento post-adopción.
 */
class Adopcion extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'fecha_adopcion',
        'id_interesado',
        'id_mascota',
    ];

    /**
     * Relación: Interesado/Postulante que adoptó a la mascota.
     */
    public function interesado(): BelongsTo
    {
        return $this->belongsTo(InteresadoAdopcion::class, 'id_interesado');
    }

    /**
     * Relación: Mascota entregada en adopción.
     */
    public function mascota(): BelongsTo
    {
        return $this->belongsTo(Mascota::class, 'id_mascota');
    }

    /**
     * Relación: Visitas de seguimiento post-adopción programadas y realizadas.
     */
    public function seguimientos(): HasMany
    {
        return $this->hasMany(SeguimientoAdopcion::class, 'id_adopcion');
    }
}
