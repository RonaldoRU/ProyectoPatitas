<?php

namespace App\Http\Controllers;

use App\Models\SesionJWT;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class SesionJWTController extends Controller
{
    /**
     * crearSesion(idUser: Int) : SesionJWT
     */
    public function crearSesion(int $idUser): SesionJWT
    {
        $hash = hash('sha256', Str::random(40).time().$idUser);

        return SesionJWT::query()->create([
            'token_hash' => $hash,
            'id_usuario' => $idUser,
            'ip_cliente' => request()->ip() ?? '127.0.0.1',
            'user_agent' => request()->userAgent() ?? 'Web Browser',
            'fecha_emision' => now(),
            'fecha_expiracion' => now()->addDays(7),
            'estado' => 'Activo',
        ]);
    }

    /**
     * validarToken(token: String) : Boolean
     */
    public function validarToken(string $token): bool
    {
        $sesion = SesionJWT::query()
            ->where('token_hash', $token)
            ->where('estado', 'Activo')
            ->where('fecha_expiracion', '>', now())
            ->first();

        return $sesion !== null;
    }

    /**
     * revocarToken() : void
     */
    public function revocarToken(?string $token = null): void
    {
        $t = $token ?? request()->bearerToken();
        if ($t) {
            SesionJWT::query()->where('token_hash', $t)->update([
                'estado' => 'Revocado',
            ]);
        }
    }

    public function index(Request $request): JsonResponse
    {
        $sesiones = SesionJWT::query()
            ->with('usuario')
            ->where('estado', 'Activo')
            ->orderByDesc('fecha_emision')
            ->limit(50)
            ->get();

        return response()->json(['sesiones' => $sesiones]);
    }
}
