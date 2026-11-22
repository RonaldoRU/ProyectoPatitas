<?php

namespace App\Http\Controllers\P02_LogisticaInventario;

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
    /**
     * CU18: Listar Proveedores Registrados
     */
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
                    'estado',
                    'created_at',
                    'updated_at',
                ]),
        ]);
    }

    /**
     * CU18: Registrar Nuevo Proveedor de Insumos
     */
    public function store(Request $request, AuditoriaService $auditoria): JsonResponse
    {
        $this->authorizeAdministrator($request);
        $data = $this->validatedData($request);
        $estado = $data['estado'] ?? 'Activo';
        $activo = $estado === 'Activo';

        $proveedor = DB::transaction(function () use ($request, $data, $estado, $activo, $auditoria): Proveedor {
            if ($activo) {
                $this->rejectActiveDuplicates($data);
            }

            $proveedor = Proveedor::query()->create([
                ...$data,
                'estado' => $estado,
                'activo' => $activo,
            ]);

            $auditoria->registrar(
                $request,
                $request->user(),
                'Registrar proveedor de insumos',
                'inventario',
                entidad: $proveedor,
                descripcion: "Registro en tabla proveedors ({$proveedor->nombre_empresa}) con nuevo atributo estado: {$proveedor->estado}",
                contexto: [
                    'tabla_afectada' => 'proveedors',
                    'nuevo_atributo_tabla_proveedor' => 'estado',
                    'nombre_empresa' => $proveedor->nombre_empresa,
                    'identificacion' => $proveedor->identificacion,
                    'tipo_insumo_provisto' => $proveedor->tipo_insumo_provisto,
                    'estado' => $proveedor->estado,
                ],
            );

            return $proveedor;
        });

        return response()->json(['proveedor' => $proveedor], 201);
    }

    /**
     * CU18: Modificar Información de Contacto del Proveedor
     */
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

            $nuevoEstado = $data['estado'] ?? $proveedor->estado ?? ($proveedor->activo ? 'Activo' : 'Inactivo');
            $nuevoActivo = $nuevoEstado === 'Activo';

            if ($nuevoActivo) {
                $this->rejectActiveDuplicates($data, $proveedor);
            }

            $proveedor->update([
                ...$data,
                'estado' => $nuevoEstado,
                'activo' => $nuevoActivo,
            ]);

            $auditoria->registrar(
                $request,
                $request->user(),
                'Modificar proveedor de insumos',
                'inventario',
                entidad: $proveedor,
                descripcion: "Actualización en tabla proveedors ({$proveedor->nombre_empresa}) - atributo estado: {$proveedor->estado}",
                contexto: [
                    'tabla_afectada' => 'proveedors',
                    'nuevo_atributo_tabla_proveedor' => 'estado',
                    'estado_actual' => $proveedor->estado,
                    'campos_modificados' => array_values(array_intersect(
                        array_keys($proveedor->getChanges()),
                        [...array_keys($data), 'estado', 'activo'],
                    )),
                ],
            );
        });

        return response()->json([
            'proveedor' => $proveedor->refresh(),
        ]);
    }

    /**
     * CU18: Activar / Inactivar Proveedor
     */
    public function setStatus(
        Request $request,
        Proveedor $proveedor,
        AuditoriaService $auditoria,
    ): JsonResponse {
        $this->authorizeAdministrator($request);
        $validated = $request->validate([
            'activo' => ['required_without:estado', 'boolean'],
            'estado' => ['nullable', 'string', 'in:Activo,Inactivo,Suspendido,En revisión'],
        ]);

        $estado = $validated['estado'] ?? (((bool) $validated['activo']) ? 'Activo' : 'Inactivo');
        $activo = isset($validated['activo']) && ! isset($validated['estado'])
            ? (bool) $validated['activo']
            : ($estado === 'Activo');

        DB::transaction(function () use ($request, $proveedor, $activo, $estado, $auditoria): void {
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

            $proveedor->update([
                'activo' => $activo,
                'estado' => $estado,
            ]);
            $auditoria->registrar(
                $request,
                $request->user(),
                $activo ? 'Activar proveedor de insumos' : 'Desactivar proveedor de insumos',
                'inventario',
                entidad: $proveedor,
                descripcion: "Cambio del nuevo atributo estado en tabla proveedors ({$proveedor->nombre_empresa}) a '{$estado}'",
                contexto: [
                    'tabla_afectada' => 'proveedors',
                    'nuevo_atributo_tabla_proveedor' => 'estado',
                    'nombre_empresa' => $proveedor->nombre_empresa,
                    'activo' => $activo,
                    'estado' => $estado,
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
     *     tipo_insumo_provisto: string,
     *     estado?: string
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
            'estado' => ['nullable', 'string', 'in:Activo,Inactivo,Suspendido,En revisión'],
        ], [
            'nombre_empresa.required' => 'El nombre comercial de la empresa es obligatorio.',
            'nombre_contacto.required' => 'El nombre de contacto es obligatorio.',
            'telefono.required' => 'El teléfono de contacto es obligatorio.',
            'direccion.required' => 'La dirección del proveedor es obligatoria.',
            'tipo_insumo_provisto.required' => 'Indica qué tipo de insumos provee la empresa.',
        ]);

        $result = [
            'nombre_empresa' => Str::squish((string) $validated['nombre_empresa']),
            'nombre_contacto' => Str::squish((string) $validated['nombre_contacto']),
            'telefono' => trim((string) $validated['telefono']),
            'direccion' => Str::squish((string) $validated['direccion']),
            'identificacion' => isset($validated['identificacion'])
                ? Str::upper(trim((string) $validated['identificacion']))
                : null,
            'tipo_insumo_provisto' => Str::squish((string) $validated['tipo_insumo_provisto']),
        ];

        if (isset($validated['estado']) && $validated['estado'] !== '') {
            $result['estado'] = (string) $validated['estado'];
        }

        return $result;
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
        abort_unless(
            in_array($request->user()?->rol, ['Administrador', 'Recepcionista', 'Voluntario'], true),
            403,
        );
    }
}
