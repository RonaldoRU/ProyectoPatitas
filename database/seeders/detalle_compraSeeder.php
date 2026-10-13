<?php

namespace Database\Seeders;

use App\Models\DetalleCompra;
use Illuminate\Database\Seeder;

class detalle_compraSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DetalleCompra::insert([
            [
                'id' => 1,
                'id_compra' => 1,
                'id_articulo' => 1,
                'cantidad' => 10.00,
                'costo_unitario' => 125.00,
                'fecha_vencimiento' => '2027-05-20',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'id_compra' => 2,
                'id_articulo' => 3,
                'cantidad' => 4.00,
                'costo_unitario' => 85.00,
                'fecha_vencimiento' => '2028-01-15',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'id_compra' => 2,
                'id_articulo' => 5,
                'cantidad' => 100.00,
                'costo_unitario' => 5.00,
                'fecha_vencimiento' => '2028-10-10',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
