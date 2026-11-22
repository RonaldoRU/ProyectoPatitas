<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Modelo TipoAporte: Clasificador de canales y tipos de donación (Dinero, Insumo Médico, Alimento, etc.).
 */
class TipoAporte extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'nombre',
        'descripcion',
    ];
}
