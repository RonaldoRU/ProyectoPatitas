<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Modelo AlertaInventario: Notificaciones automáticas por stock bajo o proximidad a fecha de vencimiento.
 * Gestiona niveles de criticidad (Bajo, Medio, Alto) y estados de resolución.
 */
class AlertaInventario extends Model
{
    protected $table = 'alerta_inventario';

    protected $primaryKey = 'id_alerta';

    public $timestamps = false;

    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'id_articulo',
        'nivel_criticidad',
        'fecha_generada',
        'estado',
    ];

    /**
     * Conversión de tipos.
     */
    protected $casts = [
        'fecha_generada' => 'datetime',
    ];

    /**
     * Relación: Artículo al que corresponde la alerta.
     */
    public function articulo(): BelongsTo
    {
        return $this->belongsTo(ArticuloInventario::class, 'id_articulo', 'id');
    }
}
