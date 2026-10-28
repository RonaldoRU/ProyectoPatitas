<?php

namespace App\Http\Controllers\P8_Adopciones;

use App\Http\Controllers\Controller;
use App\Models\Adopcion;
use App\Models\InteresadoAdopcion;
use App\Models\Mascota;
use App\Models\SeguimientoAdopcion;
use App\Services\AuditoriaService;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

/**
 * Paquete P8: Gestión Integral de Adopciones y Control Post-Adopción
 * Casos de Uso:
 * - CU21: Registrar y Evaluar Postulante a Adopción (Scoring de Idoneidad)
 * - CU22: Formalizar Adopción de Mascota y Programación de Visitas
 */
class PostulanteController extends Controller
{
    private const ESTADOS = ['Pendiente', 'En evaluación', 'Aprobado', 'Rechazado'];

    public function index(Request $request): JsonResponse
    {
        $this->authorizeStaff($request);

        $postulantes = InteresadoAdopcion::query()
            ->with(['adopciones' => function (HasMany $query): void {
                $query->select(['id', 'id_interesado', 'id_mascota', 'fecha_adopcion'])
                    ->with('mascota:id,nombre,especie,raza');
            }])
            ->orderBy('nombre')
            ->get();

        $mascotasDisponibles = Mascota::query()
            ->where('estado_actual', 'Disponible')
            ->orderBy('nombre')
            ->get(['id', 'nombre', 'especie', 'raza']);

        return response()->json([
            'postulantes' => $postulantes,
            'mascotas_disponibles' => $mascotasDisponibles,
        ]);
    }

    public function store(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $this->authorizeStaff($request);

        $postulante = DB::transaction(function () use ($request, $auditoria): InteresadoAdopcion {
            $data = $this->validatedData($request);
            $postulante = InteresadoAdopcion::query()->create($data);
            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar postulante',
                'adopciones',
                entidad: $postulante,
                contexto: [
                    'nombre' => $postulante->nombre,
                    'puntaje' => $postulante->puntaje_evaluacion,
                    'estado' => $postulante->estado,
                ],
            );

            return $postulante;
        });

        return response()->json(['postulante' => $postulante], 201);
    }

    public function update(
        Request $request,
        InteresadoAdopcion $postulante,
        AuditoriaService $auditoria,
    ): JsonResponse {
        $this->authorizeStaff($request);
        $validated = $this->validatedData($request, $postulante);

        DB::transaction(function () use ($request, $postulante, $auditoria, $validated): void {
            $postulante->update($validated);
            $auditoria->registrar(
                $request,
                $request->user(),
                'Modificar evaluación de postulante',
                'adopciones',
                entidad: $postulante,
                contexto: [
                    'campos_modificados' => array_values(array_intersect(
                        array_keys($postulante->getChanges()),
                        array_keys($validated),
                    )),
                ],
            );
        });

        return response()->json(['postulante' => $postulante->load('adopciones.mascota')]);
    }

    public function storeAdoption(
        Request $request,
        InteresadoAdopcion $postulante,
        AuditoriaService $auditoria,
    ): JsonResponse {
        $this->authorizeStaff($request);

        $validated = $request->validate([
            'id_mascota' => ['required', 'integer', 'exists:mascotas,id'],
            'fecha_adopcion' => ['required', 'date'],
        ]);

        $adopcion = DB::transaction(function () use (
            $request,
            $postulante,
            $validated,
            $auditoria,
        ): Adopcion {
            $postulante = InteresadoAdopcion::query()
                ->lockForUpdate()
                ->findOrFail($postulante->getKey());

            if ($postulante->estado !== 'Aprobado') {
                throw ValidationException::withMessages([
                    'postulante' => 'Solo se puede registrar una adopción para un postulante aprobado.',
                ]);
            }

            $mascota = Mascota::query()
                ->lockForUpdate()
                ->findOrFail($validated['id_mascota']);

            if ($mascota->estado_actual !== 'Disponible') {
                throw ValidationException::withMessages([
                    'id_mascota' => 'La mascota seleccionada ya no está disponible para adopción.',
                ]);
            }

            $adopcion = $postulante->adopciones()->create([
                'id_mascota' => $mascota->id,
                'fecha_adopcion' => $validated['fecha_adopcion'],
            ]);

            $estadoAnterior = $mascota->estado_actual;
            $mascota->update(['estado_actual' => 'Adoptado']);

            // Programación automática de visitas a los 30, 90 y 180 días (CU22)
            $fechaBase = Carbon::parse($validated['fecha_adopcion']);
            foreach ([30, 90, 180] as $dias) {
                SeguimientoAdopcion::query()->create([
                    'id_adopcion' => $adopcion->getKey(),
                    'id_usuario' => $request->user()->getKey(),
                    'fecha_programada' => $fechaBase->copy()->addDays($dias)->toDateString(),
                    'estado_seguimiento' => 'Programado',
                    'reporte_bienestar' => "Visita de control a los {$dias} días de adopción.",
                    'fotografia' => '/images/default-check.png',
                ]);
            }

            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar adopción',
                'adopciones',
                entidad: $adopcion,
                contexto: ['id_mascota' => $mascota->id],
            );
            $auditoria->registrar(
                $request,
                $request->user(),
                'Cambiar estado de mascota',
                'mascotas',
                entidad: $mascota,
                contexto: [
                    'estado_anterior' => $estadoAnterior,
                    'estado_nuevo' => $mascota->estado_actual,
                ],
            );

            return $adopcion->load('mascota');
        });

        return response()->json(['adopcion' => $adopcion], 201);
    }

    private function validatedData(Request $request, ?InteresadoAdopcion $postulante = null): array
    {
        $validated = $request->validate([
            'ci' => [
                'required',
                'string',
                'max:20',
                Rule::unique('interesado_adopcions', 'ci')->ignore($postulante?->getKey()),
            ],
            'nombre' => ['required', 'string', 'max:255'],
            'direccion' => ['required', 'string', 'max:255'],
            'telefono' => ['required', 'string', 'max:30'],
            'situacion_casa' => ['required', 'string', 'max:255'],
            'referencias' => ['required', 'string', 'max:255'],
            'puntaje_evaluacion' => ['required', 'numeric', 'min:0', 'max:100'],
            'estado' => ['required', 'string', Rule::in(self::ESTADOS)],
        ]);

        if ($postulante?->adopciones()->exists() && $validated['estado'] !== 'Aprobado') {
            throw ValidationException::withMessages([
                'estado' => 'No se puede cambiar el estado de un postulante con adopciones registradas.',
            ]);
        }

        return $validated;
    }

    private function authorizeStaff(Request $request): void
    {
        abort_unless(
            in_array($request->user()?->rol, ['Administrador', 'Recepcionista'], true),
            403,
        );
    }
}
