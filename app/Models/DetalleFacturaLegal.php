<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class DetalleFacturaLegal extends Model
{
    public $timestamps = false;

    protected $table = 'detalle_facturas_legales';

    protected $fillable = [
        'factura_id',
        'concepto',
        'cantidad',
        'precio_unitario',
        'subtotal',
        'referencia_tipo',
        'referencia_id',
    ];

    protected function casts(): array
    {
        return [
            'cantidad' => 'decimal:2',
            'precio_unitario' => 'decimal:2',
            'subtotal' => 'decimal:2',
        ];
    }

    public function factura(): BelongsTo
    {
        return $this->belongsTo(FacturaLegal::class, 'factura_id');
    }
}
