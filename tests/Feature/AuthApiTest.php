<?php

use App\Models\User;
use Illuminate\Support\Facades\Cache;

test('login returns a Sanctum token for valid credentials', function () {
    $user = new User([
        'nombre' => 'Rosa Méndez',
        'email' => 'rosa@example.org',
        'rol' => 'Voluntario',
        'password' => 'refugio-password',
    ]);
    $user->forceFill(['telefono' => '70000000'])->save();

    $response = $this->postJson('/api/login', [
        'usuario' => $user->email,
        'password' => 'refugio-password',
    ]);

    $response->assertOk()
        ->assertJsonStructure([
            'token',
            'usuario' => ['id', 'nombre', 'email', 'rol'],
        ])
        ->assertJsonMissingPath('usuario.password');

    $this->withToken($response->json('token'))
        ->getJson('/api/user')
        ->assertOk()
        ->assertJsonPath('email', $user->email);
});

test('login rejects invalid credentials', function () {
    $response = $this->postJson('/api/login', [
        'usuario' => 'missing@example.org',
        'password' => 'wrong-password',
    ]);

    $response->assertUnauthorized()
        ->assertJsonPath('mensaje', 'Credenciales inválidas');
});

test('login validates the email and password fields', function () {
    $this->postJson('/api/login', [])
        ->assertStatus(422)
        ->assertJsonValidationErrors(['usuario', 'password']);
});

test('login blocks for 5 seconds after 3 failed attempts and keeps the same lockout while it is active', function () {
    Cache::flush();

    $email = 'rosa@example.org';

    $this->postJson('/api/login', [
        'usuario' => $email,
        'password' => 'wrong-1',
    ])->assertUnauthorized();

    $this->postJson('/api/login', [
        'usuario' => $email,
        'password' => 'wrong-2',
    ])->assertUnauthorized();

    $this->postJson('/api/login', [
        'usuario' => $email,
        'password' => 'wrong-3',
    ])->assertStatus(429)
        ->assertJsonPath('mensaje', 'Demasiados intentos. Espera 5 segundos antes de intentarlo de nuevo.')
        ->assertJsonPath('espera_segundos', 5);

    $this->postJson('/api/login', [
        'usuario' => $email,
        'password' => 'wrong-4',
    ])->assertStatus(429)
        ->assertJsonPath('mensaje', 'Demasiados intentos. Espera 5 segundos antes de intentarlo de nuevo.')
        ->assertJsonPath('espera_segundos', 5);
});
