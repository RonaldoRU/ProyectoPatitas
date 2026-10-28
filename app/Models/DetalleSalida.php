<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class DetalleSalida extends Model
{
    protected $fillable = [
        'id_articulo',
        'cantidad',
        'id_salida',
    ];

    public function salida(): BelongsTo
    {
        return $this->belongsTo(SalidaInventario::class, 'id_salida');
    }

    public function articulo(): BelongsTo
    {
        return $this->belongsTo(ArticuloInventario::class, 'id_articulo');
    }
}
