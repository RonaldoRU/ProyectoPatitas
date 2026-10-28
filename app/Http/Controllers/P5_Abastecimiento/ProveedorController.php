<?php

namespace App\Http\Controllers\P5_Abastecimiento;

use App\Http\Controllers\Controller;
use App\Models\Proveedor;
use App\Services\AuditoriaService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

/**
 * Paquete P5: Abastecimiento, Salidas y Proveedores
 * Casos de Uso:
 * - CU18: Gestionar Proveedores de Insumos
 */
class ProveedorController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $this->authorizeAdministrator($request);

        return response()->json([
            'proveedores' => Proveedor::query()
                ->orderByDesc('activo')
                ->orderBy('nombre_empresa')
                ->get([
                    'id',
                    'nombre_empresa',
                    'nombre_contacto',
                    'telefono',
                    'direccion',
                    'identificacion',
                    'tipo_insumo_provisto',
                    'activo',
                    'created_at',
                    'updated_at',
                ]),
        ]);
    }

    public function store(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $this->authorizeAdministrator($request);
        $data = $this->validatedData($request);

        $proveedor = DB::transaction(function () use ($request, $data, $auditoria): Proveedor {
            $this->rejectActiveDuplicates($data);
            $proveedor = Proveedor::query()->create([
                ...$data,
                'activo' => true,
            ]);

            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar proveedor de insumos',
                'inventario',
                entidad: $proveedor,
                contexto: [
                    'nombre_empresa' => $proveedor->nombre_empresa,
                    'identificacion' => $proveedor->identificacion,
                    'tipo_insumo_provisto' => $proveedor->tipo_insumo_provisto,
                ],
            );

            return $proveedor;
        });

        return response()->json(['proveedor' => $proveedor], 201);
    }

    public function update(
        Request $request,
        Proveedor $proveedor,
        AuditoriaService $auditoria,
    ): JsonResponse {
        $this->authorizeAdministrator($request);
        $data = $this->validatedData($request);

        DB::transaction(function () use ($request, $proveedor, $data, $auditoria): void {
            $proveedor = Proveedor::query()
                ->whereKey($proveedor->getKey())
                ->lockForUpdate()
                ->firstOrFail();
            $this->rejectActiveDuplicates($data, $proveedor);
            $proveedor->update($data);

            $auditoria->registrar(
                $request,
                $request->user(),
                'Modificar proveedor de insumos',
                'inventario',
                entidad: $proveedor,
                contexto: [
                    'campos_modificados' => array_values(array_intersect(
                        array_keys($proveedor->getChanges()),
                        array_keys($data),
                    )),
                ],
            );
        });

        return response()->json([
            'proveedor' => $proveedor->refresh(),
        ]);
    }

    public function setStatus(
        Request $request,
        Proveedor $proveedor,
        AuditoriaService $auditoria,
    ): JsonResponse {
        $this->authorizeAdministrator($request);
        $validated = $request->validate([
            'activo' => ['required', 'boolean'],
        ]);
        $activo = (bool) $validated['activo'];

        DB::transaction(function () use ($request, $proveedor, $activo, $auditoria): void {
            $proveedor = Proveedor::query()
                ->whereKey($proveedor->getKey())
                ->lockForUpdate()
                ->firstOrFail();

            if ($activo) {
                $this->rejectActiveDuplicates([
                    'nombre_empresa' => $proveedor->nombre_empresa,
                    'identificacion' => $proveedor->identificacion,
                ], $proveedor);
            }

            $proveedor->update(['activo' => $activo]);
            $auditoria->registrar(
                $request,
                $request->user(),
                $activo ? 'Activar proveedor de insumos' : 'Desactivar proveedor de insumos',
                'inventario',
                entidad: $proveedor,
                contexto: [
                    'nombre_empresa' => $proveedor->nombre_empresa,
                    'activo' => $activo,
                ],
            );
        });

        return response()->json(['proveedor' => $proveedor->refresh()]);
    }

    /**
     * @return array{
     *     nombre_empresa: string,
     *     nombre_contacto: string,
     *     telefono: string,
     *     direccion: string,
     *     identificacion: string|null,
     *     tipo_insumo_provisto: string
     * }
     */
    private function validatedData(Request $request): array
    {
        $validated = $request->validate([
            'nombre_empresa' => ['required', 'string', 'max:255'],
            'nombre_contacto' => ['required', 'string', 'max:255'],
            'telefono' => ['required', 'string', 'max:255'],
            'direccion' => ['required', 'string', 'max:255'],
            'identificacion' => ['nullable', 'string', 'max:50'],
            'tipo_insumo_provisto' => ['required', 'string', 'max:255'],
        ], [
            'nombre_empresa.required' => 'El nombre comercial de la empresa es obligatorio.',
            'nombre_contacto.required' => 'El nombre de contacto es obligatorio.',
            'telefono.required' => 'El teléfono de contacto es obligatorio.',
            'direccion.required' => 'La dirección del proveedor es obligatoria.',
            'tipo_insumo_provisto.required' => 'Indica qué tipo de insumos provee la empresa.',
        ]);

        return [
            'nombre_empresa' => Str::squish((string) $validated['nombre_empresa']),
            'nombre_contacto' => Str::squish((string) $validated['nombre_contacto']),
            'telefono' => trim((string) $validated['telefono']),
            'direccion' => Str::squish((string) $validated['direccion']),
            'identificacion' => isset($validated['identificacion'])
                ? Str::upper(trim((string) $validated['identificacion']))
                : null,
            'tipo_insumo_provisto' => Str::squish((string) $validated['tipo_insumo_provisto']),
        ];
    }

    /**
     * @param  array{nombre_empresa: string, identificacion: string|null}  $data
     */
    private function rejectActiveDuplicates(array $data, ?Proveedor $current = null): void
    {
        $nombreNormalizado = $this->normalizeCompanyName($data['nombre_empresa']);
        $identificacion = $data['identificacion'];
        $duplicados = Proveedor::query()
            ->where('activo', true)
            ->when($current !== null, fn ($query) => $query->whereKeyNot($current->getKey()))
            ->get(['id', 'nombre_empresa', 'identificacion']);
        $errors = [];

        if ($duplicados->contains(
            fn (Proveedor $existing): bool => $this->normalizeCompanyName($existing->nombre_empresa)
                === $nombreNormalizado,
        )) {
            $errors['nombre_empresa'] = 'Ya existe un proveedor activo con ese nombre comercial.';
        }

        if ($identificacion !== null && $duplicados->contains(
            fn (Proveedor $existing): bool => $existing->identificacion !== null
                && Str::upper(trim($existing->identificacion)) === $identificacion,
        )) {
            $errors['identificacion'] = 'Ya existe un proveedor activo con ese número de identificación.';
        }

        if ($errors !== []) {
            throw ValidationException::withMessages($errors);
        }
    }

    private function normalizeCompanyName(string $name): string
    {
        return Str::ascii(Str::lower(Str::squish($name)));
    }

    private function authorizeAdministrator(Request $request): void
    {
        abort_unless($request->user()?->rol === 'Administrador', 403);
    }
}
