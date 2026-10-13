<?php

namespace Database\Seeders;

use App\Models\SalidaInventario;
use Illuminate\Database\Seeder;

class salida_inventarioSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        SalidaInventario::insert([
            [
                'id' => 1,
                'id_usuario' => 3,
                'fecha_salida' => '2026-01-25',
                'motivo' => 'Alimentación semanal de caniles generales',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'id_usuario' => 2,
                'fecha_salida' => '2026-02-12',
                'motivo' => 'Tratamiento de gatos en área de aislamiento clínico',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'id_usuario' => 3,
                'fecha_salida' => '2026-03-01',
                'motivo' => 'Limpieza y desinfección profunda de caniles',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
