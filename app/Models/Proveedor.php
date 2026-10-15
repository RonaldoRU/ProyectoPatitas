<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Proveedor extends Model
{
    protected $fillable = [
        'nombre_empresa',
        'nombre_contacto',
        'telefono',
        'direccion',
        'identificacion',
        'tipo_insumo_provisto',
        'activo',
    ];

    protected function casts(): array
    {
        return [
            'activo' => 'boolean',
        ];
    }

    public function compras(): HasMany
    {
        return $this->hasMany(Compra::class, 'id_proveedor');
    }
}
