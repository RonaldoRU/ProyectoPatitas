<?php

use App\Models\Mascota;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

test('permite realizar donacion publica unica y crea usuario donante con recibo digital', function () {
    $email = 'donante.test.'.uniqid().'@refugio.bo';

    $response = $this->postJson('/api/donaciones/publica', [
        'tipo_frecuencia' => 'unica',
        'monto' => 50,
        'nombre' => 'Carlos Alberto Donante',
        'email' => $email,
        'telefono' => '71234567',
        'password' => 'secret123',
        'password_confirmation' => 'secret123',
        'tipo_rol' => 'Donante',
        'terminos' => true,
    ]);

    $response->assertStatus(201)
        ->assertJsonStructure([
            'mensaje',
            'token',
            'usuario' => ['id', 'nombre', 'email', 'rol'],
            'recibo' => [
                'numero_recibo',
                'transaccion_referencia',
                'fecha_emision',
                'frecuencia',
                'monto',
                'moneda',
                'sello_digital',
            ],
        ]);

    $this->assertDatabaseHas('users', [
        'email' => $email,
        'rol' => 'Donante',
    ]);

    $this->assertDatabaseHas('donantes', [
        'nombre' => 'Carlos Alberto Donante',
    ]);

    $this->assertDatabaseHas('aporte_dineros', [
        'monto' => 50,
    ]);
});

test('permite registrar donacion mensual asignando rol postulante', function () {
    $email = 'postulante.test.'.uniqid().'@refugio.bo';

    $response = $this->postJson('/api/donaciones/publica', [
        'tipo_frecuencia' => 'mensual',
        'monto' => 100,
        'nombre' => 'Mariana Postulante Adoptante',
        'email' => $email,
        'telefono' => '78901234',
        'password' => 'claveSegura2026',
        'password_confirmation' => 'claveSegura2026',
        'tipo_rol' => 'Postulante',
        'terminos' => true,
    ]);

    $response->assertStatus(201)
        ->assertJson([
            'usuario' => [
                'rol' => 'Postulante',
            ],
            'recibo' => [
                'frecuencia' => 'Mensual (Recurrente)',
                'monto' => 100,
                'moneda' => 'Bs',
            ],
        ]);

    $this->assertDatabaseHas('users', [
        'email' => $email,
        'rol' => 'Postulante',
    ]);
});

test('donante o postulante no pueden crear ni editar mascotas (solo lectura)', function () {
    $donanteUser = User::query()->create([
        'ci' => (string) random_int(1000000, 9999999),
        'nombre' => 'Donante Solo Lectura',
        'email' => 'donante.readonly.'.uniqid().'@refugio.bo',
        'telefono' => '71122334',
        'password' => Hash::make('password123'),
        'rol' => 'Donante',
        'estado' => true,
    ]);

    $mascota = Mascota::query()->create([
        'nombre' => 'Bobby Prueba',
        'especie' => 'Canino',
        'raza' => 'Mestizo',
        'edad' => '2 años',
        'sexo' => 'Macho',
        'zona_rescate' => 'Zona Central',
        'fecha_ingreso' => '2026-05-10',
        'foto' => '/images/default.jpg',
        'estado_actual' => 'Disponible',
    ]);

    // Intentar crear mascota debe retornar 403 Prohibido
    $responseCreate = $this->actingAs($donanteUser, 'sanctum')->postJson('/api/mascotas', [
        'nombre' => 'Intento No Autorizado',
        'especie' => 'Canino',
        'raza' => 'Criollo',
        'edad' => '1 año',
        'sexo' => 'Macho',
        'zona_rescate' => 'Calle',
        'fecha_ingreso' => '2026-11-16',
    ]);
    $responseCreate->assertStatus(403);

    // Intentar actualizar mascota debe retornar 403 Prohibido
    $responseUpdate = $this->actingAs($donanteUser, 'sanctum')->putJson("/api/mascotas/{$mascota->id}", [
        'nombre' => 'Nombre Modificado Hack',
    ]);
    $responseUpdate->assertStatus(403);

    // Pero sí puede consultar la lista de mascotas disponibles
    $responseGet = $this->actingAs($donanteUser, 'sanctum')->getJson('/api/mascotas?estado=Disponible');
    $responseGet->assertStatus(200);

    // Y el catálogo público
    $responsePublic = $this->getJson('/api/mascotas-disponibles');
    $responsePublic->assertStatus(200);
});
