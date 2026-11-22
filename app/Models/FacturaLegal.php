<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class FacturaLegal extends Model
{
    protected $table = 'facturas_legales';

    protected $fillable = [
        'dosificacion_id',
        'numero_factura',
        'numero_autorizacion',
        'fecha_emision',
        'nit_ci_cliente',
        'complemento_ci',
        'razon_social_cliente',
        'subtotal',
        'descuento',
        'importe_total',
        'importe_base_cf',
        'debito_fiscal',
        'codigo_control',
        'cadena_qr',
        'estado',
        'motivo_anulacion',
        'fecha_anulacion',
        'usuario_emisor_id',
        'usuario_anulador_id',
    ];

    protected function casts(): array
    {
        return [
            'fecha_emision' => 'datetime',
            'fecha_anulacion' => 'datetime',
            'subtotal' => 'decimal:2',
            'descuento' => 'decimal:2',
            'importe_total' => 'decimal:2',
            'importe_base_cf' => 'decimal:2',
            'debito_fiscal' => 'decimal:2',
        ];
    }

    public function dosificacion(): BelongsTo
    {
        return $this->belongsTo(DosificacionFiscal::class, 'dosificacion_id');
    }

    public function detalles(): HasMany
    {
        return $this->hasMany(DetalleFacturaLegal::class, 'factura_id');
    }

    public function emisor(): BelongsTo
    {
        return $this->belongsTo(User::class, 'usuario_emisor_id');
    }

    public function anulador(): BelongsTo
    {
        return $this->belongsTo(User::class, 'usuario_anulador_id');
    }
}
