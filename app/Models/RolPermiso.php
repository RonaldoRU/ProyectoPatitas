<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RolPermiso extends Model
{
    protected $table = 'rol_permiso';

    protected $primaryKey = 'id_rol';

    public $timestamps = false;

    protected $fillable = [
        'nombre_rol',
        'descripcion',
        'permisos_modulos',
        'created_at',
    ];

    protected $casts = [
        'created_at' => 'datetime',
    ];
}
