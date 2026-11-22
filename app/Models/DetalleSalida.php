<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Modelo DetalleSalida: Detalle del artículo específico y la cantidad global egresada en una salida.
 */
class DetalleSalida extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'id_articulo',
        'cantidad',
        'id_salida',
    ];

    /**
     * Relación: Registro general de salida al que pertenece este ítem.
     */
    public function salida(): BelongsTo
    {
        return $this->belongsTo(SalidaInventario::class, 'id_salida');
    }

    /**
     * Relación: Artículo de inventario extraído.
     */
    public function articulo(): BelongsTo
    {
        return $this->belongsTo(ArticuloInventario::class, 'id_articulo');
    }
}
