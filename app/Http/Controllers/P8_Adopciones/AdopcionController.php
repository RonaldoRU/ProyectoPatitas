<?php

namespace App\Http\Controllers\P8_Adopciones;

use App\Http\Controllers\Controller;
use App\Models\Adopcion;
use App\Models\InteresadoAdopcion;
use App\Models\Mascota;
use App\Models\SeguimientoAdopcion;
use App\Services\AuditoriaService;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

/**
 * Paquete P8: Gestión Integral de Adopciones y Control Post-Adopción
 * Casos de Uso:
 * - CU22: Formalizar Adopción de Mascota y Programación de Visitas
 */
class AdopcionController extends Controller
{
    public function index(): JsonResponse
    {
        $adopciones = Adopcion::query()
            ->with([
                'interesado:id,ci,nombre,telefono,direccion',
                'mascota:id,nombre,especie,raza,sexo,foto',
            ])
            ->orderByDesc('id')
            ->get();

        return response()->json(['adopciones' => $adopciones]);
    }

    public function store(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'id_interesado' => ['required', 'integer', 'exists:interesado_adopcions,id'],
            'id_mascota' => ['required', 'integer', 'exists:mascotas,id'],
            'fecha_adopcion' => ['required', 'date'],
        ]);

        $adopcion = DB::transaction(function () use ($request, $validated, $auditoria): Adopcion {
            $postulante = InteresadoAdopcion::lockForUpdate()->findOrFail($validated['id_interesado']);

            if ($postulante->estado !== 'Aprobado') {
                throw ValidationException::withMessages([
                    'id_interesado' => 'El postulante debe estar en estado Aprobado para formalizar la adopción.',
                ]);
            }

            $mascota = Mascota::lockForUpdate()->findOrFail($validated['id_mascota']);

            if ($mascota->estado_actual !== 'Disponible') {
                throw ValidationException::withMessages([
                    'id_mascota' => 'La mascota seleccionada no se encuentra disponible para adopción.',
                ]);
            }

            $adopcion = Adopcion::query()->create([
                'id_interesado' => $postulante->id,
                'id_mascota' => $mascota->id,
                'fecha_adopcion' => $validated['fecha_adopcion'],
            ]);

            // Actualizar estado de la mascota a 'Adoptado'
            $mascota->update(['estado_actual' => 'Adoptado']);

            // Programación automática de 3 visitas (30, 90 y 180 días) - CU22
            $fechaBase = Carbon::parse($validated['fecha_adopcion']);
            foreach ([30, 90, 180] as $dias) {
                SeguimientoAdopcion::query()->create([
                    'id_adopcion' => $adopcion->id,
                    'id_usuario' => $request->user()->getKey(),
                    'fecha_programada' => $fechaBase->copy()->addDays($dias)->toDateString(),
                    'estado_seguimiento' => 'Programado',
                    'reporte_bienestar' => "Control post-adopción programado a los {$dias} días.",
                    'fotografia' => '/images/default-check.png',
                ]);
            }

            $auditoria->registrar(
                $request,
                $request->user(),
                'Formalizar adopción y programar visitas',
                'adopciones',
                entidad: $adopcion,
                contexto: [
                    'adoptante' => $postulante->nombre,
                    'mascota' => $mascota->nombre,
                    'visitas_programadas' => 3,
                ],
            );

            return $adopcion;
        });

        return response()->json([
            'mensaje' => 'Adopción formalizada con éxito y 3 visitas de control programadas.',
            'adopcion' => $adopcion->load(['interesado', 'mascota']),
        ], 201);
    }

    public function show(Adopcion $adopcion): JsonResponse
    {
        return response()->json([
            'adopcion' => $adopcion->load(['interesado', 'mascota']),
        ]);
    }

    public function actaPdf(Adopcion $adopcion): JsonResponse
    {
        $adopcion->load(['interesado', 'mascota']);

        $actaData = [
            'numero_acta' => 'ACTA-ADOP-'.str_pad((string) $adopcion->id, 5, '0', STR_PAD_LEFT),
            'fecha' => $adopcion->fecha_adopcion,
            'albergue' => 'Los Angelitos de Edgar',
            'adoptante' => [
                'nombre' => $adopcion->interesado?->nombre,
                'ci' => $adopcion->interesado?->ci,
                'telefono' => $adopcion->interesado?->telefono,
                'direccion' => $adopcion->interesado?->direccion,
            ],
            'mascota' => [
                'nombre' => $adopcion->mascota?->nombre,
                'especie' => $adopcion->mascota?->especie,
                'raza' => $adopcion->mascota?->raza,
                'sexo' => $adopcion->mascota?->sexo,
            ],
            'compromiso' => 'El adoptante se compromete a brindar alimentación, cobijo, atención veterinaria y recibir las visitas de seguimiento a los 30, 90 y 180 días.',
        ];

        return response()->json(['acta' => $actaData]);
    }
}
