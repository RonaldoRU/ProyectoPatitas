<?php

namespace Database\Seeders;

use App\Models\ArticuloInventario;
use Illuminate\Database\Seeder;

class articulo_inventarioSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        ArticuloInventario::insert([
            [
                'id' => 1,
                'nombre' => 'Croquetas Adulto Dog Chow 15kg',
                'categoria' => 'Alimento',
                'unidad_medida' => 'Bolsa',
                'stock_actual' => 25.00,
                'stock_minimo_alerta' => 5.00,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'nombre' => 'Cat Chow Gatitos 8kg',
                'categoria' => 'Alimento',
                'unidad_medida' => 'Bolsa',
                'stock_actual' => 12.00,
                'stock_minimo_alerta' => 3.00,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'nombre' => 'Ivermectina 1% Inyectable 50ml',
                'categoria' => 'Medicamento',
                'unidad_medida' => 'Frasco',
                'stock_actual' => 8.00,
                'stock_minimo_alerta' => 2.00,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'nombre' => 'Lavandina Concentrada 5L',
                'categoria' => 'Limpieza',
                'unidad_medida' => 'Bidón',
                'stock_actual' => 15.00,
                'stock_minimo_alerta' => 4.00,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 5,
                'nombre' => 'Jeringas Descartables 3ml',
                'categoria' => 'Insumo Médico',
                'unidad_medida' => 'Unidad',
                'stock_actual' => 150.00,
                'stock_minimo_alerta' => 30.00,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
