<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Modelo Compra: Representa la adquisición de insumos/medicamentos a proveedores autorizados.
 * Registra monto total, fecha, número de factura/recibo, proveedor y usuario responsable.
 */
class Compra extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'monto_total',
        'fecha_compra',
        'numero_documento',
        'id_proveedor',
        'id_usuario',
    ];

    /**
     * Relación: Proveedor que suministró la compra.
     */
    public function proveedor(): BelongsTo
    {
        return $this->belongsTo(Proveedor::class, 'id_proveedor');
    }

    /**
     * Relación: Usuario administrativo que registró la compra.
     */
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario');
    }

    /**
     * Relación: Líneas de detalle de artículos adquiridos en esta compra.
     */
    public function detalles(): HasMany
    {
        return $this->hasMany(DetalleCompra::class, 'id_compra');
    }
}
