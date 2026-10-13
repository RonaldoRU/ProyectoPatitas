<?php

namespace Database\Seeders;

use App\Models\DetalleSalida;
use Illuminate\Database\Seeder;

class detalle_salidaSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DetalleSalida::insert([
            [
                'id' => 1,
                'id_salida' => 1,
                'id_articulo' => 1,
                'cantidad' => 3.00,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'id_salida' => 2,
                'id_articulo' => 3,
                'cantidad' => 1.00,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'id_salida' => 2,
                'id_articulo' => 5,
                'cantidad' => 10.00,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'id_salida' => 3,
                'id_articulo' => 4,
                'cantidad' => 2.00,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
