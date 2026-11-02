<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P8_Adopciones\SeguimientoAdopcionController as BaseSeguimientoAdopcionController;
use App\Models\Adopcion;
use App\Models\SeguimientoAdopcion;
use Illuminate\Database\Eloquent\Collection;

class SeguimientoAdopcionController extends BaseSeguimientoAdopcionController
{
    /**
     * programarCronogramaVisitas() : void
     */
    public function programarCronogramaVisitas(?int $idAdopcion = null): void
    {
        if ($idAdopcion) {
            $adopcion = Adopcion::query()->find($idAdopcion);
            if ($adopcion) {
                foreach ([30, 90, 180] as $dias) {
                    SeguimientoAdopcion::query()->create([
                        'id_adopcion' => $idAdopcion,
                        'fecha_programada' => now()->addDays($dias)->toDateString(),
                        'estado' => 'Pendiente',
                    ]);
                }
            }
        }
    }

    /**
     * registrarVisitaCumplida(reporte: String) : void
     */
    public function registrarVisitaCumplida(int $idSeguimiento, string $reporte): void
    {
        $seg = SeguimientoAdopcion::query()->find($idSeguimiento);
        if ($seg) {
            $seg->update([
                'fecha_realizada' => now()->toDateString(),
                'estado' => 'Concluido Satisfactorio',
                'reporte_bienestar' => $reporte,
            ]);
        }
    }

    /**
     * alertarVisitasPendientes() : List<SeguimientoAdopcion>
     */
    public function alertarVisitasPendientes(): Collection
    {
        return SeguimientoAdopcion::query()
            ->with(['adopcion.mascota', 'adopcion.interesado'])
            ->where('estado', 'Pendiente')
            ->whereDate('fecha_programada', '<=', now()->addDays(7))
            ->orderBy('fecha_programada')
            ->get();
    }
}
