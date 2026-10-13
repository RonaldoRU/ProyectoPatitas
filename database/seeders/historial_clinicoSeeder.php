<?php

namespace Database\Seeders;

use App\Models\HistorialClinico;
use Illuminate\Database\Seeder;

class historial_clinicoSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        HistorialClinico::insert([
            [
                'id' => 1,
                'fecha_atencion' => '2026-01-16',
                'diagnostico' => 'Desnutrición leve y parasitosis intestinal.',
                'observacion' => 'Se administra antiparasitario interno y suplemento vitamínico.',
                'tipo_procedimiento' => 'Evaluación Inicial',
                'id_mascota' => 1,
                'id_usuario' => 2,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'fecha_atencion' => '2026-02-11',
                'diagnostico' => 'Infección respiratoria felina (Pérdida de apetito).',
                'observacion' => 'Tratamiento con antibiótico por 7 días y nebulización.',
                'tipo_procedimiento' => 'Consulta Médica',
                'id_mascota' => 2,
                'id_usuario' => 2,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'fecha_atencion' => '2026-03-02',
                'diagnostico' => 'Paciente clínicamente sano, apto para procedimiento.',
                'observacion' => 'Cirugía realizada sin complicaciones. Postoperatorio en observación.',
                'tipo_procedimiento' => 'Cirugía de Esterilización',
                'id_mascota' => 3,
                'id_usuario' => 4,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'fecha_atencion' => '2026-03-05',
                'diagnostico' => 'Saludable.',
                'observacion' => 'Aplicación de vacuna trivalente felina y desparasitación.',
                'tipo_procedimiento' => 'Vacunación',
                'id_mascota' => 4,
                'id_usuario' => 2,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 5,
                'fecha_atencion' => '2026-03-06',
                'diagnostico' => 'Laceración superficial en pata delantera izquierda.',
                'observacion' => 'Limpieza de herida y aplicación de antiséptico en spray.',
                'tipo_procedimiento' => 'Curación',
                'id_mascota' => 5,
                'id_usuario' => 4,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
