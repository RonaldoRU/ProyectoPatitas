<?php

namespace App\Http\Controllers;

use App\Models\ExpedienteDigital;
use Illuminate\Http\JsonResponse;

class ExpedienteDigitalController extends Controller
{
    /**
     * crearExpedienteInicial(idMascota: Int) : void
     */
    public function crearExpedienteInicial(int $idMascota): void
    {
        $nro = 'EXP-'.str_pad((string) $idMascota, 5, '0', STR_PAD_LEFT);
        ExpedienteDigital::query()->firstOrCreate(
            ['id_mascota' => $idMascota],
            [
                'nro_expediente' => $nro,
                'estado_clinico' => 'Inicial',
                'fecha_apertura' => now()->toDateString(),
                'created_at' => now(),
            ]
        );
    }

    /**
     * adjuntarDocumento(tipo: String, ruta: String) : void
     */
    public function adjuntarDocumento(string $tipo, string $ruta, ?string $nroExpediente = null): void
    {
        if ($nroExpediente) {
            $exp = ExpedienteDigital::query()->find($nroExpediente);
            if ($exp) {
                $exp->update([
                    'estado_clinico' => 'Actualizado: '.$tipo,
                ]);
            }
        }
    }

    public function show(string $nroExpediente): JsonResponse
    {
        $exp = ExpedienteDigital::query()->with('mascota')->findOrFail($nroExpediente);

        return response()->json(['expediente' => $exp]);
    }
}
