<?php

namespace App\Services;

use App\Models\Bitacora;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;

class AuditoriaService
{
    /**
     * @param  array<string, scalar|list<string>|null>|null  $contexto
     */
    public function registrar(
        Request $request,
        ?User $usuario,
        string $accion,
        string $modulo,
        string $resultado = 'exitosa',
        ?Model $entidad = null,
        ?string $descripcion = null,
        ?array $contexto = null,
    ): Bitacora {
        return Bitacora::query()->create([
            'id_usuario' => $usuario?->getKey(),
            'usuario_nombre' => $usuario?->nombre ?? 'No autenticado',
            'tipo_accion' => $accion,
            'modulo' => $modulo,
            'descripcion' => $descripcion ?? $accion,
            'entidad_tipo' => $entidad === null ? null : class_basename($entidad),
            'entidad_id' => $entidad === null ? null : (string) $entidad->getKey(),
            'ip' => $request->ip(),
            'http_method' => $request->method(),
            'ruta' => $request->route()?->uri(),
            'resultado' => $resultado,
            'contexto' => $contexto,
        ]);
    }
}
