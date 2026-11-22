<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Modelo SalidaInventario: Registra egresos o consumos de insumos del inventario (por atención clínica, uso interno o descarte).
 * Vincula al usuario responsable y opcionalmente a la consulta de historial clínico atendida.
 */
class SalidaInventario extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'motivo',
        'id_usuario',
        'fecha_salida',
        'id_historial_clinico',
    ];

    /**
     * Relación: Atención veterinaria asociada que consumió los medicamentos/insumos.
     */
    public function historialClinico(): BelongsTo
    {
        return $this->belongsTo(HistorialClinico::class, 'id_historial_clinico');
    }

    /**
     * Relación: Usuario que registró el egreso de inventario.
     */
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario');
    }

    /**
     * Relación: Líneas de detalle de artículos egresados.
     */
    public function detalles(): HasMany
    {
        return $this->hasMany(DetalleSalida::class, 'id_salida');
    }
}
