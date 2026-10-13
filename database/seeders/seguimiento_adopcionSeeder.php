<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\SeguimientoAdopcion;

class seguimiento_adopcionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        SeguimientoAdopcion::insert([
            [
                'id' => 1,
                'id_adopcion' => 1,
                'id_usuario' => 3,
                'estado_seguimiento' => 'Concluido Satisfactorio',
                'fecha_programada' => '2026-02-15',
                'fecha_realizada' => '2026-02-15',
                'reporte_bienestar' => 'La mascota se adaptó perfectamente. Come bien y comparte con la familia.',
                'fotografia' => 'https://refugio.org/evidencias/seg_firulais_1.jpg',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'id_adopcion' => 1,
                'id_usuario' => 3,
                'estado_seguimiento' => 'Pendiente',
                'fecha_programada' => '2026-03-15',
                'fecha_realizada' => null,
                'reporte_bienestar' => '',
                'fotografia' => '',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'id_adopcion' => 2,
                'id_usuario' => 3,
                'estado_seguimiento' => 'Pendiente',
                'fecha_programada' => '2026-03-22',
                'fecha_realizada' => null,
                'reporte_bienestar' => '',
                'fotografia' => '',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
