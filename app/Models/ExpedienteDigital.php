<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Modelo ExpedienteDigital: Código único de expediente clínico para cada mascota rescatada.
 * Centraliza la ficha médica general, fecha de apertura y estado clínico del animal.
 */
class ExpedienteDigital extends Model
{
    protected $table = 'expediente_digital';

    protected $primaryKey = 'nro_expediente';

    public $incrementing = false;

    protected $keyType = 'string';

    public $timestamps = false;

    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'nro_expediente',
        'id_mascota',
        'estado_clinico',
        'fecha_apertura',
        'created_at',
    ];

    /**
     * Conversión de tipos.
     */
    protected $casts = [
        'fecha_apertura' => 'date',
        'created_at' => 'datetime',
    ];

    /**
     * Relación: Mascota propietaria del expediente clínico.
     */
    public function mascota(): BelongsTo
    {
        return $this->belongsTo(Mascota::class, 'id_mascota', 'id');
    }
}
