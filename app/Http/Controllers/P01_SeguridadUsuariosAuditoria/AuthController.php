<?php

namespace App\Http\Controllers\P01_SeguridadUsuariosAuditoria;

use App\Http\Controllers\Controller;
use App\Models\Donante;
use App\Models\InteresadoAdopcion;
use App\Models\User;
use App\Notifications\PasswordResetCodeNotification;
use App\Services\AuditoriaService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\Rule;

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

    /**
     * CU1: Iniciar Sesión en la Plataforma Web
     * Valida credenciales, aplica bloqueo progresivo contra fuerza bruta,
     * emite token Sanctum y genera registro de auditoría.
     */
    public function login(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $credentials = $request->validate([
            'usuario' => ['required', 'string'],
            'password' => ['required', 'string'],
        ]);

        $loginInput = strtolower(trim($credentials['usuario']));
        $email = $loginInput;

        if ($this->isLockedOut($loginInput)) {
            $seconds = $this->remainingLockoutSeconds($loginInput);

            return response()->json([
                'mensaje' => 'Demasiados intentos. Espera '.$seconds.' segundos antes de intentarlo de nuevo.',
                'espera_segundos' => $seconds,
            ], 429);
        }

        $user = User::query()
            ->where('email', $loginInput)
            ->orWhere(function ($q) use ($loginInput): void {
                $q->where('email', 'like', "%{$loginInput}%")
                    ->orWhere('nombre', 'like', "%{$loginInput}%");
            })
            ->first();

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

    /**
     * Registro Público de Cuenta Externa (Donante o Postulante a Adopción).
     * Otorga acceso de solo lectura al catálogo de mascotas disponibles y opción de donar dinero en línea.
     */
    public function registroPublico(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'nombre' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255', 'unique:users,email'],
            'telefono' => ['nullable', 'string', 'max:50'],
            'rol' => ['required', 'string', Rule::in(['Donante', 'Postulante'])],
            'password' => ['required', 'string', 'min:6', 'confirmed'],
        ]);

        $resultado = DB::transaction(function () use ($request, $validated, $auditoria): array {
            $telefono = ! empty($validated['telefono']) ? trim($validated['telefono']) : '70000000';
            $email = strtolower(trim($validated['email']));

            $user = new User([
                'nombre' => trim($validated['nombre']),
                'email' => $email,
                'rol' => $validated['rol'],
                'password' => $validated['password'],
                'activo' => true,
            ]);
            $user->forceFill(['telefono' => $telefono, 'activo' => true])->save();

            if ($validated['rol'] === 'Donante') {
                Donante::query()->firstOrCreate(
                    ['nombre' => $user->nombre],
                    [
                        'telefono' => $telefono,
                        'tipo_persona' => 'Natural',
                    ]
                );
            } else {
                InteresadoAdopcion::query()->firstOrCreate(
                    ['nombre' => $user->nombre],
                    [
                        'ci' => 'WEB-'.random_int(100000, 999999),
                        'telefono' => $telefono,
                        'direccion' => 'Registrado desde portal web',
                        'situacion_casa' => 'Casa familiar (Por evaluar)',
                        'referencias' => $email,
                        'puntaje_evaluacion' => '80',
                        'estado' => 'En Evaluación',
                    ]
                );
            }

            $token = $user->createToken('patitas')->plainTextToken;
            $auditoria->registrar(
                $request,
                $user,
                "Registro público de cuenta ({$user->rol})",
                'autenticacion',
                entidad: $user
            );

            return [
                'token' => $token,
                'usuario' => $user->only(['id', 'nombre', 'email', 'rol']),
            ];
        });

        return response()->json([
            'mensaje' => 'Cuenta creada exitosamente.',
            'token' => $resultado['token'],
            'usuario' => $resultado['usuario'],
        ], 201);
    }

    /**
     * CU2: Cerrar Sesión y Revocar Token
     * Elimina el token de acceso actual del usuario y registra la salida en bitácora.
     */
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

    /**
     * CU3: Solicitar Código OTP de Recuperación de Contraseña
     * Genera un código de 6 dígitos con validez de 10 minutos y lo envía al usuario.
     */
    public function solicitarCodigo(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'ci_email' => ['required', 'string', 'max:255'],
        ]);
        $input = trim($validated['ci_email']);
        $user = filter_var($input, FILTER_VALIDATE_EMAIL)
            ? User::query()->where('email', strtolower($input))->first()
            : User::query()->where('ci', $input)->first();

        if ($user !== null) {
            $code = (string) random_int(100000, 999999);

            Cache::put(
                $this->passwordResetCacheKey($user->email),
                Hash::make($code),
                now()->addMinutes(10),
            );

            try {
                $user->notify(new PasswordResetCodeNotification($code));
            } catch (\Throwable $e) {
                Log::error('Fallo al enviar correo de restablecimiento: '.$e->getMessage());
            }

            Log::info("Código de recuperación generado para {$user->email}: {$code}");
        }

        return response()->json([
            'message' => 'Si el correo pertenece a una cuenta, enviaremos un código de recuperación.',
        ], 202);
    }

    /**
     * CU3: Restablecer Contraseña con Código OTP
     * Comprueba validez del código en caché, actualiza la contraseña con hashing seguro y revoca sesiones previas.
     */
    public function restablecerPassword(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'ci_email' => ['required', 'string', 'max:255'],
            'codigo' => ['required', 'digits:6'],
            'password' => [
                'required',
                'string',
                'min:8',
                'confirmed',
                'regex:/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).+$/',
            ],
        ]);
        $input = trim($validated['ci_email']);
        $user = filter_var($input, FILTER_VALIDATE_EMAIL)
            ? User::query()->where('email', strtolower($input))->first()
            : User::query()->where('ci', $input)->first();

        $email = $user ? $user->email : strtolower($input);
        $cacheKey = $this->passwordResetCacheKey($email);
        $hashedCode = Cache::get($cacheKey);

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

            if (! empty($user->ci)) {
                DB::table('usuario')->where('ci', $user->ci)->update([
                    'hash_contrasena' => Hash::make($validated['password']),
                    'intentos_fallidos' => 0,
                    'bloqueado_hasta' => null,
                    'updated_at' => now(),
                ]);
            }

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
