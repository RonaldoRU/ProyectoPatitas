<?php

use App\Models\User;
use Illuminate\Support\Facades\DB;

test('dashboard returns current shelter metrics for an authenticated user', function () {
    $user = new User([
        'nombre' => 'Rosa Méndez',
        'email' => 'rosa@example.org',
        'rol' => 'Administrador',
        'password' => 'refugio-password',
    ]);
    $user->forceFill(['telefono' => '70000000'])->save();

    $availablePetId = DB::table('mascotas')->insertGetId([
        'nombre' => 'Luna',
        'raza' => 'Mestiza',
        'edad' => '2 años',
        'especie' => 'Perro',
        'estado_actual' => 'Disponible',
        'fecha_ingreso' => now()->subDay()->toDateString(),
        'sexo' => 'Hembra',
        'zona_rescate' => 'Centro',
        'foto' => '',
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    $adoptedPetId = DB::table('mascotas')->insertGetId([
        'nombre' => 'Toby',
        'raza' => 'Mestizo',
        'edad' => '1 año',
        'especie' => 'Perro',
        'estado_actual' => 'Adoptado',
        'fecha_ingreso' => now()->subDays(2)->toDateString(),
        'sexo' => 'Macho',
        'zona_rescate' => 'Norte',
        'foto' => '',
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    $interestedId = DB::table('interesado_adopcions')->insertGetId([
        'ci' => '123456789',
        'nombre' => 'Ana Pérez',
        'direccion' => 'Centro',
        'telefono' => '70000001',
        'situacion_casa' => 'Casa',
        'referencias' => 'Ninguna',
        'puntaje_evaluacion' => '10',
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    DB::table('adopcions')->insert([
        'fecha_adopcion' => now()->toDateString(),
        'id_interesado' => $interestedId,
        'id_mascota' => $adoptedPetId,
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    DB::table('articulo_inventarios')->insert([
        [
            'nombre' => 'Alimento',
            'categoria' => 'Alimento',
            'unidad_medida' => 'Bolsa',
            'stock_actual' => 2,
            'stock_minimo_alerta' => 5,
            'created_at' => now(),
            'updated_at' => now(),
        ],
        [
            'nombre' => 'Medicamento',
            'categoria' => 'Medicamento',
            'unidad_medida' => 'Frasco',
            'stock_actual' => 8,
            'stock_minimo_alerta' => 3,
            'created_at' => now(),
            'updated_at' => now(),
        ],
    ]);

    $response = $this->withToken($user->createToken('dashboard-test')->plainTextToken)
        ->getJson('/api/dashboard');

    $response->assertOk()
        ->assertJsonPath('stats.animales_refugio', 1)
        ->assertJsonPath('stats.listos_adopcion', 1)
        ->assertJsonPath('stats.adopciones_mes', 1)
        ->assertJsonPath('stats.alertas_stock', 1)
        ->assertJsonPath('ultimos_ingresos.0.nombre', 'Luna')
        ->assertJsonPath('user.nombre', 'Rosa Méndez')
        ->assertJsonPath('user.rol', 'Administrador');
});

test('dashboard rejects requests without a Sanctum token', function () {
    $this->getJson('/api/dashboard')->assertUnauthorized();
});
