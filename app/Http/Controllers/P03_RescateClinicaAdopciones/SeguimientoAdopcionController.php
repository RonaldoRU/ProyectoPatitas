<?php

namespace App\Http\Controllers\P03_RescateClinicaAdopciones;

use App\Http\Controllers\Controller;
use App\Models\SeguimientoAdopcion;
use App\Services\AuditoriaService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\File;
use Illuminate\Validation\Rule;

/**
 * Paquete P03: Gestión Integral de Adopciones y Control Post-Adopción
 * Casos de Uso:
 * - CU23: Consultar Agenda y Registrar Visita de Seguimiento Post-Adopción (con subida de fotografías de la visita)
 */
class SeguimientoAdopcionController extends Controller
{
    private const ESTADOS_PERMITIDOS = [
        'Programado',
        'Pendiente',
        'Completado',
        'Concluido Satisfactorio',
        'Cancelado',
        'Alerta',
        'Incumplido',
    ];

    /**
     * CU23: Consultar Agenda de Visitas de Seguimiento (Todas, Pendientes o Completadas)
     */
    public function index(Request $request): JsonResponse
    {
        $query = SeguimientoAdopcion::query()
            ->with([
                'adopcion.mascota:id,nombre,especie,raza,sexo,foto',
                'adopcion.interesado:id,nombre,ci,telefono,direccion',
                'usuario:id,nombre',
            ])
            ->orderBy('fecha_programada');

        if ($request->filled('estado')) {
            $query->where('estado_seguimiento', $request->query('estado'));
        }

        if ($request->filled('id_adopcion')) {
            $query->where('id_adopcion', $request->query('id_adopcion'));
        }

        return response()->json([
            'seguimientos' => $query->get(),
        ]);
    }

