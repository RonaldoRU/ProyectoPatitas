<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Proveedor extends Model
{
    protected $fillable = [
        'nombre_empresa',
        'nombre_contacto',
        'telefono',
        'direccion',
    ];
    //
}
