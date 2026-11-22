<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

/**
 * Modelo ArticuloInventario: Catálogo de artículos e insumos médicos/alimenticios del albergue.
 * Controla nombre, categoría, unidad de medida, stock total actual y umbral mínimo para alertas.
 */
class ArticuloInventario extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'nombre',
        'categoria',
        'unidad_medida',
        'stock_actual',
        'stock_minimo_alerta',
    ];

    /**
     * Relación: Lotes físicos de este artículo con fechas de vencimiento individuales.
     */
    public function lotes(): HasMany
    {
        return $this->hasMany(InventarioLote::class, 'id_articulo');
    }

    /**
     * Relación: Extensión farmacológica especializada si el artículo es un medicamento veterinario.
     */
    public function medicamento(): HasOne
    {
        return $this->hasOne(Medicamento::class, 'articulo_id');
    }
}
