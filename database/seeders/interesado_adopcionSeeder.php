<?php

namespace Database\Seeders;

use App\Models\InteresadoAdopcion;
use Illuminate\Database\Seeder;

class interesado_adopcionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        InteresadoAdopcion::insert([
            [
                'id' => 1,
                'ci' => '4920193',
                'nombre' => 'Mariana Paz Soldán',
                'direccion' => 'Av. San Martín #450, Barrio Equipetrol',
                'telefono' => '77391029',
                'situacion_casa' => 'Casa propia con patio amplio completamente cerrado.',
                'referencias' => 'Dra. Claudia Ríos (Veterinaria Particular) - 71000000',
                'puntaje_evaluacion' => '95',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'ci' => '8192039',
                'nombre' => 'Jorge Justiniano Rivero',
                'direccion' => 'Calle Arenales #123, Centro',
                'telefono' => '71629384',
                'situacion_casa' => 'Departamento propio en 3er piso (Permite mascotas pequeñas).',
                'referencias' => 'Ing. Roberto Justiniano (Hermano) - 72000000',
                'puntaje_evaluacion' => '88',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'ci' => '3920192',
                'nombre' => 'Valeria Aguilera Banegas',
                'direccion' => 'Barrio Sirari, Calle 3 #12',
                'telefono' => '69012938',
                'situacion_casa' => 'Casa familiar con jardín interno.',
                'referencias' => 'Lic. Sofía Aguilera (Madre) - 73000000',
                'puntaje_evaluacion' => '90',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'ci' => '9201938',
                'nombre' => 'Fernando Roca Pinto',
                'direccion' => 'Av. Busch y 3er Anillo',
                'telefono' => '72819203',
                'situacion_casa' => 'Alquiler con autorización firmada por el propietario.',
                'referencias' => 'Carlos Roca (Padre) - 74000000',
                'puntaje_evaluacion' => '75',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 5,
                'ci' => '5829103',
                'nombre' => 'Andrea Melgar Justiniano',
                'direccion' => 'Urb. Las Palmas, Calle 5',
                'telefono' => '75591823',
                'situacion_casa' => 'Quinta con muro perimetral alto y áreas verdes.',
                'referencias' => 'Dra. María Melgar - 75000000',
                'puntaje_evaluacion' => '98',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
