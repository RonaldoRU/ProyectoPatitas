<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class DosificacionFiscal extends Model
{
    protected $table = 'dosificaciones_fiscales';

    protected $fillable = [
        'nit_emisor',
        'numero_autorizacion',
        'llave_dosificacion',
        'numero_inicial',
        'numero_final',
        'correlativo_actual',
        'fecha_limite_emision',
        'leyenda_tributaria',
        'activa',
        'created_by',
    ];

    protected $hidden = [
        'llave_dosificacion',
    ];

    protected function casts(): array
    {
        return [
            'llave_dosificacion' => 'encrypted',
            'fecha_limite_emision' => 'date',
            'activa' => 'boolean',
        ];
    }

    public function creador(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function facturas(): HasMany
    {
        return $this->hasMany(FacturaLegal::class, 'dosificacion_id');
    }
}
