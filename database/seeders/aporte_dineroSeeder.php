<?php

namespace Database\Seeders;

use App\Models\AporteDinero;
use Illuminate\Database\Seeder;

class aporte_dineroSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        AporteDinero::insert([
            [
                'id' => 1,
                'id_donacion' => 2,
                'monto' => 500.00,
                'fecha_recepcion' => '2026-01-20',
                'comprobante' => 'TRF-BNB-9281039',
                'observaciones' => 'Donación para fondo de alimento de emergencia',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'id_donacion' => 4,
                'monto' => 1500.00,
                'fecha_recepcion' => '2026-02-18',
                'comprobante' => 'TRF-BISA-819203',
                'observaciones' => 'Aporte destinado exclusivamente a esterilizaciones masivas',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
