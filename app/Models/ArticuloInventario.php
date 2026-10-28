<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ArticuloInventario extends Model
{
    protected $fillable = [
        'nombre',
        'categoria',
        'unidad_medida',
        'stock_actual',
        'stock_minimo_alerta',
    ];

    public function lotes(): HasMany
    {
        return $this->hasMany(InventarioLote::class, 'id_articulo');
    }
}
