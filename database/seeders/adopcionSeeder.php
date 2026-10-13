<?php

namespace Database\Seeders;

use App\Models\Adopcion;
use Illuminate\Database\Seeder;

class adopcionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Adopcion::insert([
            [
                'id' => 1,
                'fecha_adopcion' => '2026-02-01',
                'id_interesado' => 1,
                'id_mascota' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'fecha_adopcion' => '2026-03-07',
                'id_interesado' => 3,
                'id_mascota' => 4,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
