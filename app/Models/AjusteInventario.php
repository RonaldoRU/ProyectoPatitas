<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class AjusteInventario extends Model
{
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

    public function articulo(): BelongsTo
    {
        return $this->belongsTo(ArticuloInventario::class, 'id_articulo');
    }

    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario');
    }

    public function lotes(): HasMany
    {
        return $this->hasMany(AjusteInventarioLote::class, 'id_ajuste_inventario');
    }
}
