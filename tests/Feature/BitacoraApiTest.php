<?php

use App\Models\Bitacora;
use App\Models\User;

function createBitacoraApiUser(string $email, string $role = 'Administrador'): User
{
    $user = new User([
        'nombre' => 'Ana Auditora',
        'email' => $email,
        'rol' => $role,
        'password' => 'refugio-password',
    ]);
    $user->forceFill(['telefono' => '70000000'])->save();

    return $user;
}

test('a successful authenticated operation is automatically registered in the audit log', function () {
    $administrator = createBitacoraApiUser('admin-audit-create@example.org');
    $token = $administrator->createToken('audit-create-test')->plainTextToken;

    $this->withToken($token)
        ->postJson('/api/usuarios', [
            'nombre' => 'Rosa Personal',
            'ci' => '6612345 SC',
            'email' => 'rosa-audit@example.org',
            'telefono' => '70000001',
            'rol' => 'Voluntario',
            'password' => 'ClaveSegura!123',
        ])
        ->assertCreated();

    $this->assertDatabaseHas('bitacoras', [
        'tipo_accion' => 'Registrar usuario',
        'id_usuario' => $administrator->id,
        'usuario_nombre' => 'Ana Auditora',
        'modulo' => 'usuarios',
        'resultado' => 'exitosa',
    ]);

    $entry = Bitacora::query()->with('usuario')->firstOrFail();
    expect($entry->usuario?->nombre)->toBe('Ana Auditora');
    expect($entry->descripcion)->toBe('Registrar usuario');
    expect($entry->contexto['campos_registrados'])->toContain('email')
        ->and($entry->contexto['campos_registrados'])->not->toContain('password');
});

test('unsuccessful operations and audit reads do not create audit entries', function () {
    $administrator = createBitacoraApiUser('admin-audit-failure@example.org');
    $token = $administrator->createToken('audit-failure-test')->plainTextToken;

    $this->withToken($token)
        ->postJson('/api/usuarios', [])
        ->assertStatus(422);

    $this->withToken($token)
        ->getJson('/api/bitacora')
        ->assertOk()
        ->assertJsonCount(0, 'bitacoras.data');

    $this->assertDatabaseCount('bitacoras', 0);
});

test('successful login is recorded in the audit log', function () {
    $user = createBitacoraApiUser('audit-login@example.org');

    $this->postJson('/api/login', [
        'usuario' => $user->email,
        'password' => 'refugio-password',
    ])
        ->assertOk();

    $this->assertDatabaseHas('bitacoras', [
        'tipo_accion' => 'Iniciar sesión',
        'id_usuario' => $user->id,
    ]);
});

test('failed login is recorded without storing credentials', function () {
    $this->postJson('/api/login', [
        'usuario' => 'unknown-audit@example.org',
        'password' => 'secret-that-must-not-be-logged',
    ])->assertUnauthorized();

    $entry = Bitacora::query()->firstOrFail();

    expect($entry->tipo_accion)->toBe('Intento de inicio de sesión rechazado')
        ->and($entry->resultado)->toBe('fallida')
        ->and($entry->descripcion)->not->toContain('unknown-audit@example.org')
        ->and($entry->descripcion)->not->toContain('secret-that-must-not-be-logged');
});

test('an administrator can filter audit entries by user action and date range', function () {
    $administrator = createBitacoraApiUser('admin-audit-filter@example.org');
    $otherUser = createBitacoraApiUser('other-audit-filter@example.org', 'Veterinario');
    $otherUser->forceFill(['nombre' => 'Luis Personal'])->save();
    $token = $administrator->createToken('audit-filter-test')->plainTextToken;

    Bitacora::query()->forceCreate([
        'tipo_accion' => 'Registrar usuario',
        'id_usuario' => $administrator->id,
        'usuario_nombre' => 'Ana Auditora',
        'modulo' => 'usuarios',
        'resultado' => 'exitosa',
        'descripcion' => 'Usuario registrado.',
        'created_at' => '2026-10-09 10:15:00',
    ]);
    Bitacora::query()->forceCreate([
        'tipo_accion' => 'Modificar postulante',
        'id_usuario' => $administrator->id,
        'usuario_nombre' => 'Ana Auditora',
        'modulo' => 'postulantes',
        'resultado' => 'exitosa',
        'descripcion' => 'Postulante actualizado.',
        'created_at' => '2026-10-09 11:30:00',
    ]);
    Bitacora::query()->forceCreate([
        'tipo_accion' => 'Registrar usuario',
        'id_usuario' => $otherUser->id,
        'usuario_nombre' => 'Luis Personal',
        'modulo' => 'usuarios',
        'resultado' => 'exitosa',
        'descripcion' => 'Usuario registrado.',
        'created_at' => '2026-10-09 12:00:00',
    ]);

    $this->withToken($token)
        ->getJson('/api/bitacora?usuario=Ana&accion=Registrar%20usuario&modulo=usuarios&buscar=registrado&desde=2026-10-09&hasta=2026-10-09')
        ->assertOk()
        ->assertJsonCount(1, 'bitacoras.data')
        ->assertJsonPath('bitacoras.data.0.tipo_accion', 'Registrar usuario')
        ->assertJsonPath('bitacoras.data.0.usuario', 'Ana Auditora')
        ->assertJsonPath('bitacoras.data.0.modulo', 'usuarios')
        ->assertJsonPath('bitacoras.data.0.resultado', 'exitosa')
        ->assertJsonPath('bitacoras.per_page', 25);
});

test('deleting a user preserves the audit entry and its historical name', function () {
    $administrator = createBitacoraApiUser('admin-audit-retain@example.org');
    $entry = Bitacora::query()->create([
        'tipo_accion' => 'Registrar usuario',
        'id_usuario' => $administrator->id,
        'usuario_nombre' => $administrator->nombre,
        'modulo' => 'usuarios',
        'descripcion' => 'Usuario registrado.',
        'resultado' => 'exitosa',
    ]);

    $administrator->delete();

    $this->assertDatabaseHas('bitacoras', [
        'id' => $entry->id,
        'id_usuario' => null,
        'usuario_nombre' => 'Ana Auditora',
    ]);
});

test('audit consultation requires an authenticated administrator', function () {
    $this->getJson('/api/bitacora')->assertUnauthorized();

    $staff = createBitacoraApiUser('staff-audit@example.org', 'Veterinario');

    $this->withToken($staff->createToken('staff-audit-test')->plainTextToken)
        ->getJson('/api/bitacora')
        ->assertForbidden();
});

test('audit date filters reject an end date before the start date', function () {
    $administrator = createBitacoraApiUser('admin-audit-date@example.org');

    $this->withToken($administrator->createToken('audit-date-test')->plainTextToken)
        ->getJson('/api/bitacora?desde=2026-10-10&hasta=2026-10-09')
        ->assertStatus(422)
        ->assertJsonValidationErrors('hasta');
});
