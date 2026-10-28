<?php

namespace App\Http\Controllers\P9_PagosDonaciones;

use App\Http\Controllers\Controller;
use App\Models\AporteDinero;
use Illuminate\Http\JsonResponse;

class AporteDineroController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'aportes' => AporteDinero::with('donacion.donante')->orderByDesc('fecha_recepcion')->get(),
        ]);
    }

    public function show(AporteDinero $aporteDinero): JsonResponse
    {
        return response()->json(['aporte' => $aporteDinero->load('donacion.donante')]);
    }
}
