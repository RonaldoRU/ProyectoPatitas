<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Modelo AjusteInventarioLote: Registra la cantidad exacta ajustada para un lote específico.
 */
class AjusteInventarioLote extends Model
{
    public $timestamps = false;

    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'id_ajuste_inventario',
        'id_inventario_lote',
        'cantidad',
    ];

    /**
     * Relación: Ajuste general de inventario.
     */
    public function ajuste(): BelongsTo
    {
        return $this->belongsTo(AjusteInventario::class, 'id_ajuste_inventario');
    }

    /**
     * Relación: Lote afectado por el ajuste.
     */
    public function lote(): BelongsTo
    {
        return $this->belongsTo(InventarioLote::class, 'id_inventario_lote');
    }
}
