<?php

namespace Database\Seeders;

use App\Models\TipoAporte;
use Illuminate\Database\Seeder;

class tipo_aporteSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        TipoAporte::insert([
            [
                'id' => 1,
                'nombre' => 'Efectivo / Transferencia',
                'descripcion' => 'Aportes monetarios directos a la cuenta bancaria del refugio',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'nombre' => 'Alimento Seco',
                'descripcion' => 'Croquetas para perros y gatos de distintas edades',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'nombre' => 'Insumos Médicos',
                'descripcion' => 'Medicamentos, vacunas, jeringas y gasas',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'nombre' => 'Artículos de Limpieza',
                'descripcion' => 'Detergentes, desinfectantes y escobas',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 5,
                'nombre' => 'Mobiliario / Accesorios',
                'descripcion' => 'Camas, correas, platos y jaulas de transporte',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
