<?php

namespace App\Http\Controllers\P8_Adopciones;

use App\Http\Controllers\Controller;
use App\Models\SeguimientoAdopcion;
use App\Services\AuditoriaService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

/**
 * Paquete P8: Gestión Integral de Adopciones y Control Post-Adopción
 * Casos de Uso:
 * - CU24: Consultar y Registrar Visitas de Seguimiento Post-Adopción
 */
class SeguimientoAdopcionController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = SeguimientoAdopcion::query()
            ->with([
                'adopcion.interesado:id,nombre,ci,telefono,direccion',
                'adopcion.mascota:id,nombre,especie,raza,sexo,foto',
                'usuario:id,nombre',
            ]);

        if ($request->filled('estado')) {
            $query->where('estado_seguimiento', $request->query('estado'));
        }

        if ($request->filled('mes')) {
            $mes = $request->query('mes'); // YYYY-MM
            $query->where('fecha_programada', 'like', "{$mes}%");
        }

        $seguimientos = $query->orderBy('fecha_programada')->get();

        return response()->json(['seguimientos' => $seguimientos]);
    }

    public function show(SeguimientoAdopcion $seguimiento): JsonResponse
    {
        return response()->json([
            'seguimiento' => $seguimiento->load([
                'adopcion.interesado:id,nombre,ci,telefono,direccion',
                'adopcion.mascota:id,nombre,especie,raza,sexo,foto',
                'usuario:id,nombre',
            ]),
        ]);
    }

    public function store(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'id_adopcion' => ['required', 'integer', 'exists:adopcions,id'],
            'fecha_programada' => ['required', 'date'],
            'fecha_realizada' => ['nullable', 'date'],
            'reporte_bienestar' => ['nullable', 'string', 'max:1000'],
            'fotografia' => ['nullable', 'string', 'max:500'],
            'estado_seguimiento' => ['nullable', 'string', Rule::in(['Programado', 'Pendiente', 'Completado', 'Concluido Satisfactorio', 'Cancelado'])],
        ]);

        $validated['id_usuario'] = $request->user()?->id ?? 1;
        $validated['estado_seguimiento'] = $validated['estado_seguimiento'] ?? ($request->filled('fecha_realizada') ? 'Concluido Satisfactorio' : 'Pendiente');
        $validated['reporte_bienestar'] = $validated['reporte_bienestar'] ?? 'Sin observaciones registradas';
        $validated['fotografia'] = $validated['fotografia'] ?? '/images/default-check.png';

        $seguimiento = DB::transaction(function () use ($request, $validated, $auditoria): SeguimientoAdopcion {
            $seg = SeguimientoAdopcion::create($validated);
            $auditoria->registrar(
                $request,
                $request->user(),
                'Programar visita de control post-adopción',
                'adopciones',
                entidad: $seg,
                contexto: [
                    'id_adopcion' => $seg->id_adopcion,
                    'fecha_programada' => $seg->fecha_programada,
                    'estado_seguimiento' => $seg->estado_seguimiento,
                ],
            );

            return $seg;
        });

        return response()->json([
            'mensaje' => 'Visita de seguimiento programada exitosamente.',
            'seguimiento' => $seguimiento->load(['adopcion.interesado', 'adopcion.mascota', 'usuario']),
        ], 201);
    }

    public function update(
        Request $request,
        SeguimientoAdopcion $seguimiento,
        AuditoriaService $auditoria,
    ): JsonResponse {
        $validated = $request->validate([
            'fecha_realizada' => ['required', 'date'],
            'reporte_bienestar' => ['required', 'string', 'max:1000'],
            'fotografia' => ['nullable', 'string', 'max:500'],
            'estado_seguimiento' => ['nullable', 'string', Rule::in(['Programado', 'Pendiente', 'Completado', 'Concluido Satisfactorio', 'Cancelado'])],
        ]);

        $validated['estado_seguimiento'] = $validated['estado_seguimiento'] ?? 'Concluido Satisfactorio';
        $validated['fotografia'] = $validated['fotografia'] ?? $seguimiento->fotografia ?? '/images/default-check.png';

        DB::transaction(function () use ($request, $seguimiento, $validated, $auditoria): void {
            $seguimiento->update($validated);
            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar visita de control post-adopción',
                'adopciones',
                entidad: $seguimiento,
                contexto: [
                    'id_adopcion' => $seguimiento->id_adopcion,
                    'estado_seguimiento' => $seguimiento->estado_seguimiento,
                    'fecha_realizada' => $seguimiento->fecha_realizada,
                ],
            );
        });

        return response()->json([
            'mensaje' => 'Visita de seguimiento registrada exitosamente.',
            'seguimiento' => $seguimiento->load(['adopcion.interesado', 'adopcion.mascota', 'usuario']),
        ]);
    }
}
