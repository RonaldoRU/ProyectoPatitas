<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Donante extends Model
{
    protected $fillable = [
        'nombre',
        'telefono',
        'tipo_persona',
    ];
    //
}
