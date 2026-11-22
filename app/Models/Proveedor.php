<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Modelo Proveedor: Empresas y distribuidores externos que suministran insumos médicos, alimentos o accesorios.
 * Controla datos de contacto, identificación fiscal/NIT, rubro de insumos provistos y estado activo.
 */
class Proveedor extends Model
{
    /**
     * Atributos asignables en masa.
     */
    protected $fillable = [
        'nombre_empresa',
        'nombre_contacto',
        'telefono',
        'direccion',
        'identificacion',
        'tipo_insumo_provisto',
        'activo',
        'estado',
    ];

    /**
     * Sincroniza automáticamente los atributos `activo` y `estado` al guardar el proveedor.
     */
    protected static function booted(): void
    {
        static::saving(function (self $proveedor): void {
            if ($proveedor->isDirty('estado') && ! $proveedor->isDirty('activo')) {
                $proveedor->activo = $proveedor->estado === 'Activo';
            } elseif ($proveedor->isDirty('activo') && ! $proveedor->isDirty('estado')) {
                $proveedor->estado = $proveedor->activo ? 'Activo' : 'Inactivo';
            } elseif ($proveedor->estado === null || $proveedor->estado === '') {
                $proveedor->estado = ($proveedor->activo ?? true) ? 'Activo' : 'Inactivo';
            }
        });
    }

    /**
     * Conversión de tipos.
     */
    protected function casts(): array
    {
        return [
            'activo' => 'boolean',
        ];
    }

    /**
     * Relación: Compras realizadas a este proveedor.
     */
    public function compras(): HasMany
    {
        return $this->hasMany(Compra::class, 'id_proveedor');
    }
}
