<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

/**
 * Modelo HistorialClinico: Registra las atenciones médicas veterinarias realizadas a una mascota.
 * Incluye diagnóstico, observaciones, tipo de procedimiento y vinculación con egreso de insumos médicos.
 */
class HistorialClinico extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'fecha_atencion',
        'diagnostico',
        'observacion',
        'tipo_procedimiento',
        'id_mascota',
        'id_usuario',
    ];

    /**
     * Relación: Mascota que recibió la atención veterinaria.
     */
    public function mascota(): BelongsTo
    {
        return $this->belongsTo(Mascota::class, 'id_mascota');
    }

    /**
     * Relación: Usuario/Veterinario que atendió y registró la consulta.
     */
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario');
    }

    /**
     * Relación: Registro de salida de insumos/medicamentos del inventario utilizados en esta atención.
     */
    public function salidaInventario(): HasOne
    {
        return $this->hasOne(SalidaInventario::class, 'id_historial_clinico');
    }
}
