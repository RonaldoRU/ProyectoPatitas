<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CronogramaTratamiento extends Model
{
    public $timestamps = false;

    protected $table = 'cronograma_tratamientos';

    protected $fillable = [
        'prescripcion_id',
        'lote_inventario_id',
        'fecha_hora_programada',
        'fecha_hora_administrada',
        'administrado_por',
        'estado',
        'notas',
    ];

    protected function casts(): array
    {
        return [
            'fecha_hora_programada' => 'datetime',
            'fecha_hora_administrada' => 'datetime',
        ];
    }

    public function prescripcion(): BelongsTo
    {
        return $this->belongsTo(PrescripcionDosificacion::class, 'prescripcion_id');
    }

    public function lote(): BelongsTo
    {
        return $this->belongsTo(InventarioLote::class, 'lote_inventario_id');
    }

    public function administrador(): BelongsTo
    {
        return $this->belongsTo(User::class, 'administrado_por');
    }
}
