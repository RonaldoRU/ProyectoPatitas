<?php

namespace Database\Seeders;

use App\Models\Compra;
use Illuminate\Database\Seeder;

class compraSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Compra::insert([
            [
                'id' => 1,
                'id_proveedor' => 1,
                'id_usuario' => 1,
                'fecha_compra' => '2026-01-05',
                'monto_total' => 1250.00,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'id_proveedor' => 3,
                'id_usuario' => 1,
                'fecha_compra' => '2026-02-02',
                'monto_total' => 840.00,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
