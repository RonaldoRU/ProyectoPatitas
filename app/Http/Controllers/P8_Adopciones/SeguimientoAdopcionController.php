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
                'adopcion.interesado:id,nombre,telefono,direccion',
                'adopcion.mascota:id,nombre,especie,raza',
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

    public function update(
        Request $request,
        SeguimientoAdopcion $seguimiento,
        AuditoriaService $auditoria,
    ): JsonResponse {
        $validated = $request->validate([
            'fecha_realizada' => ['required', 'date'],
            'reporte_bienestar' => ['required', 'string', 'max:500'],
            'fotografia' => ['nullable', 'string', 'max:500'],
            'estado_seguimiento' => ['nullable', 'string', Rule::in(['Programado', 'Completado', 'Cancelado'])],
        ]);

        $validated['estado_seguimiento'] = $validated['estado_seguimiento'] ?? 'Completado';
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
            'seguimiento' => $seguimiento->load(['adopcion.interesado', 'adopcion.mascota']),
        ]);
    }
}
