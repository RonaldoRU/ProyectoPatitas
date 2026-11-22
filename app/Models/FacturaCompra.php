<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class FacturaCompra extends Model
{
    public const UPDATED_AT = null;

    protected $table = 'facturas_compras';

    protected $fillable = [
        'proveedor_id',
        'fecha_factura',
        'nit_proveedor',
        'razon_social_proveedor',
        'numero_factura',
        'numero_autorizacion',
        'codigo_control',
        'importe_total',
        'importe_exento',
        'importe_base_cf',
        'credito_fiscal',
        'registrado_por',
    ];

    protected function casts(): array
    {
        return [
            'fecha_factura' => 'date',
            'importe_total' => 'decimal:2',
            'importe_exento' => 'decimal:2',
            'importe_base_cf' => 'decimal:2',
            'credito_fiscal' => 'decimal:2',
        ];
    }

    public function proveedor(): BelongsTo
    {
        return $this->belongsTo(Proveedor::class, 'proveedor_id');
    }

    public function registrador(): BelongsTo
    {
        return $this->belongsTo(User::class, 'registrado_por');
    }
}
