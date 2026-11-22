<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Modelo Bitacora: Registro centralizado e inmutable de auditoría del sistema.
 * Registra quién realizó qué acción, en qué módulo, método HTTP, IP, entidad afectada y resultado.
 */
class Bitacora extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'tipo_accion',
        'id_usuario',
        'usuario_nombre',
        'modulo',
        'descripcion',
        'entidad_tipo',
        'entidad_id',
        'ip',
        'http_method',
        'ruta',
        'resultado',
        'contexto',
    ];

    /**
     * Conversión automática de campos JSON.
     */
    protected function casts(): array
    {
        return [
            'contexto' => 'array',
        ];
    }

    /**
     * Relación: Usuario que ejecutó la acción auditada (null si fue invitado o anónimo).
     */
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario');
    }
}
