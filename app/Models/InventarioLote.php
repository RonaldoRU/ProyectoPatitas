<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Modelo InventarioLote: Control de lotes por fecha de vencimiento (método FIFO/PEPS).
 * Permite saber exactamente qué cantidad queda en cada lote y registrar expiraciones.
 */
class InventarioLote extends Model
{
    protected $table = 'inventario_lotes';

    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'id_articulo',
        'id_detalle_compra',
        'id_detalle_donacion',
        'fecha_vencimiento',
        'cantidad_inicial',
        'cantidad_disponible',
        'cantidad_vencida',
    ];

    /**
     * Conversión de tipos para atributos del modelo.
     */
    protected function casts(): array
    {
        return [
            'fecha_vencimiento' => 'date',
        ];
    }

    /**
     * Relación: Artículo de inventario al que pertenece el lote.
     */
    public function articulo(): BelongsTo
    {
        return $this->belongsTo(ArticuloInventario::class, 'id_articulo');
    }

    /**
     * Relación: Compra que originó este lote (si proviene de adquisición directa).
     */
    public function detalleCompra(): BelongsTo
    {
        return $this->belongsTo(DetalleCompra::class, 'id_detalle_compra');
    }

    /**
     * Relación: Donación que originó este lote (si proviene de donación física).
     */
    public function detalleDonacion(): BelongsTo
    {
        return $this->belongsTo(DetalleDonacionInsumo::class, 'id_detalle_donacion');
    }

    /**
     * Relación: Registros de salida/consumo realizados a partir de este lote específico.
     */
    public function consumos(): HasMany
    {
        return $this->hasMany(DetalleSalidaLote::class, 'id_inventario_lote');
    }
}
