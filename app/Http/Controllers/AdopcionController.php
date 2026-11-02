<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P8_Adopciones\AdopcionController as BaseAdopcionController;
use App\Models\Adopcion;

class AdopcionController extends BaseAdopcionController
{
    /**
     * crearRegistroAdopcion() : Int
     */
    public function crearRegistroAdopcion(array $datos): int
    {
        $adopcion = Adopcion::query()->create($datos);

        return $adopcion->id;
    }

    /**
     * generarContratoAdopcionPDF() : void
     */
    public function generarContratoAdopcionPDF(int $idAdopcion): string
    {
        $adopcion = Adopcion::query()->with(['mascota', 'interesado'])->findOrFail($idAdopcion);

        return "CONTRATO-ADOPCION-{$adopcion->id}.pdf";
    }

    /**
     * consultarHistorialAdopcion() : Adopcion
     */
    public function consultarHistorialAdopcion(int $idAdopcion): ?Adopcion
    {
        return Adopcion::query()->with(['mascota', 'interesado', 'seguimientos'])->find($idAdopcion);
    }
}
