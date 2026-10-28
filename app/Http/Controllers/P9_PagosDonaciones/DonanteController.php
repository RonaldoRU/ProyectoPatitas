<?php

namespace App\Http\Controllers\P9_PagosDonaciones;

use App\Http\Controllers\Controller;
use App\Models\Donante;
use App\Services\AuditoriaService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * Paquete P9: Pasarela de Pagos, Donaciones Monetarias y Recibos Digitales
 */
class DonanteController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'donantes' => Donante::query()->orderBy('nombre')->get(),
        ]);
    }

    public function store(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'nombre' => ['required', 'string', 'max:255'],
            'telefono' => ['required', 'string', 'max:50'],
            'tipo_persona' => ['required', 'string', 'max:50'],
        ]);

        $donante = Donante::query()->create($validated);

        $auditoria->registrar(
            $request,
            $request->user(),
            'Registrar donante',
            'donaciones',
            entidad: $donante,
        );

        return response()->json(['donante' => $donante], 201);
    }

    public function search(Request $request): JsonResponse
    {
        $term = $request->query('q', '');
        $donantes = Donante::query()
            ->where('nombre', 'like', "%{$term}%")
            ->orWhere('telefono', 'like', "%{$term}%")
            ->limit(10)
            ->get();

        return response()->json(['donantes' => $donantes]);
    }
}
