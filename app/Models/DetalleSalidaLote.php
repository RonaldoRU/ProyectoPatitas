<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Modelo DetalleSalidaLote: Trazabilidad FIFO por lote para cada salida de inventario.
 * Registra exactamente cuántas unidades se descontaron de qué lote específico.
 */
class DetalleSalidaLote extends Model
{
    protected $table = 'detalle_salida_lotes';

    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'id_detalle_salida',
        'id_inventario_lote',
        'cantidad',
    ];

    /**
     * Relación: Línea de detalle de salida general.
     */
    public function detalleSalida(): BelongsTo
    {
        return $this->belongsTo(DetalleSalida::class, 'id_detalle_salida');
    }

    /**
     * Relación: Lote físico del cual se extrajo la cantidad.
     */
    public function lote(): BelongsTo
    {
        return $this->belongsTo(InventarioLote::class, 'id_inventario_lote');
    }
}
