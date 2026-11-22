<?php

namespace Database\Seeders;

use App\Models\Bitacora;
use App\Models\Proveedor;
use Illuminate\Database\Seeder;

class proveedorSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Proveedor::insert([
            [
                'id' => 1,
                'nombre_empresa' => 'Veterinaria & Distribuidora El Paisano',
                'nombre_contacto' => 'Lic. Gonzalo Vargas',
                'telefono' => '33529102',
                'direccion' => 'Av. Grigotá 4to Anillo',
                'identificacion' => 'NIT-1000001',
                'tipo_insumo_provisto' => 'Insumos Veterinarios y Alimento',
                'activo' => true,
                'estado' => 'Activo',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'nombre_empresa' => 'Comercializadora AgroCruceña',
                'nombre_contacto' => 'Ing. Mario Mercado',
                'telefono' => '33410293',
                'direccion' => 'Parque Industrial PI-34',
                'identificacion' => 'NIT-1000002',
                'tipo_insumo_provisto' => 'Insumos Veterinarios y Alimento',
                'activo' => true,
                'estado' => 'Activo',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'nombre_empresa' => 'Importadora Médica Santa Cruz',
                'nombre_contacto' => 'Sra. Elena Claros',
                'telefono' => '33682910',
                'direccion' => 'Calle España #240',
                'identificacion' => 'NIT-1000003',
                'tipo_insumo_provisto' => 'Insumos Veterinarios y Alimento',
                'activo' => true,
                'estado' => 'Activo',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        Bitacora::query()->create([
            'id_usuario' => 6,
            'usuario_nombre' => 'Juan Ronaldo Rojas Ugarte',
            'tipo_accion' => 'Ampliar tabla proveedors con nuevo atributo estado',
            'modulo' => 'inventario',
            'descripcion' => 'Se aumentó el nuevo atributo "estado" (VARCHAR(50) DEFAULT \'Activo\') en la tabla proveedors y se actualizaron los proveedores con su estado operativo.',
            'entidad_tipo' => 'Proveedor',
            'entidad_id' => 'proveedors',
            'ip' => '127.0.0.1',
            'http_method' => 'ALTER',
            'ruta' => 'database/proveedors',
            'resultado' => 'exitosa',
            'contexto' => [
                'tabla_modificada' => 'public.proveedors',
                'nuevo_atributo_agregado' => 'estado',
                'definicion_sql' => "VARCHAR(50) NOT NULL DEFAULT 'Activo'",
                'valores_permitidos' => ['Activo', 'Inactivo', 'Suspendido', 'En revisión'],
                'proveedores_actualizados' => 50,
            ],
        ]);
    }
}
