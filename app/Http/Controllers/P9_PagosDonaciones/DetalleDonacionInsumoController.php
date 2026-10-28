<?php

namespace App\Http\Controllers\P9_PagosDonaciones;

use App\Http\Controllers\Controller;
use App\Models\DetalleDonacionInsumo;
use Illuminate\Http\JsonResponse;

class DetalleDonacionInsumoController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(['detalles' => DetalleDonacionInsumo::with('articulo')->get()]);
    }
}
