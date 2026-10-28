<?php

namespace App\Http\Controllers\P2_Usuarios;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Services\AuditoriaService;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

/**
 * Paquete P2: Administración de Usuarios y Permisos (RBAC)
 * Casos de Uso:
 * - CU4: Registrar Nuevo Usuario del Sistema
 * - CU5: Consultar Catálogo y Perfil de Usuarios
 * - CU6: Modificar Datos de Cuenta de Usuario
 * - CU7: Cambiar Rol Operativo y Permisos (RBAC)
 * - CU8: Suspender / Inactivar Cuenta de Usuario
 */
class UsuarioController extends Controller
{
    private const ROLES = [
        'Administrador',
        'Veterinario',
        'Recepcionista',
        'Voluntario',
    ];

    public function index(Request $request): JsonResponse
    {
        $this->authorizeAdministrator($request);

        $query = User::query()
            ->select(['id', 'ci', 'nombre', 'email', 'telefono', 'rol', 'activo', 'created_at']);

        if ($request->filled('rol')) {
            $query->where('rol', $request->query('rol'));
        }

        if ($request->filled('buscar')) {
            $search = '%'.$request->query('buscar').'%';
            $query->where(function ($q) use ($search) {
                $q->where('nombre', 'like', $search)
                    ->orWhere('email', 'like', $search)
                    ->orWhere('ci', 'like', $search);
            });
        }

        $usuarios = $query->orderBy('nombre')->get();

        return response()->json(['usuarios' => $usuarios]);
    }

    public function store(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $this->authorizeAdministrator($request);

        $validated = $request->validate([
            'nombre' => ['required', 'string', 'max:255'],
            'ci' => ['required', 'string', 'max:20', 'unique:users,ci'],
            'email' => ['required', 'email', 'max:255', 'unique:users,email'],
            'telefono' => ['required', 'string', 'max:30'],
            'rol' => ['required', 'string', Rule::in(self::ROLES)],
            'password' => [
                'required',
                'string',
                'min:8',
                'regex:/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).+$/',
            ],
        ]);

        $usuario = DB::transaction(function () use ($request, $validated, $auditoria): User {
            $usuario = User::query()->create($validated);
            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar usuario',
                'usuarios',
                entidad: $usuario,
                contexto: ['campos_registrados' => ['ci', 'nombre', 'email', 'telefono', 'rol']],
            );

            return $usuario;
        });

        return response()->json([
            'usuario' => $usuario->only(['id', 'ci', 'nombre', 'email', 'telefono', 'rol', 'activo', 'created_at']),
        ], 201);
    }

    public function show(Request $request, User $usuario): JsonResponse
    {
        $this->authorizeAdministrator($request);

        return response()->json([
            'usuario' => $usuario->only(['id', 'ci', 'nombre', 'email', 'telefono', 'rol', 'activo', 'created_at']),
        ]);
    }

    public function update(Request $request, User $usuario, AuditoriaService $auditoria): JsonResponse
    {
        $this->authorizeAdministrator($request);

        $validated = $request->validate([
            'nombre' => ['required', 'string', 'max:255'],
            'telefono' => ['required', 'string', 'max:30'],
        ]);

        DB::transaction(function () use ($request, $usuario, $validated, $auditoria): void {
            $usuario->update($validated);
            $auditoria->registrar(
                $request,
                $request->user(),
                'Modificar datos de usuario',
                'usuarios',
                entidad: $usuario,
                contexto: [
                    'campos_modificados' => array_values(array_intersect(
                        array_keys($usuario->getChanges()),
                        array_keys($validated),
                    )),
                ],
            );
        });

        return response()->json([
            'usuario' => $usuario->only(['id', 'ci', 'nombre', 'email', 'telefono', 'rol', 'activo', 'created_at']),
        ]);
    }

    public function changeRole(Request $request, User $usuario, AuditoriaService $auditoria): JsonResponse
    {
        $this->authorizeAdministrator($request);

        $validated = $request->validate([
            'rol' => ['required', 'string', Rule::in(self::ROLES)],
        ]);

        $usuario = DB::transaction(function () use ($request, $usuario, $validated, $auditoria): User {
            /** @var Collection<int, User> $administrators */
            $administrators = User::query()
                ->where('rol', 'Administrador')
                ->orderBy('id')
                ->lockForUpdate()
                ->get();

            $lockedUser = User::query()->lockForUpdate()->findOrFail($usuario->getKey());
            $rolAnterior = $lockedUser->rol;

            if (
                $rolAnterior === 'Administrador'
                && $validated['rol'] !== 'Administrador'
                && $administrators->count() <= 1
            ) {
                throw ValidationException::withMessages([
                    'rol' => 'No se puede retirar el rol de Administrador a la última cuenta con ese privilegio.',
                ]);
            }

            $lockedUser->update(['rol' => $validated['rol']]);
            $auditoria->registrar(
                $request,
                $request->user(),
                'Cambiar rol de usuario',
                'usuarios',
                entidad: $lockedUser,
                contexto: [
                    'rol_anterior' => $rolAnterior,
                    'rol_nuevo' => $lockedUser->rol,
                ],
            );

            return $lockedUser;
        });

        return response()->json([
            'usuario' => $usuario->only(['id', 'ci', 'nombre', 'email', 'telefono', 'rol', 'activo', 'created_at']),
        ]);
    }

    public function setStatus(Request $request, User $usuario, AuditoriaService $auditoria): JsonResponse
    {
        $this->authorizeAdministrator($request);

        $validated = $request->validate([
            'activo' => ['required', 'boolean'],
        ]);

        abort_unless(
            $request->user()?->isNot($usuario),
            403,
            'No puedes suspender ni inactivar tu propia cuenta.',
        );

        $usuario = DB::transaction(function () use ($request, $usuario, $validated, $auditoria): User {
            $lockedUser = User::query()->lockForUpdate()->findOrFail($usuario->getKey());
            $estadoAnterior = $lockedUser->activo;
            $lockedUser->forceFill(['activo' => $validated['activo']])->save();

            if (! $validated['activo']) {
                $lockedUser->tokens()->delete();
            }

            $auditoria->registrar(
                $request,
                $request->user(),
                $validated['activo'] ? 'Reactivar cuenta de usuario' : 'Suspender cuenta de usuario',
                'usuarios',
                entidad: $lockedUser,
                contexto: [
                    'estado_anterior' => $estadoAnterior,
                    'estado_nuevo' => $lockedUser->activo,
                ],
            );

            return $lockedUser;
        });

        return response()->json([
            'usuario' => $usuario->only(['id', 'ci', 'nombre', 'email', 'telefono', 'rol', 'activo', 'created_at']),
        ]);
    }

    private function authorizeAdministrator(Request $request): void
    {
        abort_unless($request->user()?->rol === 'Administrador', 403);
    }
}
