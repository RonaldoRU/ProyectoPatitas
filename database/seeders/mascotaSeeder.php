<?php

namespace Database\Seeders;

use App\Models\Mascota;
use Illuminate\Database\Seeder;

class mascotaSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Mascota::insert([
            [
                'id' => 1,
                'nombre' => 'Firulais',
                'raza' => 'Mestizo',
                'edad' => '2 años',
                'especie' => 'Perro',
                'estado_actual' => 'Adoptado',
                'fecha_ingreso' => '2026-01-15',
                'sexo' => 'Macho',
                'zona_rescate' => 'Plan 3000, Av. Paurito',
                'foto' => 'https://refugio.org/fotos/firulais.jpg',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'nombre' => 'Luna',
                'raza' => 'Siamesa',
                'edad' => '1 año',
                'especie' => 'Gato',
                'estado_actual' => 'En Tratamiento',
                'fecha_ingreso' => '2026-02-10',
                'sexo' => 'Hembra',
                'zona_rescate' => 'Mercado Abasto Antiguo',
                'foto' => 'https://refugio.org/fotos/luna.jpg',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'nombre' => 'Thor',
                'raza' => 'Pitbull Mestizo',
                'edad' => '3 años',
                'especie' => 'Perro',
                'estado_actual' => 'Disponible',
                'fecha_ingreso' => '2026-03-01',
                'sexo' => 'Macho',
                'zona_rescate' => 'Villa 1ro de Mayo, Plaza Principal',
                'foto' => 'https://refugio.org/fotos/thor.jpg',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'nombre' => 'Mimi',
                'raza' => 'Común Europeo',
                'edad' => '5 meses',
                'especie' => 'Gato',
                'estado_actual' => 'Adoptado',
                'fecha_ingreso' => '2026-03-04',
                'sexo' => 'Hembra',
                'zona_rescate' => 'Av. Banzer Km 8',
                'foto' => 'https://refugio.org/fotos/mimi.jpg',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 5,
                'nombre' => 'Rocky',
                'raza' => 'Criollo',
                'edad' => '4 años',
                'especie' => 'Perro',
                'estado_actual' => 'Disponible',
                'fecha_ingreso' => '2026-03-06',
                'sexo' => 'Macho',
                'zona_rescate' => 'Equipetrol, Calle 9',
                'foto' => 'https://refugio.org/fotos/rocky.jpg',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
        //
    }
}
