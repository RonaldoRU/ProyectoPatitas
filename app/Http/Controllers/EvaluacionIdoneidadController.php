<?php

namespace App\Http\Controllers;

use App\Models\EvaluacionIdoneidad;
use App\Models\InteresadoAdopcion;
use Illuminate\Http\JsonResponse;

class EvaluacionIdoneidadController extends Controller
{
    /**
     * calcularCalificacionVivienda() : Int
     */
    public function calcularCalificacionVivienda(int $idInteresado): int
    {
        $interesado = InteresadoAdopcion::query()->find($idInteresado);
        if (! $interesado) {
            return 0;
        }

        $calificacion = 50;
        if (str_contains(strtolower($interesado->vivienda ?? ''), 'propia') || str_contains(strtolower($interesado->direccion ?? ''), 'casa')) {
            $calificacion += 30;
        }
        if (str_contains(strtolower($interesado->observaciones ?? ''), 'patio')) {
            $calificacion += 20;
        }

        return min(100, $calificacion);
    }

    /**
     * emitirDictamenAprobacion() : Boolean
     */
    public function emitirDictamenAprobacion(int $idEvaluacion): bool
    {
        $evaluacion = EvaluacionIdoneidad::query()->find($idEvaluacion);
        if (! $evaluacion) {
            return false;
        }

        $aprobado = ($evaluacion->puntaje_total >= 70);
        $evaluacion->update([
            'resultado' => $aprobado ? 'Aprobado' : 'Rechazado',
        ]);

        return $aprobado;
    }

    public function index(): JsonResponse
    {
        $evaluaciones = EvaluacionIdoneidad::query()
            ->with('interesado')
            ->orderByDesc('created_at')
            ->get();

        return response()->json(['evaluaciones' => $evaluaciones]);
    }
}
