<?php

use App\Models\InteresadoAdopcion;
use App\Models\Mascota;
use App\Models\User;

function createPostulanteApiAdministrator(string $email = 'admin-postulantes@example.org'): User
{
    $user = new User([
        'nombre' => 'Administradora',
        'email' => $email,
        'rol' => 'Administrador',
        'password' => 'refugio-password',
    ]);
    $user->forceFill(['telefono' => '70000000'])->save();

    return $user;
}

function postulantePayload(array $overrides = []): array
{
    return array_merge([
        'ci' => '123456789',
        'nombre' => 'Ana Pérez',
        'direccion' => 'Barrio Centro',
        'telefono' => '70000001',
        'situacion_casa' => 'Casa con patio cerrado',
        'referencias' => 'Referencia veterinaria',
        'puntaje_evaluacion' => 85,
        'estado' => 'En evaluación',
    ], $overrides);
}

function createPostulanteApiMascota(array $overrides = []): Mascota
{
    return Mascota::query()->create(array_merge([
        'nombre' => 'Luna',
        'raza' => 'Mestiza',
        'edad' => '2 años',
        'especie' => 'Perro',
        'estado_actual' => 'Disponible',
        'fecha_ingreso' => now()->toDateString(),
        'sexo' => 'Hembra',
        'zona_rescate' => 'Centro',
        'foto' => '',
    ], $overrides));
}

test('an administrator can list and register adoption applicants', function () {
    $administrator = createPostulanteApiAdministrator();
    $token = $administrator->createToken('applicants-test')->plainTextToken;
    createPostulanteApiMascota();

    $this->withToken($token)
        ->postJson('/api/postulantes', postulantePayload())
        ->assertCreated()
        ->assertJsonPath('postulante.nombre', 'Ana Pérez')
        ->assertJsonPath('postulante.estado', 'En evaluación');

    $this->withToken($token)
        ->getJson('/api/postulantes')
        ->assertOk()
        ->assertJsonCount(1, 'postulantes')
        ->assertJsonPath('mascotas_disponibles.0.nombre', 'Luna');

    $this->assertDatabaseHas('interesado_adopcions', [
        'ci' => '123456789',
        'nombre' => 'Ana Pérez',
        'puntaje_evaluacion' => '85',
        'estado' => 'En evaluación',
    ]);
});

test('applicant endpoints require an authenticated administrator', function () {
    $this->getJson('/api/postulantes')->assertUnauthorized();

    $staff = new User([
        'nombre' => 'Personal',
        'email' => 'staff-postulantes@example.org',
        'rol' => 'Veterinario',
        'password' => 'refugio-password',
    ]);
    $staff->forceFill(['telefono' => '70000002'])->save();

    $this->withToken($staff->createToken('staff-test')->plainTextToken)
        ->getJson('/api/postulantes')
        ->assertForbidden();
});

test('applicant registration validates required data score and unique identity', function () {
    $administrator = createPostulanteApiAdministrator('admin-validation-postulantes@example.org');
    $token = $administrator->createToken('validation-test')->plainTextToken;

    $this->withToken($token)
        ->postJson('/api/postulantes', [])
        ->assertStatus(422)
        ->assertJsonValidationErrors([
            'ci',
            'nombre',
            'direccion',
            'telefono',
            'situacion_casa',
            'referencias',
            'puntaje_evaluacion',
            'estado',
        ]);

    $this->withToken($token)
        ->postJson('/api/postulantes', postulantePayload(['puntaje_evaluacion' => 101]))
        ->assertStatus(422)
        ->assertJsonValidationErrors(['puntaje_evaluacion']);

    InteresadoAdopcion::query()->create(postulantePayload());

    $this->withToken($token)
        ->postJson('/api/postulantes', postulantePayload(['nombre' => 'Otra persona']))
        ->assertStatus(422)
        ->assertJsonValidationErrors(['ci']);
});

test('an administrator can update an applicant evaluation', function () {
    $administrator = createPostulanteApiAdministrator('admin-update-postulantes@example.org');
    $token = $administrator->createToken('update-test')->plainTextToken;
    $postulante = InteresadoAdopcion::query()->create(postulantePayload());

    $this->withToken($token)
        ->patchJson("/api/postulantes/{$postulante->id}", postulantePayload([
            'ci' => '123456789',
            'puntaje_evaluacion' => 92,
            'estado' => 'Aprobado',
        ]))
        ->assertOk()
        ->assertJsonPath('postulante.estado', 'Aprobado')
        ->assertJsonPath('postulante.puntaje_evaluacion', 92);

    $this->assertDatabaseHas('interesado_adopcions', [
        'id' => $postulante->id,
        'puntaje_evaluacion' => '92',
        'estado' => 'Aprobado',
    ]);
});

test('only approved applicants can adopt an available pet', function () {
    $administrator = createPostulanteApiAdministrator('admin-adoption-postulantes@example.org');
    $token = $administrator->createToken('adoption-test')->plainTextToken;
    $postulante = InteresadoAdopcion::query()->create(postulantePayload());
    $mascota = createPostulanteApiMascota();

    $this->withToken($token)
        ->postJson("/api/postulantes/{$postulante->id}/adopciones", [
            'id_mascota' => $mascota->id,
            'fecha_adopcion' => '2026-10-08',
        ])
        ->assertStatus(422)
        ->assertJsonValidationErrors(['postulante']);

    $postulante->update(['estado' => 'Aprobado']);

    $this->withToken($token)
        ->postJson("/api/postulantes/{$postulante->id}/adopciones", [
            'id_mascota' => $mascota->id,
            'fecha_adopcion' => '2026-10-08',
        ])
        ->assertCreated()
        ->assertJsonPath('adopcion.mascota.nombre', 'Luna');

    $this->assertDatabaseHas('adopcions', [
        'id_interesado' => $postulante->id,
        'id_mascota' => $mascota->id,
        'fecha_adopcion' => '2026-10-08',
    ]);
    $this->assertDatabaseHas('mascotas', [
        'id' => $mascota->id,
        'estado_actual' => 'Adoptado',
    ]);

    $anotherApplicant = InteresadoAdopcion::query()->create(postulantePayload([
        'ci' => '987654321',
        'estado' => 'Aprobado',
    ]));

    $this->withToken($token)
        ->postJson("/api/postulantes/{$anotherApplicant->id}/adopciones", [
            'id_mascota' => $mascota->id,
            'fecha_adopcion' => '2026-10-08',
        ])
        ->assertStatus(422)
        ->assertJsonValidationErrors(['id_mascota']);

    $this->assertDatabaseCount('adopcions', 1);
});
