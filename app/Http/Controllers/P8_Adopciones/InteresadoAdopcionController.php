<?php

namespace App\Http\Controllers\P8_Adopciones;

use App\Http\Controllers\Controller;
use App\Models\InteresadoAdopcion;
use Illuminate\Http\JsonResponse;

class InteresadoAdopcionController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(['interesados' => InteresadoAdopcion::orderBy('nombre')->get()]);
    }
}
