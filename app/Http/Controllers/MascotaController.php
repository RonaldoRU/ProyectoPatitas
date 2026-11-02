<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P7_RescateClinico\MascotaController as BaseMascotaController;
use App\Models\Mascota;

class MascotaController extends BaseMascotaController
{
    /**
     * registrarIngreso() : Int
     */
    public function registrarIngreso(array $datos): int
    {
        $mascota = Mascota::query()->create($datos);

        return $mascota->id;
    }

    /**
     * actualizarEstado(nuevoEstado: String) : void
     */
    public function actualizarEstado(int $idMascota, string $nuevoEstado): void
    {
        $mascota = Mascota::query()->find($idMascota);
        if ($mascota) {
            $mascota->update(['estado' => $nuevoEstado]);
        }
    }

    /**
     * validarDisponibilidadAdopcion() : Boolean
     */
    public function validarDisponibilidadAdopcion(int $idMascota): bool
    {
        $mascota = Mascota::query()->find($idMascota);

        return $mascota && $mascota->estado === 'Disponible';
    }

    /**
     * obtenerFichaClinica() : Mascota
     */
    public function obtenerFichaClinica(int $idMascota): ?Mascota
    {
        return Mascota::query()->with('historialClinicos')->find($idMascota);
    }
}
