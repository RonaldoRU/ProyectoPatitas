<?php

use App\Models\User;
use App\Notifications\PasswordResetCodeNotification;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Notification;

function createPasswordRecoveryUser(string $email): User
{
    $user = new User([
        'nombre' => 'Rosa Méndez',
        'email' => $email,
        'rol' => 'Voluntario',
        'password' => 'old-password',
    ]);
    $user->forceFill(['telefono' => '70000000'])->save();

    return $user;
}

function passwordRecoveryCacheKey(string $email): string
{
    return 'password-reset-code:'.hash('sha256', strtolower($email));
}

test('recovery request emails a temporary code without returning it in the response', function () {
    Notification::fake();
    $user = createPasswordRecoveryUser('rosa@example.org');

    $response = $this->postJson('/api/solicitar-codigo', [
        'ci_email' => $user->email,
    ]);

    $response->assertAccepted()
        ->assertJsonMissingPath('codigo');

    Notification::assertSentTo(
        $user,
        PasswordResetCodeNotification::class,
        fn (PasswordResetCodeNotification $notification): bool => preg_match('/^\d{6}$/', $notification->code) === 1,
    );
});

test('recovery request uses the same response for an unknown email', function () {
    Notification::fake();

    $response = $this->postJson('/api/solicitar-codigo', [
        'ci_email' => 'missing@example.org',
    ]);

    $response->assertAccepted()
        ->assertJsonPath('message', 'Si el correo pertenece a una cuenta, enviaremos un código de recuperación.');

    Notification::assertNothingSent();
});

test('a valid recovery code resets the password and revokes existing tokens', function () {
    $user = createPasswordRecoveryUser('rosa@example.org');
    $user->createToken('before-password-reset');
    $cacheKey = passwordRecoveryCacheKey($user->email);

    Cache::put($cacheKey, Hash::make('123456'), now()->addMinutes(10));

    $this->postJson('/api/restablecer-password', [
        'ci_email' => $user->email,
        'codigo' => '123456',
        'password' => 'NuevaClave!2026',
        'password_confirmation' => 'NuevaClave!2026',
    ])->assertOk()
        ->assertJsonPath('message', 'La contraseña se actualizó correctamente.');

    expect(Hash::check('NuevaClave!2026', $user->fresh()->password))->toBeTrue()
        ->and($user->tokens()->count())->toBe(0)
        ->and(Cache::has($cacheKey))->toBeFalse();
});

test('recovery rejects an expired or incorrect code', function () {
    $user = createPasswordRecoveryUser('rosa@example.org');

    $this->postJson('/api/restablecer-password', [
        'ci_email' => $user->email,
        'codigo' => '123456',
        'password' => 'NuevaClave!2026',
        'password_confirmation' => 'NuevaClave!2026',
    ])->assertStatus(422)
        ->assertJsonPath('message', 'El código es incorrecto o ha expirado.');

    expect(Hash::check('old-password', $user->fresh()->password))->toBeTrue();
});
