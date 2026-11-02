<?php

namespace App\Http\Controllers;

use App\Models\RolPermiso;
use App\Models\User;
use Illuminate\Http\JsonResponse;

class RolPermisoController extends Controller
{
    /**
     * asignarRolUsuario(idUser: Int, idRol: Int) : void
     */
    public function asignarRolUsuario(int $idUser, int $idRol): void
    {
        $rol = RolPermiso::query()->find($idRol);
        $user = User::query()->find($idUser);

        if ($user && $rol) {
            $user->update([
                'rol' => $rol->nombre_rol,
            ]);
        }
    }

    /**
     * obtenerPermisosRol() : List<String>
     */
    public function obtenerPermisosRol(?string $nombreRol = null): array
    {
        if ($nombreRol) {
            $rol = RolPermiso::query()->where('nombre_rol', $nombreRol)->first();
            if ($rol && $rol->permisos_modulos) {
                return array_map('trim', explode(',', $rol->permisos_modulos));
            }
        }

        return ['usuarios', 'mascotas', 'inventario', 'adopciones', 'donaciones'];
    }

    public function index(): JsonResponse
    {
        $roles = RolPermiso::all();

        return response()->json(['roles' => $roles]);
    }
}
