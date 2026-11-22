<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Modelo SesionJWT: Control de tokens de sesión emitidos para clientes y dispositivos.
 * Monitorea validez temporal, revocación, IP del cliente y navegador utilizado.
 */
class SesionJWT extends Model
{
    protected $table = 'sesion_jwt';

    protected $primaryKey = 'token_hash';

    public $incrementing = false;

    protected $keyType = 'string';

    public $timestamps = false;

    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'token_hash',
        'id_usuario',
        'ip_cliente',
        'user_agent',
        'fecha_emision',
        'fecha_expiracion',
        'estado',
    ];

    /**
     * Conversión de tipos.
     */
    protected $casts = [
        'fecha_emision' => 'datetime',
        'fecha_expiracion' => 'datetime',
    ];

    /**
     * Relación: Usuario al que se le emitió la sesión JWT.
     */
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario', 'id');
    }
}
