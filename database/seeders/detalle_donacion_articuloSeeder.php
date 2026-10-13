<?php

namespace Database\Seeders;

use App\Models\DetalleDonacionInsumo;
use Illuminate\Database\Seeder;

class detalle_donacion_articuloSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DetalleDonacionInsumo::insert([
            [
                'id' => 1,
                'id_donacion' => 1,
                'id_articulo' => 1,
                'cantidad' => 20.00,
                'fecha_vencimiento' => '2027-06-30',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'id_donacion' => 3,
                'id_articulo' => 3,
                'cantidad' => 5.00,
                'fecha_vencimiento' => '2027-12-31',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'id_donacion' => 3,
                'id_articulo' => 5,
                'cantidad' => 100.00,
                'fecha_vencimiento' => '2028-05-15',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
