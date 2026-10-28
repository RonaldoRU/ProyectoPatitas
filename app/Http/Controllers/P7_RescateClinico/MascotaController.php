<?php

namespace App\Http\Controllers\P7_RescateClinico;

use App\Http\Controllers\Controller;
use App\Models\Mascota;
use App\Services\AuditoriaService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

/**
 * Paquete P7: Gestión de Rescate e Historial Clínico Veterinario
 * Casos de Uso:
 * - CU19: Registrar Ficha de Rescate e Ingreso de Mascota
 */
class MascotaController extends Controller
{
    private const ESTADOS = ['En Recuperación', 'Disponible', 'Adoptado', 'Fallecido', 'En tratamiento'];

    public function index(Request $request): JsonResponse
    {
        $query = Mascota::query();

        if ($request->filled('estado')) {
            $query->where('estado_actual', $request->query('estado'));
        }

        if ($request->filled('especie')) {
            $query->where('especie', $request->query('especie'));
        }

        if ($request->filled('buscar')) {
            $search = '%'.$request->query('buscar').'%';
            $query->where(function ($q) use ($search) {
                $q->where('nombre', 'like', $search)
                    ->orWhere('raza', 'like', $search)
                    ->orWhere('zona_rescate', 'like', $search);
            });
        }

        $mascotas = $query->orderByDesc('id')->get();

        return response()->json(['mascotas' => $mascotas]);
    }

    public function store(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'nombre' => ['required', 'string', 'max:255'],
            'especie' => ['required', 'string', 'max:100'],
            'raza' => ['required', 'string', 'max:100'],
            'edad' => ['required', 'string', 'max:50'],
            'sexo' => ['required', 'string', Rule::in(['Macho', 'Hembra'])],
            'zona_rescate' => ['required', 'string', 'max:255'],
            'fecha_ingreso' => ['required', 'date'],
            'foto' => ['nullable', 'string', 'max:500'],
            'estado_actual' => ['nullable', 'string', Rule::in(self::ESTADOS)],
        ]);

        $validated['estado_actual'] = $validated['estado_actual'] ?? 'En Recuperación';
        $validated['foto'] = $validated['foto'] ?? '/images/default-pet.png';

        $mascota = DB::transaction(function () use ($request, $validated, $auditoria): Mascota {
            $mascota = Mascota::query()->create($validated);
            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar ficha de rescate de mascota',
                'rescate',
                entidad: $mascota,
                contexto: [
                    'nombre' => $mascota->nombre,
                    'especie' => $mascota->especie,
                    'zona_rescate' => $mascota->zona_rescate,
                    'estado_actual' => $mascota->estado_actual,
                ],
            );

            return $mascota;
        });

        return response()->json(['mascota' => $mascota], 201);
    }

    public function show(Mascota $mascota): JsonResponse
    {
        return response()->json([
            'mascota' => $mascota->load(['historialesClinicos.usuario:id,nombre']),
        ]);
    }

    public function update(Request $request, Mascota $mascota, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'nombre' => ['sometimes', 'required', 'string', 'max:255'],
            'especie' => ['sometimes', 'required', 'string', 'max:100'],
            'raza' => ['sometimes', 'required', 'string', 'max:100'],
            'edad' => ['sometimes', 'required', 'string', 'max:50'],
            'sexo' => ['sometimes', 'required', 'string', Rule::in(['Macho', 'Hembra'])],
            'zona_rescate' => ['sometimes', 'required', 'string', 'max:255'],
            'fecha_ingreso' => ['sometimes', 'required', 'date'],
            'foto' => ['nullable', 'string', 'max:500'],
            'estado_actual' => ['sometimes', 'required', 'string', Rule::in(self::ESTADOS)],
        ]);

        DB::transaction(function () use ($request, $mascota, $validated, $auditoria): void {
            $mascota->update($validated);
            $auditoria->registrar(
                $request,
                $request->user(),
                'Actualizar ficha de rescate de mascota',
                'rescate',
                entidad: $mascota,
                contexto: [
                    'campos_modificados' => array_keys($mascota->getChanges()),
                ],
            );
        });

        return response()->json(['mascota' => $mascota->refresh()]);
    }
}
