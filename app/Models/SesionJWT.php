<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SesionJWT extends Model
{
    protected $table = 'sesion_jwt';

    protected $primaryKey = 'token_hash';

    public $incrementing = false;

    protected $keyType = 'string';

    public $timestamps = false;

    protected $fillable = [
        'token_hash',
        'id_usuario',
        'ip_cliente',
        'user_agent',
        'fecha_emision',
        'fecha_expiracion',
        'estado',
    ];

    protected $casts = [
        'fecha_emision' => 'datetime',
        'fecha_expiracion' => 'datetime',
    ];

    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario', 'id');
    }
}
