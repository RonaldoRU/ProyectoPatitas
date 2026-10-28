<?php

namespace App\Http\Controllers\P5_Abastecimiento;

use App\Http\Controllers\Controller;
use App\Models\DetalleSalida;
use Illuminate\Http\JsonResponse;

class DetalleSalidaController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(['detalles' => DetalleSalida::with('articulo')->get()]);
    }
}
