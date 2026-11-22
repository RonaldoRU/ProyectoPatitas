<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Modelo RolPermiso: Define los perfiles o roles del sistema y la matriz de permisos por módulo.
 */
class RolPermiso extends Model
{
    protected $table = 'rol_permiso';

    protected $primaryKey = 'id_rol';

    public $timestamps = false;

    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'nombre_rol',
        'descripcion',
        'permisos_modulos',
        'created_at',
    ];

    /**
     * Conversión de tipos.
     */
    protected $casts = [
        'created_at' => 'datetime',
    ];
}
