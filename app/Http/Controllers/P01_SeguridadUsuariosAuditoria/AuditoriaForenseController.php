<?php

namespace App\Http\Controllers\P01_SeguridadUsuariosAuditoria;

use App\Http\Controllers\Controller;
use App\Models\AuditoriaForense;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Paquete P12: Automatización Clínica y Seguridad Avanzada
 * - CU35: Auditoría Forense de Intentos de Acceso, Excepciones y Modificaciones Críticas
 */
class AuditoriaForenseController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        abort_unless($request->user()?->rol === 'Administrador', 403);

        $query = AuditoriaForense::query()
            ->with('usuario:id,nombre,email,rol')
            ->orderByDesc('fecha_evento')
            ->orderByDesc('id');

        if ($request->filled('severidad')) {
            $query->where('severidad', $request->string('severidad'));
        }

        if ($request->filled('modulo')) {
            $query->where('modulo', 'ilike', '%'.$request->string('modulo').'%');
        }

        if ($request->filled('fecha_desde')) {
            $query->whereDate('fecha_evento', '>=', $request->string('fecha_desde'));
        }

        if ($request->filled('fecha_hasta')) {
            $query->whereDate('fecha_evento', '<=', $request->string('fecha_hasta'));
        }

        $resumen = AuditoriaForense::query()
            ->select('severidad', DB::raw('COUNT(*) as total'))
            ->groupBy('severidad')
            ->pluck('total', 'severidad');

        return response()->json([
            'eventos' => $query->limit(150)->get(),
            'resumen_severidad' => $resumen,
        ]);
    }
}
