<?php

namespace App\Http\Controllers\P03_RescateClinicaAdopciones;

use App\Http\Controllers\Controller;
use App\Models\Mascota;
use App\Services\AuditoriaService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

/**
 * Paquete P7: Gestión de Rescate e Historial Clínico Veterinario
 * Casos de Uso:
 * - CU19: Registrar Ficha de Rescate e Ingreso de Mascota
 */
class MascotaController extends Controller
{
    private const ESTADOS = ['En Recuperación', 'Disponible', 'Disponible para Adopción', 'Adoptado', 'Fallecido', 'En tratamiento'];

    private const FOTOS_POR_RAZA = [
        'pitbull' => [
            'https://images.dog.ceo/breeds/pitbull/dog-3981540_1280.jpg',
            'https://images.dog.ceo/breeds/pitbull/louie.jpg',
            'https://images.dog.ceo/breeds/pitbull/dog-5437227_640.jpg',
        ],
        'pastor' => [
            'https://images.dog.ceo/breeds/german-shepherd/n02106662_1637.jpg',
            'https://images.dog.ceo/breeds/german-shepherd/n02106662_22245.jpg',
            'https://images.dog.ceo/breeds/german-shepherd/n02106662_20711.jpg',
        ],
        'labrador' => [
            'https://images.dog.ceo/breeds/labrador/n02099712_1930.jpg',
            'https://images.dog.ceo/breeds/labrador/n02099712_7406.jpg',
            'https://images.dog.ceo/breeds/labrador/n02099712_7414.jpg',
        ],
        'poodle' => [
            'https://images.dog.ceo/breeds/poodle-miniature/img-0413.jpg',
            'https://images.dog.ceo/breeds/poodle-miniature/n02113712_3272.jpg',
        ],
        'caniche' => [
            'https://images.dog.ceo/breeds/poodle-miniature/img-0413.jpg',
            'https://images.dog.ceo/breeds/poodle-miniature/n02113712_3272.jpg',
        ],
        'chihuahua' => [
            'https://images.dog.ceo/breeds/chihuahua/n02085620_4700.jpg',
            'https://images.dog.ceo/breeds/chihuahua/n02085620_11696.jpg',
            'https://images.dog.ceo/breeds/chihuahua/n02085620_199.jpg',
        ],
        'golden' => [
            'https://images.dog.ceo/breeds/retriever-golden/n02099601_3004.jpg',
            'https://images.dog.ceo/breeds/retriever-golden/n02099601_816.jpg',
        ],
        'siames' => [
            'https://cdn2.thecatapi.com/images/84q.png',
            'https://cdn2.thecatapi.com/images/43a.jpg',
        ],
        'siamés' => [
            'https://cdn2.thecatapi.com/images/84q.png',
            'https://cdn2.thecatapi.com/images/43a.jpg',
        ],
        'persa' => [
            'https://cdn2.thecatapi.com/images/ja.jpg',
            'https://cdn2.thecatapi.com/images/ebs.jpg',
        ],
        'angora' => [
            'https://cdn2.thecatapi.com/images/2c5.jpg',
            'https://cdn2.thecatapi.com/images/c9c.jpg',
        ],
        'tabby' => [
            'https://cdn2.thecatapi.com/images/e1m.jpg',
            'https://cdn2.thecatapi.com/images/3a8.jpg',
        ],
        'carey' => [
            'https://cdn2.thecatapi.com/images/cof.jpg',
            'https://cdn2.thecatapi.com/images/50s.png',
        ],
    ];

    private const FOTOS_CANINOS = [
        'https://images.dog.ceo/breeds/labrador/n02099712_1930.jpg',
        'https://images.dog.ceo/breeds/retriever-golden/n02099601_3004.jpg',
    ];

    private const FOTOS_FELINOS = [
        'https://cdn2.thecatapi.com/images/e1m.jpg',
        'https://cdn2.thecatapi.com/images/MTcyMTMxOQ.jpg',
    ];

    public static function resolverFotoPorRaza(string $especie, string $raza, int $id = 0, string $nombre = ''): string
    {
        $razaLower = mb_strtolower($raza);
        $pool = null;
        foreach (self::FOTOS_POR_RAZA as $keyword => $urls) {
            if (str_contains($razaLower, $keyword)) {
                $pool = $urls;
                break;
            }
        }
        if (! $pool) {
            $esFelino = stripos($especie, 'Felin') !== false || stripos($especie, 'Gato') !== false;
            $pool = $esFelino ? self::FOTOS_FELINOS : self::FOTOS_CANINOS;
        }
        $baseUrl = $pool[$id > 0 ? ($id % count($pool)) : array_rand($pool)];
        $slugNombre = trim(strtolower((string) preg_replace('/[^a-zA-Z0-9]+/', '-', $nombre ?: 'mascota')), '-');
        $slugRaza = trim(strtolower((string) preg_replace('/[^a-zA-Z0-9]+/', '-', $raza ?: $especie)), '-');
        $localFile = "images/mascotas/mascota_{$id}_{$slugNombre}_{$slugRaza}.jpg";
        if ($id > 0 && file_exists(public_path($localFile))) {
            return '/'.$localFile;
        }

        return $baseUrl."?mascota_id={$id}&nombre={$slugNombre}&raza={$slugRaza}";
    }

