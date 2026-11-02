<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AlertaInventario extends Model
{
    protected $table = 'alerta_inventario';

    protected $primaryKey = 'id_alerta';

    public $timestamps = false;

    protected $fillable = [
        'id_articulo',
        'nivel_criticidad',
        'fecha_generada',
        'estado',
    ];

    protected $casts = [
        'fecha_generada' => 'datetime',
    ];

    public function articulo(): BelongsTo
    {
        return $this->belongsTo(ArticuloInventario::class, 'id_articulo', 'id');
    }
}
