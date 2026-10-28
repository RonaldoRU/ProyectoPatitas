<?php

namespace App\Http\Controllers\P5_Abastecimiento;

use App\Http\Controllers\Controller;
use App\Models\DetalleCompra;
use Illuminate\Http\JsonResponse;

class DetalleCompraController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(['detalles' => DetalleCompra::with('articulo')->get()]);
    }
}
