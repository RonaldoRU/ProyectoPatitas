<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Donacion extends Model
{
    protected $fillable = [
        'id_usuario',
        'tipo_aporte',
        'fecha',
        'id_donante',
    ];
    //
}
