<?php

namespace App\Http\Controllers;

use App\Models\AlertaInventario;
use App\Models\ArticuloInventario;
use Illuminate\Http\JsonResponse;

class AlertaInventarioController extends Controller
{
    /**
     * generarAlertaCritica(idArticulo: Int) : void
     */
    public function generarAlertaCritica(int $idArticulo): void
    {
        $articulo = ArticuloInventario::query()->find($idArticulo);
        if ($articulo) {
            AlertaInventario::query()->create([
                'id_articulo' => $idArticulo,
                'nivel_criticidad' => 'Critico',
                'estado' => 'Pendiente',
                'fecha_generada' => now(),
            ]);
        }
    }

    /**
     * listarAlertasActivas() : List<AlertaInventario>
     */
    public function listarAlertasActivas(): JsonResponse
    {
        $alertas = AlertaInventario::query()
            ->with('articulo')
            ->where('estado', 'Pendiente')
            ->orderByDesc('fecha_generada')
            ->get();

        return response()->json([
            'alertas' => $alertas,
        ]);
    }

    public function index(): JsonResponse
    {
        return $this->listarAlertasActivas();
    }
}
