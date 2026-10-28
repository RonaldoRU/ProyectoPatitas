<?php

namespace App\Http\Controllers\P9_PagosDonaciones;

use App\Http\Controllers\Controller;
use App\Models\TipoAporte;
use Illuminate\Http\JsonResponse;

class TipoAporteController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(['tipos' => TipoAporte::all()]);
    }
}
