<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = [
            [
                'id' => 1,
                'nombre' => 'Carlos Eduardo Mendoza',
                'ci' => '4512345 LP',
                'email' => 'carlos.mendoza@patitas.com',
                'rol' => 'Administrador',
                'telefono' => '71029384',
                'password' => Hash::make('123456'),
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'nombre' => 'Dra. Beatriz Morales Peña',
                'ci' => '4523456 SC',
                'email' => 'beatriz.morales@patitas.com',
                'rol' => 'Veterinario',
                'telefono' => '75019283',
                'password' => Hash::make('123456'),
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'nombre' => 'Lucía Fernández Claros',
                'ci' => '4534567 CB',
                'email' => 'lucia.fernandez@patitas.com',
                'rol' => 'Voluntario',
                'telefono' => '68910293',
                'password' => Hash::make('123456'),
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'nombre' => 'Dr. Mateo Vargas Ortiz',
                'ci' => '4545678 CH',
                'email' => 'mateo.vargas@patitas.com',
                'rol' => 'Veterinario',
                'telefono' => '72109384',
                'password' => Hash::make('123456'),
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 5,
                'nombre' => 'Camila Suárez Roca',
                'ci' => '4556789 OR',
                'email' => 'camila.suarez@patitas.com',
                'rol' => 'Recepcionista',
                'telefono' => '78901234',
                'password' => Hash::make('123456'),
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ];

        User::upsert($users, ['id']);
    }
}
