<?php

namespace Database\Seeders;

use App\Models\Donante;
use Illuminate\Database\Seeder;

class donanteSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Donante::insert([
            [
                'id' => 1,
                'nombre' => 'Empresa Avícola Sofía',
                'tipo_persona' => 'Jurídica',
                'telefono' => '70019283',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'nombre' => 'Fundación Bienestar Animal',
                'tipo_persona' => 'Jurídica',
                'telefono' => '33492019',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'nombre' => 'Roberto Pinto Saucedo',
                'tipo_persona' => 'Natural',
                'telefono' => '71390219',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'nombre' => 'Farmacia Chávez S.A.',
                'tipo_persona' => 'Jurídica',
                'telefono' => '800102030',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 5,
                'nombre' => 'Gabriela Arteaga',
                'tipo_persona' => 'Natural',
                'telefono' => '76019283',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
