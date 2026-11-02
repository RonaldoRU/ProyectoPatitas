<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P7_RescateClinico\HistorialClinicoController as BaseHistorialClinicoController;
use App\Models\HistorialClinico;
use Illuminate\Database\Eloquent\Collection;

class HistorialClinicoController extends BaseHistorialClinicoController
{
    /**
     * registrarConsultaMedica() : void
     */
    public function registrarConsultaMedica(int $idMascota, string $diagnostico, ?string $tratamiento = null, ?float $peso = null, ?float $temperatura = null): HistorialClinico
    {
        return HistorialClinico::query()->create([
            'id_mascota' => $idMascota,
            'id_veterinario' => auth()->id() ?? 1,
            'fecha_atencion' => now(),
            'diagnostico' => $diagnostico,
            'tratamiento' => $tratamiento,
            'peso' => $peso,
            'temperatura' => $temperatura,
        ]);
    }

    /**
     * aplicarTratamiento(farma: String, dosis: String) : void
     */
    public function aplicarTratamiento(int $idHistorial, string $farma, string $dosis): void
    {
        $historial = HistorialClinico::query()->find($idHistorial);
        if ($historial) {
            $desc = trim(($historial->tratamiento ?? '')."\n".'Fármaco: '.$farma.' | Dosis: '.$dosis);
            $historial->update(['tratamiento' => $desc]);
        }
    }

    /**
     * obtenerHistorialMascota(idMascota: Int) : List<HistorialClinico>
     */
    public function obtenerHistorialMascota(int $idMascota): Collection
    {
        return HistorialClinico::query()
            ->where('id_mascota', $idMascota)
            ->orderByDesc('fecha_atencion')
            ->get();
    }
}
