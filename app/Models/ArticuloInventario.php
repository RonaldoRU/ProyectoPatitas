<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ArticuloInventario extends Model
{
    protected $fillable = [
        'nombre',
        'categoria',
        'unidad_medida',
        'stock_actual',
        'stock_minimo_alerta',
    ];
    //
}
