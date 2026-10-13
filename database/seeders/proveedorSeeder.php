<?php

namespace Database\Seeders;

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
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'nombre_empresa' => 'Comercializadora AgroCruceña',
                'nombre_contacto' => 'Ing. Mario Mercado',
                'telefono' => '33410293',
                'direccion' => 'Parque Industrial PI-34',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'nombre_empresa' => 'Importadora Médica Santa Cruz',
                'nombre_contacto' => 'Sra. Elena Claros',
                'telefono' => '33682910',
                'direccion' => 'Calle España #240',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
