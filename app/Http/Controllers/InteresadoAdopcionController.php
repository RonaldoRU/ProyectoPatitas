<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P8_Adopciones\InteresadoAdopcionController as BaseInteresadoAdopcionController;
use App\Models\InteresadoAdopcion;

class InteresadoAdopcionController extends BaseInteresadoAdopcionController
{
    /**
     * registrarPostulante() : Int
     */
    public function registrarPostulante(array $datos): int
    {
        $postulante = InteresadoAdopcion::query()->create($datos);

        return $postulante->id;
    }

    /**
     * calcularScoringAdopcion() : Int
     */
    public function calcularScoringAdopcion(int $idInteresado): int
    {
        $postulante = InteresadoAdopcion::query()->find($idInteresado);
        if (! $postulante) {
            return 0;
        }

        $score = 60;
        if ($postulante->telefono) {
            $score += 15;
        }
        if ($postulante->direccion) {
            $score += 15;
        }
        if ($postulante->estado === 'Aprobado') {
            $score += 10;
        }

        return min(100, $score);
    }

    /**
     * verificarAprobacion() : Boolean
     */
    public function verificarAprobacion(int $idInteresado): bool
    {
        $postulante = InteresadoAdopcion::query()->find($idInteresado);

        return $postulante && $postulante->estado === 'Aprobado';
    }
}
