<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Bitacora extends Model
{
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

    protected function casts(): array
    {
        return [
            'contexto' => 'array',
        ];
    }

    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario');
    }
}
