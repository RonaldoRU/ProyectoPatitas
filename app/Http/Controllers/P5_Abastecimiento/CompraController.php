<?php

namespace App\Http\Controllers\P5_Abastecimiento;

use App\Http\Controllers\Controller;
use App\Models\Compra;
use Illuminate\Http\JsonResponse;

class CompraController extends Controller
{
    public function index(): JsonResponse
    {
        $compras = Compra::with(['proveedor', 'detalles.articulo'])->orderByDesc('fecha_compra')->get();

        return response()->json(['compras' => $compras]);
    }

    public function show(Compra $compra): JsonResponse
    {
        return response()->json(['compra' => $compra->load(['proveedor', 'detalles.articulo'])]);
    }
}
