<?php

namespace App\Http\Controllers\P03_RescateClinicaAdopciones;

use App\Http\Controllers\Controller;
use App\Models\ArticuloInventario;
use App\Models\CronogramaTratamiento;
use App\Models\InventarioLote;
use App\Models\Mascota;
use App\Models\PrescripcionDosificacion;
use App\Services\AuditoriaForenseService;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * Paquete P12: Automatización Clínica y Seguridad Avanzada
 * - CU34: Ejecutar Dosificación Automática y Programación de Tratamientos Veterinarios
 */
class PrescripcionDosificacionController extends Controller
{
    public function catalogos(Request $request): JsonResponse
    {
        abort_unless(in_array($request->user()?->rol, ['Administrador', 'Veterinario'], true), 403);

        return response()->json([
            'mascotas' => Mascota::query()->select('id', 'nombre', 'especie', 'raza', 'estado_actual')->orderBy('nombre')->get(),
            'articulos' => ArticuloInventario::query()
                ->select('id', 'nombre', 'categoria', 'unidad_medida', 'stock_actual')
                ->where('stock_actual', '>', 0)
                ->orderBy('nombre')
                ->get(),
        ]);
    }

    public function index(Request $request): JsonResponse
    {
        abort_unless(in_array($request->user()?->rol, ['Administrador', 'Veterinario'], true), 403);

        $prescripciones = PrescripcionDosificacion::query()
            ->with([
                'mascota:id,nombre,especie',
                'articulo:id,nombre,unidad_medida',
                'veterinario:id,nombre',
                'cronograma' => fn ($q) => $q->with('lote:id,fecha_vencimiento,cantidad_disponible')->orderBy('fecha_hora_programada'),
            ])
            ->orderByDesc('id')
            ->limit(50)
            ->get();

        return response()->json([
            'prescripciones' => $prescripciones,
        ]);
    }

    public function store(Request $request, AuditoriaForenseService $auditoria): JsonResponse
    {
        abort_unless(in_array($request->user()?->rol, ['Administrador', 'Veterinario'], true), 403);

        $validated = $request->validate([
            'mascota_id' => ['required', 'integer', 'exists:mascotas,id'],
            'articulo_id' => ['required', 'integer', 'exists:articulo_inventarios,id'],
            'peso_mascota_kg' => ['required', 'numeric', 'gt:0', 'max:200'],
            'dosis_mg_kg' => ['required', 'numeric', 'gt:0', 'max:500'],
            'concentracion_farmaco' => ['required', 'numeric', 'gt:0'],
            'unidad_medida' => ['required', 'string', 'max:20'],
            'frecuencia_horas' => ['required', 'integer', 'in:4,6,8,12,24,48'],
            'duracion_dias' => ['required', 'integer', 'min:1', 'max:60'],
            'observaciones_clinicas' => ['nullable', 'string', 'max:1000'],
        ]);

        $dosisCalculada = round(
            ((float) $validated['peso_mascota_kg'] * (float) $validated['dosis_mg_kg']) / (float) $validated['concentracion_farmaco'],
            3
        );

        $prescripcion = DB::transaction(function () use ($validated, $dosisCalculada, $request, $auditoria): PrescripcionDosificacion {
            $prescripcion = PrescripcionDosificacion::query()->create([
                'mascota_id' => $validated['mascota_id'],
                'articulo_id' => $validated['articulo_id'],
                'veterinario_id' => $request->user()->id,
                'peso_mascota_kg' => $validated['peso_mascota_kg'],
                'dosis_mg_kg' => $validated['dosis_mg_kg'],
                'concentracion_farmaco' => $validated['concentracion_farmaco'],
                'dosis_calculada_unidad' => $dosisCalculada,
                'unidad_medida' => trim($validated['unidad_medida']),
                'frecuencia_horas' => (int) $validated['frecuencia_horas'],
                'duracion_dias' => (int) $validated['duracion_dias'],
                'observaciones_clinicas' => $validated['observaciones_clinicas'] ?? null,
                'estado' => 'ACTIVO',
            ]);

            $loteFefo = InventarioLote::query()
                ->where('id_articulo', $validated['articulo_id'])
                ->where('cantidad_disponible', '>', 0)
                ->orderByRaw('fecha_vencimiento IS NULL ASC, fecha_vencimiento ASC')
                ->first();

            $totalTomas = max(1, (int) floor(((int) $validated['duracion_dias'] * 24) / (int) $validated['frecuencia_horas']));
            $inicio = Carbon::now();

            for ($i = 0; $i < $totalTomas; $i++) {
                CronogramaTratamiento::query()->create([
                    'prescripcion_id' => $prescripcion->id,
                    'lote_inventario_id' => $loteFefo?->id,
                    'fecha_hora_programada' => $inicio->copy()->addHours($i * (int) $validated['frecuencia_horas']),
                    'estado' => 'PENDIENTE',
                ]);
            }

            $auditoria->registrar(
                $request,
                'INFO',
                'P12_ControlClinicoSeguridad',
                'CREAR_DOSIFICACION_CLINICA',
                'prescripciones_dosificacion',
                $prescripcion->id,
                null,
                [
                    'mascota_id' => $prescripcion->mascota_id,
                    'dosis_calculada' => $dosisCalculada,
                    'tomas_programadas' => $totalTomas,
                ]
            );

            return $prescripcion->load([
                'mascota:id,nombre,especie',
                'articulo:id,nombre,unidad_medida',
                'veterinario:id,nombre',
                'cronograma.lote:id,fecha_vencimiento,cantidad_disponible',
            ]);
        });

        return response()->json([
            'mensaje' => 'Prescripción calculada y cronograma FEFO generado correctamente.',
            'prescripcion' => $prescripcion,
        ], 201);
    }

    public function marcarToma(Request $request, CronogramaTratamiento $toma, AuditoriaForenseService $auditoria): JsonResponse
    {
        abort_unless(in_array($request->user()?->rol, ['Administrador', 'Veterinario'], true), 403);

        $validated = $request->validate([
            'estado' => ['required', 'in:ADMINISTRADO,OMITIDO'],
            'notas' => ['nullable', 'string', 'max:500'],
        ]);

        $toma->update([
            'estado' => $validated['estado'],
            'fecha_hora_administrada' => $validated['estado'] === 'ADMINISTRADO' ? now() : null,
            'administrado_por' => $request->user()->id,
            'notas' => $validated['notas'] ?? null,
        ]);

        $auditoria->registrar(
            $request,
            'INFO',
            'P12_ControlClinicoSeguridad',
            'REGISTRAR_TOMA_TRATAMIENTO',
            'cronograma_tratamientos',
            $toma->id,
            null,
            ['estado' => $validated['estado']]
        );

        return response()->json([
            'mensaje' => 'Toma de tratamiento actualizada.',
            'toma' => $toma,
        ]);
    }
}
