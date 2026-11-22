<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AuditoriaForense extends Model
{
    public $timestamps = false;

    protected $table = 'auditoria_forense';

    protected $fillable = [
        'fecha_evento',
        'usuario_id',
        'ip_origen',
        'user_agent',
        'severidad',
        'modulo',
        'accion',
        'tabla_afectada',
        'registro_id',
        'payload_anterior',
        'payload_nuevo',
        'hash_integridad',
    ];

    protected function casts(): array
    {
        return [
            'fecha_evento' => 'datetime',
            'payload_anterior' => 'array',
            'payload_nuevo' => 'array',
        ];
    }

    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'usuario_id');
    }
}
