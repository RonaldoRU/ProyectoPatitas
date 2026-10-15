<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class DetalleSalidaLote extends Model
{
    protected $table = 'detalle_salida_lotes';

    protected $fillable = [
        'id_detalle_salida',
        'id_inventario_lote',
        'cantidad',
    ];

    public function detalleSalida(): BelongsTo
    {
        return $this->belongsTo(DetalleSalida::class, 'id_detalle_salida');
    }

    public function lote(): BelongsTo
    {
        return $this->belongsTo(InventarioLote::class, 'id_inventario_lote');
    }
}
