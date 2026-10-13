<?php

namespace Database\Seeders;

use App\Models\Bitacora;
use Carbon\Carbon;
use Illuminate\Database\Seeder;

class bitacoraSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $registros = [
            ['id_usuario' => 1, 'fecha' => '2026-03-01', 'hora' => '08:30:00', 'tipo_accion' => 'Inicio de sesión en el sistema'],
            ['id_usuario' => 2, 'fecha' => '2026-03-01', 'hora' => '09:15:00', 'tipo_accion' => 'Registro de consulta clínica - Mascota ID 1'],
            ['id_usuario' => 5, 'fecha' => '2026-03-02', 'hora' => '10:00:00', 'tipo_accion' => 'Registro de nuevo interesado en adopción'],
            ['id_usuario' => 1, 'fecha' => '2026-03-02', 'hora' => '11:30:00', 'tipo_accion' => 'Aprobación de solicitud de adopción ID 1'],
            ['id_usuario' => 3, 'fecha' => '2026-03-03', 'hora' => '14:20:00', 'tipo_accion' => 'Registro de salida de alimentos de inventario'],
        ];

        foreach ($registros as $registro) {
            $fechaHora = Carbon::parse("{$registro['fecha']} {$registro['hora']}");

            Bitacora::create([
                'id_usuario' => $registro['id_usuario'],
                'tipo_accion' => $registro['tipo_accion'],
                'created_at' => $fechaHora,
                'updated_at' => $fechaHora,
            ]);
        }
    }
}