    /**
     * CU23: Programar o Registrar una Nueva Visita de Seguimiento Post-Adopción (soporta subida de imágenes)
     */
    public function store(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'id_adopcion' => ['required', 'integer', 'exists:adopcions,id'],
            'fecha_programada' => ['required', 'date'],
            'fecha_realizada' => ['nullable', 'date'],
            'estado_seguimiento' => ['nullable', Rule::in(self::ESTADOS_PERMITIDOS)],
            'reporte_bienestar' => ['nullable', 'string', 'max:5000'],
            'fotografia' => ['nullable', 'string', 'max:10000'],
            'imagenes' => ['nullable', 'array'],
            'imagenes.*' => ['nullable', 'file', 'image', 'max:10240'],
            'foto_archivo' => ['nullable', 'file', 'image', 'max:10240'],
            'imagenes_base64' => ['nullable', 'array'],
            'imagenes_base64.*' => ['nullable', 'string'],
        ]);

        $rutaFotografias = $this->procesarImagenesVisita($request, $validated['fotografia'] ?? null);

        $seguimiento = SeguimientoAdopcion::query()->create([
            'id_adopcion' => $validated['id_adopcion'],
            'id_usuario' => $request->user()?->getKey() ?? 1,
            'fecha_programada' => $validated['fecha_programada'],
            'fecha_realizada' => ! empty($validated['fecha_realizada']) ? $validated['fecha_realizada'] : null,
            'estado_seguimiento' => $validated['estado_seguimiento'] ?? 'Pendiente',
            'reporte_bienestar' => $validated['reporte_bienestar'] ?? 'Visita de seguimiento programada.',
            'fotografia' => $rutaFotografias,
        ]);

        $auditoria->registrar(
            $request,
            $request->user(),
            'Programar visita de seguimiento post-adopción',
            'seguimiento_adopciones',
            entidad: $seguimiento,
        );

        return response()->json([
            'mensaje' => 'Visita de seguimiento registrada correctamente.',
            'seguimiento' => $seguimiento->load(['adopcion.mascota', 'adopcion.interesado', 'usuario:id,nombre']),
        ], 201);
    }

    /**
     * CU23: Registrar Ejecución / Completar Visita de Seguimiento Post-Adopción (con subida de imágenes del animal)
     */
    public function update(Request $request, SeguimientoAdopcion $seguimiento, AuditoriaService $auditoria): JsonResponse
    {
        $validated = $request->validate([
            'fecha_realizada' => ['required', 'date'],
            'reporte_bienestar' => ['required', 'string', 'max:5000'],
            'fotografia' => ['nullable', 'string', 'max:10000'],
            'estado_seguimiento' => ['required', Rule::in(self::ESTADOS_PERMITIDOS)],
            'imagenes' => ['nullable', 'array'],
            'imagenes.*' => ['nullable', 'file', 'image', 'max:10240'],
            'foto_archivo' => ['nullable', 'file', 'image', 'max:10240'],
            'imagenes_base64' => ['nullable', 'array'],
            'imagenes_base64.*' => ['nullable', 'string'],
        ]);

        $rutaFotografias = $this->procesarImagenesVisita(
            $request,
            $validated['fotografia'] ?? $seguimiento->fotografia
        );

        $seguimiento->update([
            'fecha_realizada' => $validated['fecha_realizada'],
            'reporte_bienestar' => $validated['reporte_bienestar'],
            'fotografia' => $rutaFotografias,
            'estado_seguimiento' => $validated['estado_seguimiento'],
            'id_usuario' => $request->user()?->getKey() ?? $seguimiento->id_usuario,
        ]);

        $auditoria->registrar(
            $request,
            $request->user(),
            'Registrar visita de seguimiento post-adopción',
            'seguimiento_adopciones',
            entidad: $seguimiento,
            contexto: [
                'estado' => $seguimiento->estado_seguimiento,
                'fecha_realizada' => $seguimiento->fecha_realizada,
                'fotografia' => $seguimiento->fotografia,
            ],
        );

        return response()->json([
            'mensaje' => 'Visita de seguimiento registrada con éxito.',
            'seguimiento' => $seguimiento->load(['adopcion.mascota', 'adopcion.interesado', 'usuario:id,nombre']),
        ]);
    }

    /**
     * CU23: Consultar Detalle de una Visita de Seguimiento Específica
     */
    public function show(SeguimientoAdopcion $seguimiento): JsonResponse
    {
        return response()->json([
            'seguimiento' => $seguimiento->load([
                'adopcion.mascota:id,nombre,especie,raza,sexo,foto',
                'adopcion.interesado:id,nombre,ci,telefono,direccion',
                'usuario:id,nombre',
            ]),
        ]);
    }

    /**
     * Procesa archivos de imagen subidos (multipart/form-data) o en base64 y retorna las rutas públicas separadas por '|'.
     */
    private function procesarImagenesVisita(Request $request, ?string $fotografiaTexto = null): string
    {
        $directorioRelativo = 'uploads/visitas';
        $directorioAbsoluto = public_path($directorioRelativo);

        if (! File::exists($directorioAbsoluto)) {
            File::makeDirectory($directorioAbsoluto, 0755, true);
        }

        $rutasGuardadas = [];

        // 1. Procesar archivos subidos en 'imagenes[]' o 'foto_archivo'
        $archivos = [];
        if ($request->hasFile('imagenes')) {
            $files = $request->file('imagenes');
            $archivos = is_array($files) ? $files : [$files];
        }
        if ($request->hasFile('foto_archivo')) {
            $archivos[] = $request->file('foto_archivo');
        }

        foreach ($archivos as $idx => $archivo) {
            if ($archivo instanceof UploadedFile && $archivo->isValid()) {
                $ext = strtolower($archivo->getClientOriginalExtension() ?: 'jpg');
                if (! in_array($ext, ['jpg', 'jpeg', 'png', 'webp', 'gif'], true)) {
                    $ext = 'jpg';
                }
                $nombreArchivo = 'visita_'.now()->format('Ymd_His').'_'.uniqid().'_'.$idx.'.'.$ext;
                $archivo->move($directorioAbsoluto, $nombreArchivo);
                $rutasGuardadas[] = '/'.$directorioRelativo.'/'.$nombreArchivo;
            }
        }

        // 2. Procesar imágenes enviadas en base64 ('imagenes_base64[]')
        $imagenesBase64 = $request->input('imagenes_base64', []);
        if (is_array($imagenesBase64)) {
            foreach ($imagenesBase64 as $idx => $b64) {
                if (is_string($b64) && preg_match('/^data:image\/(\w+);base64,/', $b64, $matches)) {
                    $ext = strtolower($matches[1]);
                    if ($ext === 'jpeg') {
                        $ext = 'jpg';
                    }
                    $data = base64_decode(substr($b64, strpos($b64, ',') + 1), true);
                    if ($data !== false) {
                        $nombreArchivo = 'visita_'.now()->format('Ymd_His').'_'.uniqid().'_b'.$idx.'.'.$ext;
                        File::put($directorioAbsoluto.DIRECTORY_SEPARATOR.$nombreArchivo, $data);
                        $rutasGuardadas[] = '/'.$directorioRelativo.'/'.$nombreArchivo;
                    }
                }
            }
        }

        // 3. Conservar URLs previas o manuales válidas si fueron enviadas
        if (is_string($fotografiaTexto) && trim($fotografiaTexto) !== '') {
            $partes = array_filter(array_map('trim', explode('|', $fotografiaTexto)));
            foreach ($partes as $parte) {
                if (preg_match('/^data:image\/(\w+);base64,/', $parte, $matches)) {
                    $ext = strtolower($matches[1]) === 'jpeg' ? 'jpg' : strtolower($matches[1]);
                    $data = base64_decode(substr($parte, strpos($parte, ',') + 1), true);
                    if ($data !== false) {
                        $nombreArchivo = 'visita_'.now()->format('Ymd_His').'_'.uniqid().'.'.$ext;
                        File::put($directorioAbsoluto.DIRECTORY_SEPARATOR.$nombreArchivo, $data);
                        $rutasGuardadas[] = '/'.$directorioRelativo.'/'.$nombreArchivo;
                    }
                } elseif ($parte !== '/images/default-check.png' || empty($rutasGuardadas)) {
                    if ($parte !== '/images/default-check.png') {
                        $rutasGuardadas[] = $parte;
                    }
                }
            }
        }

        $rutasUnicas = array_values(array_unique($rutasGuardadas));

        if (empty($rutasUnicas)) {
            return '/images/default-check.png';
        }

        return implode('|', $rutasUnicas);
    }
}
