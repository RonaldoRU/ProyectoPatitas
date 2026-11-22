<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class PrescripcionDosificacion extends Model
{
    protected $table = 'prescripciones_dosificacion';

    protected $fillable = [
        'mascota_id',
        'historial_clinico_id',
        'articulo_id',
        'veterinario_id',
        'peso_mascota_kg',
        'dosis_mg_kg',
        'concentracion_farmaco',
        'dosis_calculada_unidad',
        'unidad_medida',
        'frecuencia_horas',
        'duracion_dias',
        'observaciones_clinicas',
        'estado',
    ];

    protected function casts(): array
    {
        return [
            'peso_mascota_kg' => 'decimal:2',
            'dosis_mg_kg' => 'decimal:3',
            'concentracion_farmaco' => 'decimal:3',
            'dosis_calculada_unidad' => 'decimal:3',
        ];
    }

    public function mascota(): BelongsTo
    {
        return $this->belongsTo(Mascota::class, 'mascota_id');
    }

    public function articulo(): BelongsTo
    {
        return $this->belongsTo(ArticuloInventario::class, 'articulo_id');
    }

    public function medicamento(): BelongsTo
    {
        return $this->belongsTo(Medicamento::class, 'medicamento_id');
    }

    public function veterinario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'veterinario_id');
    }

    public function cronograma(): HasMany
    {
        return $this->hasMany(CronogramaTratamiento::class, 'prescripcion_id');
    }
}
