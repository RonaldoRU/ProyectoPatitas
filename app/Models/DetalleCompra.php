<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Modelo DetalleCompra: Desglose de cada producto comprado (cantidad, costo unitario, fecha de vencimiento).
 * Impacta directamente las existencias del catálogo de inventario y crea nuevos lotes disponibles.
 */
class DetalleCompra extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'costo_unitario',
        'fecha_vencimiento',
        'cantidad',
        'id_compra',
        'id_articulo',
    ];

    /**
     * Relación: Compra cabecera a la que pertenece este ítem.
     */
    public function compra(): BelongsTo
    {
        return $this->belongsTo(Compra::class, 'id_compra');
    }

    /**
     * Relación: Artículo adquirido del inventario.
     */
    public function articulo(): BelongsTo
    {
        return $this->belongsTo(ArticuloInventario::class, 'id_articulo');
    }
}
