<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Modelo AjusteInventario: Registra ajustes manuales o automáticos al stock (por pérdidas, mermas, conteo físico o vencimientos).
 * Mantiene la auditoría del stock anterior, nuevo, saldos y motivo del ajuste.
 */
class AjusteInventario extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'id_articulo',
        'id_usuario',
        'usuario_nombre',
        'cantidad',
        'stock_anterior',
        'stock_nuevo',
        'saldo_disponible_anterior',
        'saldo_disponible_nuevo',
        'motivo',
    ];

    /**
     * Relación: Artículo al que se le aplicó el ajuste.
     */
    public function articulo(): BelongsTo
    {
        return $this->belongsTo(ArticuloInventario::class, 'id_articulo');
    }

    /**
     * Relación: Usuario responsable de aplicar el ajuste.
     */
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario');
    }

    /**
     * Relación: Desglose de lotes afectados por este ajuste.
     */
    public function lotes(): HasMany
    {
        return $this->hasMany(AjusteInventarioLote::class, 'id_ajuste_inventario');
    }
}
