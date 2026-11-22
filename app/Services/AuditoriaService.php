<?php

namespace App\Services;

use App\Models\Bitacora;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;

/**
 * Servicio de Auditoría: Registra de forma centralizada todas las operaciones críticas en la tabla `bitacoras`.
 * Captura usuario responsable, acción, módulo, entidad afectada, IP cliente y estado del resultado.
 */
class AuditoriaService
{
    /**
     * Registra un nuevo evento de auditoría en la bitácora.
     *
     * @param  Request  $request  Petición HTTP actual para extraer IP, método y ruta.
     * @param  User|null  $usuario  Usuario autenticado que ejecuta la acción (o null si es público/fallido).
     * @param  string  $accion  Nombre corto de la acción (ej. 'iniciar_sesion', 'crear_adopcion').
     * @param  string  $modulo  Módulo del sistema (ej. 'Seguridad', 'Adopciones', 'Inventario').
     * @param  string  $resultado  Resultado de la acción: 'exitosa', 'fallida', 'advertencia'.
     * @param  Model|null  $entidad  Modelo Eloquent afectado (opcional).
     * @param  string|null  $descripcion  Detalle explicativo de lo ocurrido.
     * @param  array<string, scalar|list<string>|null>|null  $contexto  Metadatos o parámetros adicionales.
     * @param  string|null  $nombreUsuario  Nombre descriptivo en caso de que el usuario aún no tenga ID.
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
        ?string $nombreUsuario = null,
    ): Bitacora {
        return Bitacora::query()->create([
            'id_usuario' => $usuario?->getKey(),
            'usuario_nombre' => $usuario?->nombre ?? $nombreUsuario ?? 'No autenticado',
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
