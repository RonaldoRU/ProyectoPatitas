<?php

namespace App\Http\Controllers\P05_FacturacionReportes;

use App\Http\Controllers\Controller;
use App\Models\DosificacionFiscal;
use App\Services\AuditoriaForenseService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Paquete P11: Facturación Legal y Normativa Tributaria
 * - CU31: Administrar Parámetros de Dosificación y Autorización de Facturación Legal
 */
class DosificacionFiscalController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        abort_unless(in_array($request->user()?->rol, ['Administrador', 'Recepcionista'], true), 403);

        $dosificaciones = DosificacionFiscal::query()
            ->with('creador:id,nombre')
            ->orderByDesc('activa')
            ->orderByDesc('id')
            ->get();

        return response()->json([
            'dosificaciones' => $dosificaciones,
            'activa' => $dosificaciones->firstWhere('activa', true),
        ]);
    }

    public function store(Request $request, AuditoriaForenseService $auditoria): JsonResponse
    {
        abort_unless(in_array($request->user()?->rol, ['Administrador', 'Recepcionista'], true), 403);

        $validated = $request->validate([
            'nit_emisor' => ['required', 'string', 'max:20'],
            'numero_autorizacion' => ['required', 'string', 'max:50', 'unique:dosificaciones_fiscales,numero_autorizacion'],
            'llave_dosificacion' => ['required', 'string', 'min:10'],
            'numero_inicial' => ['required', 'integer', 'min:1'],
            'numero_final' => ['required', 'integer', 'gte:numero_inicial'],
            'fecha_limite_emision' => ['required', 'date', 'after:today'],
            'leyenda_tributaria' => ['required', 'string', 'max:500'],
        ]);

        $dosificacion = DB::transaction(function () use ($validated, $request, $auditoria): DosificacionFiscal {
            DosificacionFiscal::query()->where('activa', true)->update(['activa' => false]);

            $nueva = DosificacionFiscal::query()->create([
                'nit_emisor' => trim($validated['nit_emisor']),
                'numero_autorizacion' => trim($validated['numero_autorizacion']),
                'llave_dosificacion' => trim($validated['llave_dosificacion']),
                'numero_inicial' => (int) $validated['numero_inicial'],
                'numero_final' => (int) $validated['numero_final'],
                'correlativo_actual' => (int) $validated['numero_inicial'],
                'fecha_limite_emision' => $validated['fecha_limite_emision'],
                'leyenda_tributaria' => trim($validated['leyenda_tributaria']),
                'activa' => true,
                'created_by' => $request->user()?->id,
            ]);

            $auditoria->registrar(
                $request,
                'INFO',
                'P11_FacturacionLegal',
                'CREAR_DOSIFICACION',
                'dosificaciones_fiscales',
                $nueva->id,
                null,
                [
                    'numero_autorizacion' => $nueva->numero_autorizacion,
                    'rango' => "{$nueva->numero_inicial}-{$nueva->numero_final}",
                    'fecha_limite_emision' => $nueva->fecha_limite_emision?->toDateString(),
                ]
            );

            return $nueva;
        });

        return response()->json([
            'mensaje' => 'Parámetros de dosificación registrados y activados correctamente.',
            'dosificacion' => $dosificacion,
        ], 201);
    }
}
