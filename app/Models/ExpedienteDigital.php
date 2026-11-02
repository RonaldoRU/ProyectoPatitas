<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ExpedienteDigital extends Model
{
    protected $table = 'expediente_digital';

    protected $primaryKey = 'nro_expediente';

    public $incrementing = false;

    protected $keyType = 'string';

    public $timestamps = false;

    protected $fillable = [
        'nro_expediente',
        'id_mascota',
        'estado_clinico',
        'fecha_apertura',
        'created_at',
    ];

    protected $casts = [
        'fecha_apertura' => 'date',
        'created_at' => 'datetime',
    ];

    public function mascota(): BelongsTo
    {
        return $this->belongsTo(Mascota::class, 'id_mascota', 'id');
    }
}
