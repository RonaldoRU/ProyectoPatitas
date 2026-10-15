<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AjusteInventarioLote extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'id_ajuste_inventario',
        'id_inventario_lote',
        'cantidad',
    ];

    public function ajuste(): BelongsTo
    {
        return $this->belongsTo(AjusteInventario::class, 'id_ajuste_inventario');
    }

    public function lote(): BelongsTo
    {
        return $this->belongsTo(InventarioLote::class, 'id_inventario_lote');
    }
}
