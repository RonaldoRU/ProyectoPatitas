<?php

namespace App\Http\Controllers;

use App\Models\Bitacora;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BitacoraController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        abort_unless($request->user()?->rol === 'Administrador', 403);

        $validated = $request->validate([
            'usuario' => ['nullable', 'string', 'max:255'],
            'accion' => ['nullable', 'string', 'max:255'],
            'modulo' => ['nullable', 'string', 'max:100'],
            'buscar' => ['nullable', 'string', 'max:255'],
            'desde' => ['nullable', 'date_format:Y-m-d'],
            'hasta' => ['nullable', 'date_format:Y-m-d', 'after_or_equal:desde'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:100'],
            'page' => ['nullable', 'integer', 'min:1'],
        ]);

        $records = Bitacora::query()
            ->select([
                'id',
                'id_usuario',
                'usuario_nombre',
                'tipo_accion',
                'modulo',
                'descripcion',
                'entidad_tipo',
                'entidad_id',
                'ip',
                'http_method',
                'ruta',
                'resultado',
                'contexto',
                'created_at',
            ])
            ->with(['usuario:id,nombre'])
            ->when(
                $validated['usuario'] ?? null,
                fn (Builder $query, string $usuario) => $query->where(
                    'usuario_nombre',
                    'like',
                    "%{$usuario}%",
                ),
            )
            ->when(
                $validated['accion'] ?? null,
                fn (Builder $query, string $accion) => $query->where(
                    'tipo_accion',
                    'like',
                    "%{$accion}%",
                ),
            )
            ->when(
                $validated['modulo'] ?? null,
                fn (Builder $query, string $modulo) => $query->where('modulo', $modulo),
            )
            ->when(
                $validated['buscar'] ?? null,
                fn (Builder $query, string $buscar) => $query->where(
                    fn (Builder $searchQuery) => $searchQuery
                        ->where('descripcion', 'like', "%{$buscar}%")
                        ->orWhere('tipo_accion', 'like', "%{$buscar}%")
                        ->orWhere('entidad_tipo', 'like', "%{$buscar}%")
                        ->orWhere('entidad_id', 'like', "%{$buscar}%"),
                ),
            )
            ->when(
                $validated['desde'] ?? null,
                fn (Builder $query, string $desde) => $query->where(
                    'created_at',
                    '>=',
                    "{$desde} 00:00:00",
                ),
            )
            ->when(
                $validated['hasta'] ?? null,
                fn (Builder $query, string $hasta) => $query->where(
                    'created_at',
                    '<=',
                    "{$hasta} 23:59:59",
                ),
            )
            ->orderByDesc('created_at')
            ->orderByDesc('id')
            ->paginate($validated['per_page'] ?? 25)
            ->withQueryString()
            ->through(fn (Bitacora $registro): array => [
                'id' => $registro->id,
                'id_usuario' => $registro->id_usuario,
                'usuario' => $registro->usuario_nombre
                    ?? $registro->usuario?->nombre
                    ?? 'Usuario no disponible',
                'tipo_accion' => $registro->tipo_accion,
                'modulo' => $registro->modulo,
                'descripcion' => $registro->descripcion,
                'entidad_tipo' => $registro->entidad_tipo,
                'entidad_id' => $registro->entidad_id,
                'fecha_hora' => $registro->created_at,
                'ip' => $registro->ip,
                'http_method' => $registro->http_method,
                'ruta' => $registro->ruta,
                'resultado' => $registro->resultado,
                'contexto' => $registro->contexto,
            ]);

        return response()->json(['bitacoras' => $records]);
    }
}
