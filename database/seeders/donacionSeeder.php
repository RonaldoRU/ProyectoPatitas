<?php

namespace Database\Seeders;

use App\Models\Donacion;
use Illuminate\Database\Seeder;

class donacionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Donacion::insert([
            [
                'id' => 1,
                'id_donante' => 1,
                'id_usuario' => 1,
                'tipo_aporte' => 'Alimento Seco', // id_tipo_aporte original: 2
                'fecha' => '2026-01-10',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'id_donante' => 3,
                'id_usuario' => 5,
                'tipo_aporte' => 'Efectivo / Transferencia', // id_tipo_aporte original: 1
                'fecha' => '2026-01-20',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'id_donante' => 4,
                'id_usuario' => 2,
                'tipo_aporte' => 'Insumos Médicos', // id_tipo_aporte original: 3
                'fecha' => '2026-02-05',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'id_donante' => 2,
                'id_usuario' => 1,
                'tipo_aporte' => 'Efectivo / Transferencia', // id_tipo_aporte original: 1
                'fecha' => '2026-02-18',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 5,
                'id_donante' => 5,
                'id_usuario' => 5,
                'tipo_aporte' => 'Mobiliario / Accesorios', // id_tipo_aporte original: 5
                'fecha' => '2026-03-05',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
