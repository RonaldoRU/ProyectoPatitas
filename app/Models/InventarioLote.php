<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class InventarioLote extends Model
{
    protected $table = 'inventario_lotes';

    protected $fillable = [
        'id_articulo',
        'id_detalle_compra',
        'id_detalle_donacion',
        'fecha_vencimiento',
        'cantidad_inicial',
        'cantidad_disponible',
        'cantidad_vencida',
    ];

    protected function casts(): array
    {
        return [
            'fecha_vencimiento' => 'date',
        ];
    }

    public function articulo(): BelongsTo
    {
        return $this->belongsTo(ArticuloInventario::class, 'id_articulo');
    }

    public function detalleCompra(): BelongsTo
    {
        return $this->belongsTo(DetalleCompra::class, 'id_detalle_compra');
    }

    public function detalleDonacion(): BelongsTo
    {
        return $this->belongsTo(DetalleDonacionInsumo::class, 'id_detalle_donacion');
    }

    public function consumos(): HasMany
    {
        return $this->hasMany(DetalleSalidaLote::class, 'id_inventario_lote');
    }
}
