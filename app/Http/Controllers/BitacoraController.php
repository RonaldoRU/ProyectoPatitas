<?php

namespace App\Http\Controllers;

use App\Http\Controllers\P3_Auditoria\BitacoraController as BaseBitacoraController;
use App\Models\Bitacora;
use Illuminate\Database\Eloquent\Collection;

class BitacoraController extends BaseBitacoraController
{
    /**
     * registrarAccion(idUser: Int, accion: String) : void
     */
    public function registrarAccion(int $idUser, string $accion, string $tabla = 'general', ?int $registroId = null): void
    {
        Bitacora::query()->create([
            'id_usuario' => $idUser,
            'accion' => $accion,
            'tabla' => $tabla,
            'registro_id' => $registroId,
            'ip' => request()->ip() ?? '127.0.0.1',
            'created_at' => now(),
        ]);
    }

    /**
     * filtrarPorFecha(desde: Date, hasta: Date) : List<Bitacora>
     */
    public function filtrarPorFecha(string $desde, string $hasta): Collection
    {
        return Bitacora::query()
            ->whereDate('created_at', '>=', $desde)
            ->whereDate('created_at', '<=', $hasta)
            ->orderByDesc('created_at')
            ->get();
    }

    /**
     * consultarHistorialUsuario(idUser: Int) : List<Bitacora>
     */
    public function consultarHistorialUsuario(int $idUser): Collection
    {
        return Bitacora::query()
            ->where('id_usuario', $idUser)
            ->orderByDesc('created_at')
            ->get();
    }
}
