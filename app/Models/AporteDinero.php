<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Modelo AporteDinero: Registra transacciones monetarias recibidas por donaciones (efectivo, QR, tarjeta Stripe, transferencia).
 * Contiene el monto, fecha de recepción, comprobante de pago u orden de referencia y observaciones.
 */
class AporteDinero extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'monto',
        'fecha_recepcion',
        'comprobante',
        'observaciones',
        'id_donacion',
    ];

    /**
     * Relación: Donación a la que pertenece este aporte monetario.
     */
    public function donacion(): BelongsTo
    {
        return $this->belongsTo(Donacion::class, 'id_donacion');
    }
}
