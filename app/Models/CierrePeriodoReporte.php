<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CierrePeriodoReporte extends Model
{
    public const UPDATED_AT = null;

    protected $table = 'cierres_periodos_reportes';

    protected $fillable = [
        'anio',
        'mes',
        'tipo_reporte',
        'periodo_cerrado',
        'hash_documento',
        'generado_por',
    ];

    protected function casts(): array
    {
        return [
            'periodo_cerrado' => 'boolean',
        ];
    }

    public function generador(): BelongsTo
    {
        return $this->belongsTo(User::class, 'generado_por');
    }
}
