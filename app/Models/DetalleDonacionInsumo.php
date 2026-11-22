<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Modelo DetalleDonacionInsumo: Detalle de insumos materiales donados (alimento, medicinas, accesorios).
 * Registra cantidad, fecha de vencimiento y vinculación al inventario y a la donación.
 */
class DetalleDonacionInsumo extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'fecha_vencimiento',
        'cantidad',
        'id_donacion',
        'id_articulo',
    ];

    /**
     * Relación: Donación a la que pertenece este detalle.
     */
    public function donacion(): BelongsTo
    {
        return $this->belongsTo(Donacion::class, 'id_donacion');
    }

    /**
     * Relación: Artículo de inventario donado.
     */
    public function articulo(): BelongsTo
    {
        return $this->belongsTo(ArticuloInventario::class, 'id_articulo');
    }
}
