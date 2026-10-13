<?php

use App\Models\Bitacora;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

function createUsuarioApiUser(string $email, string $role): User
{
    $user = new User([
        'nombre' => 'Rosa Méndez',
        'email' => $email,
        'rol' => $role,
        'password' => 'refugio-password',
    ]);
    $user->forceFill(['telefono' => '70000000'])->save();

    return $user;
}

test('an administrator can list and create users', function () {
    $administrator = createUsuarioApiUser('admin@example.org', 'Administrador');
    $token = $administrator->createToken('users-test')->plainTextToken;

    $this->withToken($token)
        ->getJson('/api/usuarios')
        ->assertOk()
        ->assertJsonCount(1, 'usuarios')
        ->assertJsonPath('usuarios.0.activo', true)
        ->assertJsonMissingPath('usuarios.0.password');

    $response = $this->withToken($token)->postJson('/api/usuarios', [
        'nombre' => 'Ana Torres',
        'ci' => '4521678 SC',
        'email' => 'ana@example.org',
        'telefono' => '+59170012345',
        'rol' => 'Recepcionista',
        'password' => 'ClaveSegura!123',
    ]);

    $response->assertCreated()
        ->assertJsonPath('usuario.nombre', 'Ana Torres')
        ->assertJsonPath('usuario.ci', '4521678 SC')
        ->assertJsonMissingPath('usuario.password');

    $this->assertDatabaseHas('users', [
        'nombre' => 'Ana Torres',
        'ci' => '4521678 SC',
        'email' => 'ana@example.org',
        'rol' => 'Recepcionista',
        'telefono' => '+59170012345',
        'activo' => true,
    ]);

    expect(Hash::check('ClaveSegura!123', User::query()->where('email', 'ana@example.org')->firstOrFail()->password))
        ->toBeTrue();
});

test('user list exposes the stored ci values for each user', function () {
    $administrator = createUsuarioApiUser('admin-ci@example.org', 'Administrador');
    $administrator->forceFill(['ci' => '4521678 SC'])->save();

    $this->withToken($administrator->createToken('ci-list-test')->plainTextToken)
        ->getJson('/api/usuarios')
        ->assertOk()
        ->assertJsonPath('usuarios.0.ci', '4521678 SC');
});

test('user management requires an authenticated administrator', function () {
    $this->getJson('/api/usuarios')->assertUnauthorized();

    $staff = createUsuarioApiUser('staff@example.org', 'Veterinario');

    $this->withToken($staff->createToken('staff-test')->plainTextToken)
        ->getJson('/api/usuarios')
        ->assertForbidden();

    $this->withToken($staff->createToken('staff-update-test')->plainTextToken)
        ->patchJson('/api/usuarios/'.$staff->id, [
            'nombre' => 'Nombre no autorizado',
            'telefono' => '79999999',
        ])
        ->assertForbidden();
});

test('user creation validates required fields and allowed roles', function () {
    $administrator = createUsuarioApiUser('admin-validation@example.org', 'Administrador');

    $this->withToken($administrator->createToken('validation-test')->plainTextToken)
        ->postJson('/api/usuarios', [])
        ->assertStatus(422)
        ->assertJsonValidationErrors(['nombre', 'ci', 'email', 'telefono', 'rol', 'password']);
});

test('an administrator can modify a users name and phone number', function () {
    $administrator = createUsuarioApiUser('admin-edit@example.org', 'Administrador');
    $user = createUsuarioApiUser('staff-edit@example.org', 'Veterinario');

    $this->withToken($administrator->createToken('edit-user-test')->plainTextToken)
        ->patchJson('/api/usuarios/'.$user->id, [
            'nombre' => 'Nombre actualizado',
            'telefono' => '+59170011111',
        ])
        ->assertOk()
        ->assertJsonPath('usuario.nombre', 'Nombre actualizado')
        ->assertJsonPath('usuario.telefono', '+59170011111')
        ->assertJsonMissingPath('usuario.password');

    $this->assertDatabaseHas('users', [
        'id' => $user->id,
        'nombre' => 'Nombre actualizado',
        'telefono' => '+59170011111',
    ]);
});

test('role changes are applied but cannot remove the final administrator', function () {
    $administrator = createUsuarioApiUser('admin-role@example.org', 'Administrador');
    $user = createUsuarioApiUser('staff-role@example.org', 'Veterinario');
    $token = $administrator->createToken('role-change-test')->plainTextToken;

    $this->withToken($token)
        ->patchJson('/api/usuarios/'.$user->id.'/rol', ['rol' => 'Recepcionista'])
        ->assertOk()
        ->assertJsonPath('usuario.rol', 'Recepcionista');

    $roleChange = Bitacora::query()
        ->where('tipo_accion', 'Cambiar rol de usuario')
        ->firstOrFail();
    expect($roleChange->contexto)->toBe([
        'rol_anterior' => 'Veterinario',
        'rol_nuevo' => 'Recepcionista',
    ]);

    $this->withToken($token)
        ->patchJson('/api/usuarios/'.$administrator->id.'/rol', ['rol' => 'Voluntario'])
        ->assertStatus(422)
        ->assertJsonValidationErrors('rol');

    $this->assertDatabaseHas('users', [
        'id' => $administrator->id,
        'rol' => 'Administrador',
    ]);
});

test('an administrator can suspend and reactivate another users account', function () {
    $administrator = createUsuarioApiUser('admin-suspend@example.org', 'Administrador');
    $user = createUsuarioApiUser('staff-suspend@example.org', 'Veterinario');
    $userToken = $user->createToken('staff-session')->plainTextToken;
    $adminToken = $administrator->createToken('suspend-user-test')->plainTextToken;

    $this->withToken($adminToken)
        ->patchJson('/api/usuarios/'.$user->id.'/estado', ['activo' => false])
        ->assertOk()
        ->assertJsonPath('usuario.activo', false);

    $this->assertDatabaseHas('users', [
        'id' => $user->id,
        'activo' => false,
    ]);
    $this->assertModelExists($user);
    expect($user->tokens()->count())->toBe(0);

    $this->app['auth']->forgetGuards();

    $this->withToken($userToken)
        ->getJson('/api/user')
        ->assertUnauthorized();

    $this->postJson('/api/login', [
        'usuario' => $user->email,
        'password' => 'refugio-password',
    ])
        ->assertForbidden()
        ->assertJsonPath('mensaje', 'La cuenta está inactiva. Contacta al administrador del refugio.');

    $this->withToken($adminToken)
        ->patchJson('/api/usuarios/'.$user->id.'/estado', ['activo' => true])
        ->assertOk()
        ->assertJsonPath('usuario.activo', true);

    $this->assertDatabaseHas('users', [
        'id' => $user->id,
        'activo' => true,
    ]);
});

test('an administrator cannot suspend their own account', function () {
    $administrator = createUsuarioApiUser('admin-self-suspend@example.org', 'Administrador');
    $token = $administrator->createToken('self-suspend-test')->plainTextToken;

    $this->withToken($token)
        ->patchJson('/api/usuarios/'.$administrator->id.'/estado', ['activo' => false])
        ->assertForbidden();

    $this->assertDatabaseHas('users', [
        'id' => $administrator->id,
        'activo' => true,
    ]);

    expect($administrator->tokens()->count())->toBe(1);
});
