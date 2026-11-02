<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P9_PagosDonaciones\AporteDineroController as BaseAporteDineroController;
use App\Models\AporteDinero;

class AporteDineroController extends BaseAporteDineroController
{
    /**
     * registrarPagoPasarela() : void
     */
    public function registrarPagoPasarela(array $datos): AporteDinero
    {
        return AporteDinero::query()->create($datos);
    }

    /**
     * confirmarAcreditacion(referencia: String) : void
     */
    public function confirmarAcreditacion(string $referencia): void
    {
        $aporte = AporteDinero::query()->where('numero_transaccion', $referencia)->first();
        if ($aporte) {
            $aporte->update([
                'estado' => 'Confirmado',
            ]);
        }
    }

    /**
     * procesarReembolso(motivo: String) : Boolean
     */
    public function procesarReembolso(int $idAporte, string $motivo): bool
    {
        $aporte = AporteDinero::query()->find($idAporte);
        if ($aporte && $aporte->estado === 'Confirmado') {
            $aporte->update([
                'estado' => 'Reembolsado',
            ]);

            return true;
        }

        return false;
    }
}