    /**
     * CU19: Listar y Buscar Mascotas Rescatadas
     * Filtra por estado de adopción/salud, especie (Perro, Gato) y búsqueda textual.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Mascota::query();

        if ($request->filled('estado')) {
            $query->where('estado_actual', $request->query('estado'));
        }

        if ($request->filled('especie')) {
            $query->where('especie', $request->query('especie'));
        }

        if ($request->filled('buscar')) {
            $search = '%'.$request->query('buscar').'%';
            $query->where(function ($q) use ($search) {
                $q->where('nombre', 'like', $search)
                    ->orWhere('raza', 'like', $search)
                    ->orWhere('zona_rescate', 'like', $search);
            });
        }

        $mascotas = $query->orderByDesc('id')->get();

        return response()->json(['mascotas' => $mascotas]);
    }

    /**
     * Catálogo público de mascotas listas para adopción (solo lectura con fotos y estado).
     */
    public function disponiblesPublico(): JsonResponse
    {
        $mascotas = Mascota::query()
            ->whereIn('estado_actual', ['Disponible', 'Disponible para Adopción'])
            ->select(['id', 'nombre', 'especie', 'raza', 'edad', 'sexo', 'zona_rescate', 'estado_actual', 'foto'])
            ->orderByDesc('id')
            ->get();

        return response()->json(['mascotas' => $mascotas]);
    }

    /**
     * CU19: Registrar Ingreso y Ficha de Rescate de una Mascota
     */
    public function store(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        abort_if(in_array($request->user()?->rol, ['Donante', 'Postulante'], true), 403, 'No tienes permiso para registrar mascotas.');
        $validated = $request->validate([
            'nombre' => ['required', 'string', 'max:255'],
            'especie' => ['required', 'string', 'max:100'],
            'raza' => ['required', 'string', 'max:100'],
            'edad' => ['required', 'string', 'max:50'],
            'sexo' => ['required', 'string', Rule::in(['Macho', 'Hembra'])],
            'zona_rescate' => ['required', 'string', 'max:255'],
            'fecha_ingreso' => ['required', 'date'],
            'foto' => ['nullable', 'string', 'max:500'],
            'estado_actual' => ['nullable', 'string', Rule::in(self::ESTADOS)],
        ]);

        $validated['estado_actual'] = $validated['estado_actual'] ?? 'En Recuperación';
        $fotoManual = ! empty($validated['foto']);
        if (! $fotoManual) {
            $validated['foto'] = self::resolverFotoPorRaza($validated['especie'], $validated['raza'], 0, $validated['nombre']);
        }

        $mascota = DB::transaction(function () use ($request, $validated, $fotoManual, $auditoria): Mascota {
            $mascota = Mascota::query()->create($validated);
            if (! $fotoManual) {
                $mascota->update([
                    'foto' => self::resolverFotoPorRaza($mascota->especie, $mascota->raza, (int) $mascota->id, $mascota->nombre),
                ]);
            }
            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar ficha de rescate de mascota',
                'rescate',
                entidad: $mascota,
                contexto: [
                    'nombre' => $mascota->nombre,
                    'especie' => $mascota->especie,
                    'zona_rescate' => $mascota->zona_rescate,
                    'estado_actual' => $mascota->estado_actual,
                ],
            );

            return $mascota;
        });

        return response()->json(['mascota' => $mascota], 201);
    }

    public function show(Mascota $mascota): JsonResponse
    {
        return response()->json([
            'mascota' => $mascota->load(['historialesClinicos.usuario:id,nombre']),
        ]);
    }

    public function update(Request $request, Mascota $mascota, AuditoriaService $auditoria): JsonResponse
    {
        abort_if(in_array($request->user()?->rol, ['Donante', 'Postulante'], true), 403, 'No tienes permiso para actualizar mascotas.');
        $validated = $request->validate([
            'nombre' => ['sometimes', 'required', 'string', 'max:255'],
            'especie' => ['sometimes', 'required', 'string', 'max:100'],
            'raza' => ['sometimes', 'required', 'string', 'max:100'],
            'edad' => ['sometimes', 'required', 'string', 'max:50'],
            'sexo' => ['sometimes', 'required', 'string', Rule::in(['Macho', 'Hembra'])],
            'zona_rescate' => ['sometimes', 'required', 'string', 'max:255'],
            'fecha_ingreso' => ['sometimes', 'required', 'date'],
            'foto' => ['nullable', 'string', 'max:500'],
            'estado_actual' => ['sometimes', 'required', 'string', Rule::in(self::ESTADOS)],
        ]);

        DB::transaction(function () use ($request, $mascota, $validated, $auditoria): void {
            $mascota->update($validated);
            $auditoria->registrar(
                $request,
                $request->user(),
                'Actualizar ficha de rescate de mascota',
                'rescate',
                entidad: $mascota,
                contexto: [
                    'campos_modificados' => array_keys($mascota->getChanges()),
                ],
            );
        });

        return response()->json(['mascota' => $mascota->refresh()]);
    }
}
