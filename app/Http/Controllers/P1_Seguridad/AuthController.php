<?php

namespace App\Http\Controllers\P1_Seguridad;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Notifications\PasswordResetCodeNotification;
use App\Services\AuditoriaService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

/**
 * Paquete P1: Gestión de Seguridad y Autenticación
 * Casos de Uso:
 * - CU1: Iniciar Sesión en la Plataforma Web
 * - CU2: Cerrar Sesión y Revocar Token JWT
 * - CU3: Recuperar / Restablecer Contraseña Olvidada
 */
class AuthController extends Controller
{
    private const MAX_LOGIN_ATTEMPTS = 3;

    private const INITIAL_LOGIN_LOCKOUT_SECONDS = 5;

    private const LOGIN_LOCKOUT_INCREMENT_SECONDS = 10;

    public function login(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $credentials = $request->validate([
            'usuario' => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        $email = strtolower(trim($credentials['usuario']));

        if ($this->isLockedOut($email)) {
            $seconds = $this->remainingLockoutSeconds($email);

            return response()->json([
                'mensaje' => 'Demasiados intentos. Espera '.$seconds.' segundos antes de intentarlo de nuevo.',
                'espera_segundos' => $seconds,
            ], 429);
        }

        $user = User::query()->where('email', $email)->first();

        if ($user === null || ! Hash::check($credentials['password'], $user->password)) {
            $auditoria->registrar(
                $request,
                null,
                'Intento de inicio de sesión rechazado',
                'autenticacion',
                'fallida',
                descripcion: 'Credenciales rechazadas.',
            );

            $attempts = $this->registerFailedAttempt($email);

            if ($this->hasReachedLimit($attempts)) {
                $lockoutSeconds = $this->lockoutSecondsForAttempts($attempts);
                Cache::put($this->loginLockoutKey($email), now()->addSeconds($lockoutSeconds)->getTimestamp(), now()->addSeconds($lockoutSeconds));
                Cache::forget($this->loginAttemptsKey($email));

                return response()->json([
                    'mensaje' => 'Demasiados intentos. Espera '.$lockoutSeconds.' segundos antes de intentarlo de nuevo.',
                    'espera_segundos' => $lockoutSeconds,
                ], 429);
            }

            return response()->json([
                'mensaje' => 'Credenciales inválidas',
            ], 401);
        }

        Cache::forget($this->loginAttemptsKey($email));
        Cache::forget($this->loginLockoutKey($email));

        if (! $user->activo) {
            $auditoria->registrar(
                $request,
                null,
                'Intento de inicio de sesión rechazado',
                'autenticacion',
                'fallida',
                descripcion: 'La cuenta está inactiva.',
            );

            return response()->json([
                'mensaje' => 'La cuenta está inactiva. Contacta al administrador del refugio.',
            ], 403);
        }

        $token = DB::transaction(function () use ($user, $request, $auditoria): string {
            $token = $user->createToken('patitas')->plainTextToken;
            $auditoria->registrar($request, $user, 'Iniciar sesión', 'autenticacion', entidad: $user);

            return $token;
        });

        return response()->json([
            'token' => $token,
            'usuario' => $user->only(['id', 'nombre', 'email', 'rol']),
        ]);
    }

    public function logout(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $usuario = $request->user();

        DB::transaction(function () use ($request, $usuario, $auditoria): void {
            $usuario?->currentAccessToken()?->delete();

            if ($usuario !== null) {
                $auditoria->registrar($request, $usuario, 'Cerrar sesión', 'autenticacion', entidad: $usuario);
            }
        });

        return response()->json([
            'mensaje' => 'Sesión cerrada',
        ]);
    }

    public function solicitarCodigo(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'ci_email' => ['required', 'email', 'max:255'],
        ]);
        $email = strtolower(trim($validated['ci_email']));
        $user = User::query()->where('email', $email)->first();

        if ($user !== null) {
            $code = (string) random_int(100000, 999999);

            Cache::put(
                $this->passwordResetCacheKey($email),
                Hash::make($code),
                now()->addMinutes(10),
            );

            $user->notify(new PasswordResetCodeNotification($code));
        }

        return response()->json([
            'message' => 'Si el correo pertenece a una cuenta, enviaremos un código de recuperación.',
        ], 202);
    }

    public function restablecerPassword(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'ci_email' => ['required', 'email', 'max:255'],
            'codigo' => ['required', 'digits:6'],
            'password' => [
                'required',
                'string',
                'min:8',
                'confirmed',
                'regex:/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).+$/',
            ],
        ]);
        $email = strtolower(trim($validated['ci_email']));
        $cacheKey = $this->passwordResetCacheKey($email);
        $hashedCode = Cache::get($cacheKey);
        $user = User::query()->where('email', $email)->first();

        if (
            $user === null
            || ! is_string($hashedCode)
            || ! Hash::check($validated['codigo'], $hashedCode)
        ) {
            $auditoria->registrar(
                $request,
                null,
                'Restablecimiento de contraseña rechazado',
                'autenticacion',
                'fallida',
                descripcion: 'Código de restablecimiento inválido o vencido.',
            );

            return response()->json([
                'message' => 'El código es incorrecto o ha expirado.',
            ], 422);
        }

        DB::transaction(function () use ($user, $validated, $request, $auditoria): void {
            $user->forceFill(['password' => $validated['password']])->save();
            $user->tokens()->delete();
            $auditoria->registrar($request, $user, 'Restablecer contraseña', 'autenticacion', entidad: $user);
        });

        Cache::forget($cacheKey);

        return response()->json([
            'message' => 'La contraseña se actualizó correctamente.',
        ]);
    }

    private function passwordResetCacheKey(string $email): string
    {
        return 'password-reset-code:'.hash('sha256', strtolower(trim($email)));
    }

    private function loginAttemptsKey(string $email): string
    {
        return 'login-attempts:'.hash('sha256', strtolower(trim($email)));
    }

    private function loginLockoutKey(string $email): string
    {
        return 'login-lockout:'.hash('sha256', strtolower(trim($email)));
    }

    private function isLockedOut(string $email): bool
    {
        $lockoutExpiresAt = Cache::get($this->loginLockoutKey($email));

        if (! is_numeric($lockoutExpiresAt)) {
            return false;
        }

        return (int) $lockoutExpiresAt > time();
    }

    private function remainingLockoutSeconds(string $email): int
    {
        $lockoutExpiresAt = Cache::get($this->loginLockoutKey($email));

        if (! is_numeric($lockoutExpiresAt)) {
            return 0;
        }

        return max(0, (int) $lockoutExpiresAt - time());
    }

    private function registerFailedAttempt(string $email): int
    {
        $attempts = (int) Cache::get($this->loginAttemptsKey($email), 0) + 1;

        Cache::put($this->loginAttemptsKey($email), $attempts, now()->addMinutes(5));

        return $attempts;
    }

    private function hasReachedLimit(int $attempts): bool
    {
        return $attempts >= self::MAX_LOGIN_ATTEMPTS;
    }

    private function lockoutSecondsForAttempts(int $attempts): int
    {
        return self::INITIAL_LOGIN_LOCKOUT_SECONDS + max(0, $attempts - self::MAX_LOGIN_ATTEMPTS) * self::LOGIN_LOCKOUT_INCREMENT_SECONDS;
    }
}
