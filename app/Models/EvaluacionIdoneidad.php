<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class EvaluacionIdoneidad extends Model
{
    protected $table = 'evaluacion_idoneidad';

    protected $primaryKey = 'id_evaluacion';

    public $timestamps = false;

    protected $fillable = [
        'id_interesado',
        'puntaje_vivienda',
        'puntaje_compromiso',
        'puntaje_total',
        'resultado',
        'observaciones',
        'created_at',
    ];

    protected $casts = [
        'puntaje_vivienda' => 'integer',
        'puntaje_compromiso' => 'integer',
        'puntaje_total' => 'integer',
        'created_at' => 'datetime',
    ];

    public function interesado(): BelongsTo
    {
        return $this->belongsTo(InteresadoAdopcion::class, 'id_interesado', 'id');
    }
}
