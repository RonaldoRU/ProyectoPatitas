<?php

namespace App\Services\IA;

use App\Models\ArticuloInventario;
use App\Models\User;
use App\Services\InventarioLotesService;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

/**
 * Servicio de herramientas (Tool Calling) para la generación de reportes específicos del refugio.
 * Todas las consultas son de solo lectura, optimizadas, parametrizadas y sincronizadas con la web.
 */
class ReporteToolService
{
    public function __construct(
        private readonly InventarioLotesService $inventarioLotesService
    ) {}

    /**
     * Declaraciones de herramientas compatibles con Google Gemini Function Calling.
     *
     * @return array<int, array<string, mixed>>
     */
    public function toolDeclarations(): array
    {
        return [
            [
                'name' => 'generar_reporte_gerencial',
                'description' => 'Genera el informe gerencial consolidado con rescates, adopciones, recaudación por donaciones, tasa de adopción y evolución mensual. Solo disponible para Administrador y Recepcionista.',
                'parameters' => [
                    'type' => 'OBJECT',
                    'properties' => [
                        'meses' => [
                            'type' => 'INTEGER',
                            'description' => 'Cantidad de meses hacia atrás a incluir en la evolución mensual (entre 1 y 12, por defecto 6).',
                        ],
                    ],
                ],
            ],
            [
                'name' => 'generar_reporte_mascotas',
                'description' => 'Genera un reporte PDF filtrado de mascotas rescatadas en el refugio (por especie, raza, estado o fechas).',
                'parameters' => [
                    'type' => 'OBJECT',
                    'properties' => [
                        'especie' => [
                            'type' => 'STRING',
                            'description' => 'Especie del animal: Canino, Felino, Perro, Gato.',
                        ],
                        'estado_actual' => [
                            'type' => 'STRING',
                            'description' => 'Estado actual: Disponible, Disponible para Adopción, En Recuperación, En Tratamiento, Adoptado, Fallecido.',
                        ],
                        'fecha_desde' => [
                            'type' => 'STRING',
                            'description' => 'Fecha mínima de ingreso en formato YYYY-MM-DD.',
                        ],
                        'fecha_hasta' => [
                            'type' => 'STRING',
                            'description' => 'Fecha máxima de ingreso en formato YYYY-MM-DD.',
                        ],
                    ],
                ],
            ],
            [
                'name' => 'generar_reporte_donaciones',
                'description' => 'Genera un reporte PDF de donaciones recibidas (monetarias o en insumos) con nombre del donante, comprobante y monto en bolivianos.',
                'parameters' => [
                    'type' => 'OBJECT',
                    'properties' => [
                        'tipo_aporte' => [
                            'type' => 'STRING',
                            'description' => 'Tipo de aporte: Dinero, Insumos.',
                        ],
                        'fecha_desde' => [
                            'type' => 'STRING',
                            'description' => 'Fecha inicial en formato YYYY-MM-DD.',
                        ],
                        'fecha_hasta' => [
                            'type' => 'STRING',
                            'description' => 'Fecha final en formato YYYY-MM-DD.',
                        ],
                    ],
                ],
            ],
            [
                'name' => 'generar_reporte_inventario',
                'description' => 'Genera un reporte PDF del inventario de medicamentos, alimentos, vacunas e insumos, permitiendo filtrar por categoría, stock bajo o lotes próximos a vencer.',
                'parameters' => [
                    'type' => 'OBJECT',
                    'properties' => [
                        'categoria' => [
                            'type' => 'STRING',
                            'description' => 'Categoría del artículo: Alimento, Medicamento, Vacuna, Limpieza, Accesorio.',
                        ],
                        'solo_bajo_stock' => [
                            'type' => 'BOOLEAN',
                            'description' => 'Si es true, muestra únicamente artículos con stock_actual <= stock_minimo_alerta.',
                        ],
                        'dias_vencimiento' => [
                            'type' => 'INTEGER',
                            'description' => 'Si se indica, incluye lotes con fecha de vencimiento dentro de los próximos N días.',
                        ],
                    ],
                ],
            ],
            [
                'name' => 'generar_reporte_adopciones',
                'description' => 'Genera un reporte PDF de adopciones formalizadas con datos de la mascota, raza y adoptante.',
                'parameters' => [
                    'type' => 'OBJECT',
                    'properties' => [
                        'fecha_desde' => [
                            'type' => 'STRING',
                            'description' => 'Fecha mínima de adopción en formato YYYY-MM-DD.',
                        ],
                        'fecha_hasta' => [
                            'type' => 'STRING',
                            'description' => 'Fecha máxima de adopción en formato YYYY-MM-DD.',
                        ],
                    ],
                ],
            ],
            [
                'name' => 'generar_reporte_postulantes',
                'description' => 'Genera un reporte PDF de postulantes a adopción con su puntaje de evaluación, situación de vivienda y estado (Aprobado, Pendiente, Rechazado).',
                'parameters' => [
                    'type' => 'OBJECT',
                    'properties' => [
                        'estado' => [
                            'type' => 'STRING',
                            'description' => 'Estado del postulante: Aprobado, Pendiente, En evaluación, Rechazado.',
                        ],
                    ],
                ],
            ],
            [
                'name' => 'generar_reporte_visitas_seguimiento',
                'description' => 'Genera un reporte PDF de visitas de seguimiento post-adopción (pendientes, programadas o concluidas) con reporte de bienestar.',
                'parameters' => [
                    'type' => 'OBJECT',
                    'properties' => [
                        'estado_seguimiento' => [
                            'type' => 'STRING',
                            'description' => 'Estado de la visita: Pendiente, Programado, Concluido Satisfactorio, Completado.',
                        ],
                    ],
                ],
            ],
            [
                'name' => 'generar_reporte_atenciones_clinicas',
                'description' => 'Genera un reporte PDF de atenciones médicas veterinarias, cirugías, consultas y diagnósticos registrados en el expediente clínico.',
                'parameters' => [
                    'type' => 'OBJECT',
                    'properties' => [
                        'tipo_procedimiento' => [
                            'type' => 'STRING',
                            'description' => 'Tipo de procedimiento: Consulta Médica, Cirugía, Vacunación, Curación, Tratamiento.',
                        ],
                        'fecha_desde' => [
                            'type' => 'STRING',
                            'description' => 'Fecha mínima de atención YYYY-MM-DD.',
                        ],
                        'fecha_hasta' => [
                            'type' => 'STRING',
                            'description' => 'Fecha máxima de atención YYYY-MM-DD.',
                        ],
                    ],
                ],
            ],
            [
                'name' => 'generar_reporte_facturacion_iva',
                'description' => 'Genera un reporte PDF tributario del Libro de Compras y Ventas IVA (facturas legales emitidas, anuladas, débito y crédito fiscal 13%).',
                'parameters' => [
                    'type' => 'OBJECT',
                    'properties' => [
                        'mes' => [
                            'type' => 'INTEGER',
                            'description' => 'Número de mes (1-12). Por defecto el mes actual.',
                        ],
                        'anio' => [
                            'type' => 'INTEGER',
                            'description' => 'Año fiscal (ej. 2026). Por defecto el año actual.',
                        ],
                    ],
                ],
            ],
            [
                'name' => 'generar_reporte_compras_proveedores',
                'description' => 'Genera un reporte PDF de compras de insumos y abastecimiento a proveedores aliados con montos totales en bolivianos.',
                'parameters' => [
                    'type' => 'OBJECT',
                    'properties' => [
                        'fecha_desde' => [
                            'type' => 'STRING',
                            'description' => 'Fecha mínima de compra YYYY-MM-DD.',
                        ],
                        'fecha_hasta' => [
                            'type' => 'STRING',
                            'description' => 'Fecha máxima de compra YYYY-MM-DD.',
                        ],
                    ],
                ],
            ],
            [
                'name' => 'generar_reporte_salidas_mermas',
                'description' => 'Genera un reporte PDF de salidas de despensa, consumo de insumos y mermas o ajustes de inventario registrados.',
                'parameters' => [
                    'type' => 'OBJECT',
                    'properties' => [
                        'tipo' => [
                            'type' => 'STRING',
                            'description' => 'Tipo: salidas, mermas o todos.',
                        ],
                    ],
                ],
            ],
        ];
    }

    /**
     * Lista legible de herramientas disponibles para información del endpoint.
     *
     * @return array<int, string>
     */
    public function nombresHerramientas(): array
    {
        return array_map(
            static fn (array $decl): string => (string) $decl['name'],
            $this->toolDeclarations()
        );
    }

    /**
     * Ejecuta la herramienta solicitada validando permisos y parámetros.
     *
     * @param  array<string, mixed>  $args
     * @return array{
     *     autorizado: bool,
     *     error?: string,
     *     mensaje_defecto: string,
     *     resumen_para_ia: array<string, mixed>,
     *     reporte: array<string, mixed>|null
     * }
     */
    public function ejecutar(string $toolName, array $args, ?User $user): array
    {
        if ($user === null || in_array($user->rol, ['Voluntario', 'Donante', 'Postulante'], true)) {
            return [
                'autorizado' => false,
                'error' => 'Tu rol no tiene permisos para generar reportes.',
                'mensaje_defecto' => 'No cuentas con permisos para generar reportes en el sistema.',
                'resumen_para_ia' => ['autorizado' => false, 'motivo' => 'Rol sin permisos para reportes'],
                'reporte' => null,
            ];
        }

        if ($toolName === 'generar_reporte_gerencial' && ! in_array($user->rol, ['Administrador', 'Recepcionista'], true)) {
            return [
                'autorizado' => false,
                'error' => 'El reporte gerencial consolidado está restringido a Administrador o Recepcionista.',
                'mensaje_defecto' => 'El reporte gerencial consolidado solo está disponible para Administrador o Recepcionista.',
                'resumen_para_ia' => ['autorizado' => false, 'motivo' => 'Requiere rol Administrador o Recepcionista'],
                'reporte' => null,
            ];
        }

        if ($toolName === 'generar_reporte_facturacion_iva' && ! in_array($user->rol, ['Administrador', 'Recepcionista'], true)) {
            return [
                'autorizado' => false,
                'error' => 'El reporte tributario IVA está restringido a Administrador o Recepcionista.',
                'mensaje_defecto' => 'El reporte tributario IVA solo está disponible para Administrador o Recepcionista.',
                'resumen_para_ia' => ['autorizado' => false, 'motivo' => 'Requiere rol Administrador o Recepcionista'],
                'reporte' => null,
            ];
        }

        $resultado = match ($toolName) {
            'generar_reporte_gerencial' => $this->reporteGerencial($args, $user),
            'generar_reporte_mascotas' => $this->reporteMascotas($args, $user),
            'generar_reporte_donaciones' => $this->reporteDonaciones($args, $user),
            'generar_reporte_inventario' => $this->reporteInventario($args, $user),
            'generar_reporte_adopciones' => $this->reporteAdopciones($args, $user),
            'generar_reporte_postulantes' => $this->reportePostulantes($args, $user),
            'generar_reporte_visitas_seguimiento' => $this->reporteVisitasSeguimiento($args, $user),
            'generar_reporte_atenciones_clinicas' => $this->reporteAtencionesClinicas($args, $user),
            'generar_reporte_facturacion_iva' => $this->reporteFacturacionIva($args, $user),
            'generar_reporte_compras_proveedores' => $this->reporteComprasProveedores($args, $user),
            'generar_reporte_salidas_mermas' => $this->reporteSalidasMermas($args, $user),
            default => [
                'autorizado' => true,
                'error' => "Herramienta desconocida: {$toolName}",
                'mensaje_defecto' => 'No pude identificar el tipo de reporte solicitado.',
                'resumen_para_ia' => ['error' => 'Herramienta no soportada'],
                'reporte' => null,
            ],
        };

        // Si el reporte no tiene datos reales registrados, no generar PDF vacío
        if (
            isset($resultado['reporte']) &&
            is_array($resultado['reporte']) &&
            empty($resultado['reporte']['filas'])
        ) {
            $titulo = (string) ($resultado['reporte']['titulo'] ?? 'el reporte solicitado');
            $resultado['reporte'] = null;
            $resultado['sin_datos'] = true;
            $resultado['mensaje_defecto'] = "No existen registros con datos para {$titulo}, por lo que no se generó el PDF.";
        }

        return $resultado;
    }

    /**
     * @param  array<string, mixed>  $args
     * @return array<string, mixed>
     */
    private function reporteGerencial(array $args, User $user): array
    {
        $cantidadMeses = (int) ($args['meses'] ?? 6);
        $cantidadMeses = max(1, min(12, $cantidadMeses));

        $now = Carbon::now();
        $inicioRango = $now->copy()->subMonths($cantidadMeses - 1)->startOfMonth()->toDateString();
        $finRango = $now->copy()->endOfMonth()->toDateString();

        // Consultas agrupadas en memoria por mes (3 queries rápidas, compatibles con PostgreSQL y SQLite)
        $adopcionesPorMes = DB::table('adopcions')
            ->join('mascotas', 'adopcions.id_mascota', '=', 'mascotas.id')
            ->whereRaw("LOWER(mascotas.estado_actual) LIKE '%adoptad%'")
            ->whereBetween('adopcions.fecha_adopcion', [$inicioRango, $finRango])
            ->select('adopcions.id_mascota', 'adopcions.fecha_adopcion')
            ->get()
            ->unique('id_mascota')
            ->pluck('fecha_adopcion')
            ->countBy(static fn ($f): string => substr((string) $f, 0, 7));

        $rescatesPorMes = DB::table('mascotas')
            ->whereBetween('fecha_ingreso', [$inicioRango, $finRango])
            ->pluck('fecha_ingreso')
            ->countBy(static fn ($f): string => substr((string) $f, 0, 7));

        $ingresosPorMes = [];
        $aportesRango = DB::table('aporte_dineros')
            ->select('fecha_recepcion', 'monto')
            ->whereBetween('fecha_recepcion', [$inicioRango, $finRango])
            ->get();
        foreach ($aportesRango as $aporte) {
            $ym = substr((string) $aporte->fecha_recepcion, 0, 7);
            $ingresosPorMes[$ym] = ($ingresosPorMes[$ym] ?? 0.0) + (float) $aporte->monto;
        }

        $filas = [];
        $totalRescatesPeriodo = 0;
        $totalAdopcionesPeriodo = 0;
        $totalIngresosPeriodo = 0.0;

        for ($i = $cantidadMeses - 1; $i >= 0; $i--) {
            $mes = $now->copy()->subMonths($i);
            $ym = $mes->format('Y-m');

            $rescates = (int) ($rescatesPorMes[$ym] ?? 0);
            $adopciones = (int) ($adopcionesPorMes[$ym] ?? 0);
            $ingresos = (float) ($ingresosPorMes[$ym] ?? 0);

            $totalRescatesPeriodo += $rescates;
            $totalAdopcionesPeriodo += $adopciones;
            $totalIngresosPeriodo += $ingresos;

            $filas[] = [
                $mes->translatedFormat('F Y'),
                (string) $rescates,
                (string) $adopciones,
                'Bs. '.number_format($ingresos, 2, '.', ''),
            ];
        }

        $totalRescatesHistorico = DB::table('mascotas')->count();
        $totalAdopcionesHistorico = DB::table('mascotas')
            ->whereRaw("LOWER(estado_actual) LIKE '%adoptad%'")
            ->count();
        $tasaAdopcion = $totalRescatesHistorico > 0
            ? min(100.0, round(($totalAdopcionesHistorico / $totalRescatesHistorico) * 100, 1))
            : 0.0;

        $reporte = [
            'tipo_reporte' => 'gerencial',
            'titulo' => 'Informe Gerencial Consolidado',
            'subtitulo' => "Evolución operativa de los últimos {$cantidadMeses} meses",
            'generado_por' => $user->nombre,
            'fecha_generacion' => $now->format('d/m/Y H:i'),
            'filtros' => ['meses' => $cantidadMeses],
            'resumen' => [
                ['etiqueta' => 'Rescates (período)', 'valor' => (string) $totalRescatesPeriodo],
                ['etiqueta' => 'Adopciones (período)', 'valor' => (string) $totalAdopcionesPeriodo],
                ['etiqueta' => 'Tasa Adopción Histórica', 'valor' => "{$tasaAdopcion}%"],
                ['etiqueta' => 'Donaciones (período)', 'valor' => 'Bs. '.number_format($totalIngresosPeriodo, 2, '.', '')],
            ],
            'columnas' => ['Mes', 'Rescates', 'Adopciones', 'Donaciones Recaudadas'],
            'filas' => $filas,
        ];

        return [
            'autorizado' => true,
            'mensaje_defecto' => "Informe gerencial de {$cantidadMeses} meses listo: {$totalRescatesPeriodo} rescates, {$totalAdopcionesPeriodo} adopciones y ".number_format($totalIngresosPeriodo, 2, '.', '').' bolivianos recaudados.',
            'resumen_para_ia' => [
                'tipo_reporte' => 'gerencial',
                'meses' => $cantidadMeses,
                'rescates_periodo' => $totalRescatesPeriodo,
                'adopciones_periodo' => $totalAdopcionesPeriodo,
                'tasa_adopcion_porcentaje' => $tasaAdopcion,
                'ingresos_periodo_bolivianos' => round($totalIngresosPeriodo, 2),
            ],
            'reporte' => $reporte,
        ];
    }

    /**
     * @param  array<string, mixed>  $args
     * @return array<string, mixed>
     */
    private function reporteMascotas(array $args, User $user): array
    {
        $especie = isset($args['especie']) ? trim((string) $args['especie']) : null;
        $estado = isset($args['estado_actual']) ? trim((string) $args['estado_actual']) : null;
        $fechaDesde = $this->normalizarFecha($args['fecha_desde'] ?? null);
        $fechaHasta = $this->normalizarFecha($args['fecha_hasta'] ?? null);

        $query = DB::table('mascotas')
            ->select('id', 'nombre', 'especie', 'raza', 'edad', 'sexo', 'estado_actual', 'fecha_ingreso', 'zona_rescate')
            ->orderByDesc('fecha_ingreso')
            ->orderByDesc('id');

        if (! empty($especie)) {
            $espLower = mb_strtolower($especie, 'UTF-8');
            if (str_contains($espLower, 'perr') || str_contains($espLower, 'canin')) {
                $query->where(function ($q): void {
                    $q->whereRaw('LOWER(especie) LIKE ?', ['%canin%'])
                        ->orWhereRaw('LOWER(especie) LIKE ?', ['%perr%']);
                });
                $especie = 'Canino';
            } elseif (str_contains($espLower, 'gat') || str_contains($espLower, 'felin')) {
                $query->where(function ($q): void {
                    $q->whereRaw('LOWER(especie) LIKE ?', ['%felin%'])
                        ->orWhereRaw('LOWER(especie) LIKE ?', ['%gat%']);
                });
                $especie = 'Felino';
            } else {
                $query->whereRaw('LOWER(especie) LIKE ?', ['%'.$espLower.'%']);
            }
        }

        if (! empty($estado)) {
            $estLower = mb_strtolower($estado, 'UTF-8');
            if (str_contains($estLower, 'dispon') || str_contains($estLower, 'en adop')) {
                $query->where(function ($q): void {
                    $q->whereRaw('LOWER(estado_actual) LIKE ?', ['%disponible%'])
                        ->orWhereRaw('LOWER(estado_actual) LIKE ?', ['%en adop%']);
                });
                $estado = 'Disponible para Adopción';
            } elseif (str_contains($estLower, 'recuper')) {
                $query->whereRaw('LOWER(estado_actual) LIKE ?', ['%recuper%']);
                $estado = 'En Recuperación';
            } elseif (str_contains($estLower, 'trata')) {
                $query->whereRaw('LOWER(estado_actual) LIKE ?', ['%trata%']);
                $estado = 'En Tratamiento';
            } else {
                $query->whereRaw('LOWER(estado_actual) LIKE ?', ['%'.$estLower.'%']);
            }
        }

        if ($fechaDesde !== null) {
            $query->where('fecha_ingreso', '>=', $fechaDesde);
        }

        if ($fechaHasta !== null) {
            $query->where('fecha_ingreso', '<=', $fechaHasta);
        }

        $registros = $query->limit(150)->get();
        $total = $registros->count();

        $filas = $registros->map(static fn (object $m): array => [
            '#'.$m->id,
            (string) ($m->nombre ?? 'Sin nombre'),
            (string) ($m->especie ?? '-'),
            (string) ($m->raza ?? '-'),
            (string) (($m->edad ?? '-').' · '.($m->sexo ?? '-')),
            (string) ($m->estado_actual ?? '-'),
            (string) ($m->fecha_ingreso ?? '-'),
            (string) ($m->zona_rescate ?? '-'),
        ])->all();

        $filtrosTexto = array_filter([
            $especie ? "Especie: {$especie}" : null,
            $estado ? "Estado: {$estado}" : null,
            $fechaDesde ? "Desde: {$fechaDesde}" : null,
            $fechaHasta ? "Hasta: {$fechaHasta}" : null,
        ]);

        $reporte = [
            'tipo_reporte' => 'mascotas',
            'titulo' => 'Reporte de Mascotas Rescatadas',
            'subtitulo' => count($filtrosTexto) > 0 ? implode(' • ', $filtrosTexto) : 'Listado general de mascotas registradas en el refugio',
            'generado_por' => $user->nombre,
            'fecha_generacion' => Carbon::now()->format('d/m/Y H:i'),
            'filtros' => [
                'especie' => $especie,
                'estado_actual' => $estado,
                'fecha_desde' => $fechaDesde,
                'fecha_hasta' => $fechaHasta,
            ],
            'resumen' => [
                ['etiqueta' => 'Total Mascotas', 'valor' => (string) $total],
                ['etiqueta' => 'Filtro Especie', 'valor' => $especie ?: 'Todas'],
                ['etiqueta' => 'Filtro Estado', 'valor' => $estado ?: 'Todos'],
            ],
            'columnas' => ['ID', 'Nombre', 'Especie', 'Raza', 'Edad / Sexo', 'Estado Actual', 'Fecha Ingreso', 'Zona Rescate'],
            'filas' => $filas,
        ];

        return [
            'autorizado' => true,
            'mensaje_defecto' => "Reporte de mascotas listo con {$total} registros encontrados.",
            'resumen_para_ia' => [
                'tipo_reporte' => 'mascotas',
                'total_encontradas' => $total,
                'filtros' => $reporte['filtros'],
            ],
            'reporte' => $reporte,
        ];
    }

    /**
     * @param  array<string, mixed>  $args
     * @return array<string, mixed>
     */
    private function reporteDonaciones(array $args, User $user): array
    {
        $tipoAporte = isset($args['tipo_aporte']) ? trim((string) $args['tipo_aporte']) : null;
        $fechaDesde = $this->normalizarFecha($args['fecha_desde'] ?? null);
        $fechaHasta = $this->normalizarFecha($args['fecha_hasta'] ?? null);

        $query = DB::table('donacions')
            ->leftJoin('donantes', 'donacions.id_donante', '=', 'donantes.id')
            ->leftJoin('aporte_dineros', 'donacions.id', '=', 'aporte_dineros.id_donacion')
            ->select(
                'donacions.id',
                'donacions.numero_documento',
                'donacions.tipo_aporte',
                'donacions.fecha',
                'donantes.nombre as donante_nombre',
                DB::raw('COALESCE(aporte_dineros.monto, 0) as monto'),
                'aporte_dineros.observaciones'
            )
            ->orderByDesc('donacions.fecha')
            ->orderByDesc('donacions.id');

        if (! empty($tipoAporte)) {
            $query->whereRaw('LOWER(donacions.tipo_aporte) LIKE ?', ['%'.mb_strtolower($tipoAporte, 'UTF-8').'%']);
        }

        if ($fechaDesde !== null) {
            $query->where('donacions.fecha', '>=', $fechaDesde);
        }

        if ($fechaHasta !== null) {
            $query->where('donacions.fecha', '<=', $fechaHasta);
        }

        $registros = $query->limit(150)->get();
        $totalRegistros = $registros->count();
        $montoTotal = (float) $registros->sum('monto');

        $filas = $registros->map(static fn (object $d): array => [
            (string) ($d->numero_documento ?? "DON-{$d->id}"),
            (string) ($d->donante_nombre ?? 'Anónimo'),
            (string) ($d->tipo_aporte ?? '-'),
            (string) ($d->fecha ?? '-'),
            'Bs. '.number_format((float) $d->monto, 2, '.', ''),
            (string) ($d->observaciones ?? '-'),
        ])->all();

        $reporte = [
            'tipo_reporte' => 'donaciones',
            'titulo' => 'Reporte de Donaciones y Aportes',
            'subtitulo' => $tipoAporte ? "Tipo de aporte: {$tipoAporte}" : 'Consolidado de donaciones monetarias y en insumos',
            'generado_por' => $user->nombre,
            'fecha_generacion' => Carbon::now()->format('d/m/Y H:i'),
            'filtros' => [
                'tipo_aporte' => $tipoAporte,
                'fecha_desde' => $fechaDesde,
                'fecha_hasta' => $fechaHasta,
            ],
            'resumen' => [
                ['etiqueta' => 'Total Donaciones', 'valor' => (string) $totalRegistros],
                ['etiqueta' => 'Monto Monetario', 'valor' => 'Bs. '.number_format($montoTotal, 2, '.', '')],
            ],
            'columnas' => ['Documento', 'Donante', 'Tipo de Aporte', 'Fecha', 'Monto', 'Observaciones'],
            'filas' => $filas,
        ];

        return [
            'autorizado' => true,
            'mensaje_defecto' => "Reporte de donaciones listo: {$totalRegistros} registros por un total de ".number_format($montoTotal, 2, '.', '').' bolivianos.',
            'resumen_para_ia' => [
                'tipo_reporte' => 'donaciones',
                'total_registros' => $totalRegistros,
                'monto_total_bolivianos' => round($montoTotal, 2),
            ],
            'reporte' => $reporte,
        ];
    }

    /**
     * @param  array<string, mixed>  $args
     * @return array<string, mixed>
     */
    private function reporteInventario(array $args, User $user): array
    {
        $soloBajoStock = filter_var($args['solo_bajo_stock'] ?? false, FILTER_VALIDATE_BOOLEAN);
        $diasVencimiento = isset($args['dias_vencimiento']) ? max(1, (int) $args['dias_vencimiento']) : null;
        $categoria = isset($args['categoria']) ? trim((string) $args['categoria']) : null;

        if ($diasVencimiento !== null) {
            $limiteFecha = Carbon::now()->addDays($diasVencimiento)->toDateString();

            $lotes = DB::table('inventario_lotes')
                ->join('articulo_inventarios', 'inventario_lotes.id_articulo', '=', 'articulo_inventarios.id')
                ->select(
                    'articulo_inventarios.nombre',
                    'articulo_inventarios.categoria',
                    'articulo_inventarios.unidad_medida',
                    'inventario_lotes.cantidad_disponible',
                    'inventario_lotes.fecha_vencimiento'
                )
                ->where('inventario_lotes.cantidad_disponible', '>', 0)
                ->whereNotNull('inventario_lotes.fecha_vencimiento')
                ->where('inventario_lotes.fecha_vencimiento', '<=', $limiteFecha)
                ->orderBy('inventario_lotes.fecha_vencimiento')
                ->limit(150)
                ->get();

            $filas = $lotes->map(static fn (object $l): array => [
                (string) $l->nombre,
                (string) $l->categoria,
                (string) $l->unidad_medida,
                (string) $l->cantidad_disponible,
                (string) $l->fecha_vencimiento,
            ])->all();

            $total = $lotes->count();

            $reporte = [
                'tipo_reporte' => 'inventario',
                'titulo' => 'Reporte de Insumos Próximos a Vencer (FEFO)',
                'subtitulo' => "Lotes con vencimiento dentro de los próximos {$diasVencimiento} días",
                'generado_por' => $user->nombre,
                'fecha_generacion' => Carbon::now()->format('d/m/Y H:i'),
                'filtros' => ['dias_vencimiento' => $diasVencimiento],
                'resumen' => [
                    ['etiqueta' => 'Lotes en Alerta', 'valor' => (string) $total],
                    ['etiqueta' => 'Horizonte', 'valor' => "{$diasVencimiento} días"],
                ],
                'columnas' => ['Artículo', 'Categoría', 'Unidad', 'Cantidad Disponible', 'Fecha Vencimiento'],
                'filas' => $filas,
            ];

            return [
                'autorizado' => true,
                'mensaje_defecto' => "Reporte de vencimientos listo: {$total} lotes por vencer en los próximos {$diasVencimiento} días.",
                'resumen_para_ia' => [
                    'tipo_reporte' => 'inventario_vencimientos',
                    'lotes_en_alerta' => $total,
                    'dias_vencimiento' => $diasVencimiento,
                ],
                'reporte' => $reporte,
            ];
        }

        $query = ArticuloInventario::query()
            ->select(['id', 'nombre', 'categoria', 'unidad_medida', 'stock_actual', 'stock_minimo_alerta'])
            ->orderBy('categoria')
            ->orderBy('nombre');

        if (! empty($categoria)) {
            $query->whereRaw('LOWER(categoria) LIKE ?', ['%'.mb_strtolower($categoria, 'UTF-8').'%']);
        }

        $articulos = $query->get();
        // Calcular el stock real desde lotes vigentes (sincronizado con el Catálogo web)
        $stocksRealesCents = $this->inventarioLotesService->stocksDisponibles($articulos);

        $articulosProcesados = $articulos->map(static function (ArticuloInventario $a) use ($stocksRealesCents): array {
            $stockReal = ($stocksRealesCents[$a->getKey()] ?? 0) / 100;
            $stockMin = (float) $a->stock_minimo_alerta;
            $enAlerta = $stockReal <= $stockMin;

            return [
                'nombre' => (string) $a->nombre,
                'categoria' => (string) ($a->categoria ?? '-'),
                'unidad_medida' => (string) ($a->unidad_medida ?? '-'),
                'stock_actual' => $stockReal,
                'stock_minimo' => $stockMin,
                'en_alerta' => $enAlerta,
            ];
        });

        if ($soloBajoStock) {
            $articulosProcesados = $articulosProcesados
                ->filter(static fn (array $item): bool => $item['en_alerta'])
                ->values();
        }

        $articulosProcesados = $articulosProcesados->take(150);
        $total = $articulosProcesados->count();
        $bajoStockCount = $articulosProcesados->filter(static fn (array $item): bool => $item['en_alerta'])->count();

        $filas = $articulosProcesados->map(static fn (array $item): array => [
            $item['nombre'],
            $item['categoria'],
            $item['unidad_medida'],
            number_format($item['stock_actual'], 2, '.', ''),
            number_format($item['stock_minimo'], 2, '.', ''),
            $item['en_alerta'] ? 'Reponer (Alerta)' : 'Disponible',
        ])->all();

        $titulo = $soloBajoStock
            ? 'Reporte de Stock Crítico'
            : ($categoria ? "Reporte de Inventario — Categoría {$categoria}" : 'Reporte General de Inventario');

        $reporte = [
            'tipo_reporte' => 'inventario',
            'titulo' => $titulo,
            'subtitulo' => $soloBajoStock
                ? 'Artículos iguales o por debajo del stock mínimo de alerta'
                : 'Existencias actuales del catálogo del refugio',
            'generado_por' => $user->nombre,
            'fecha_generacion' => Carbon::now()->format('d/m/Y H:i'),
            'filtros' => ['solo_bajo_stock' => $soloBajoStock, 'categoria' => $categoria],
            'resumen' => [
                ['etiqueta' => 'Total Artículos', 'valor' => (string) $total],
                ['etiqueta' => 'En Alerta de Stock', 'valor' => (string) $bajoStockCount],
                ['etiqueta' => 'Categoría', 'valor' => $categoria ?: 'Todas'],
            ],
            'columnas' => ['Artículo', 'Categoría', 'Unidad', 'Stock Actual', 'Stock Mínimo', 'Estado'],
            'filas' => $filas,
        ];

        return [
            'autorizado' => true,
            'mensaje_defecto' => "Reporte de inventario listo con {$total} artículos ({$bajoStockCount} en alerta de stock).",
            'resumen_para_ia' => [
                'tipo_reporte' => 'inventario',
                'total_articulos' => $total,
                'en_alerta_stock' => $bajoStockCount,
                'categoria' => $categoria,
            ],
            'reporte' => $reporte,
        ];
    }

    /**
     * @param  array<string, mixed>  $args
     * @return array<string, mixed>
     */
    private function reporteAdopciones(array $args, User $user): array
    {
        $fechaDesde = $this->normalizarFecha($args['fecha_desde'] ?? null);
        $fechaHasta = $this->normalizarFecha($args['fecha_hasta'] ?? null);

        $query = DB::table('adopcions')
            ->join('mascotas', 'adopcions.id_mascota', '=', 'mascotas.id')
            ->join('interesado_adopcions', 'adopcions.id_interesado', '=', 'interesado_adopcions.id')
            ->whereRaw("LOWER(mascotas.estado_actual) LIKE '%adoptad%'")
            ->select(
                'adopcions.id',
                'adopcions.id_mascota',
                'adopcions.fecha_adopcion',
                'mascotas.nombre as mascota_nombre',
                'mascotas.especie',
                'mascotas.raza',
                'interesado_adopcions.nombre as adoptante_nombre',
                'interesado_adopcions.ci as adoptante_ci',
                'interesado_adopcions.telefono as adoptante_telefono'
            )
            ->orderByDesc('adopcions.fecha_adopcion')
            ->orderByDesc('adopcions.id');

        if ($fechaDesde !== null) {
            $query->where('adopcions.fecha_adopcion', '>=', $fechaDesde);
        }

        if ($fechaHasta !== null) {
            $query->where('adopcions.fecha_adopcion', '<=', $fechaHasta);
        }

        $registros = $query->get()->unique('id_mascota')->take(150)->values();
        $total = $registros->count();

        $filas = $registros->map(static fn (object $a): array => [
            "ADOP-#{$a->id}",
            (string) ($a->fecha_adopcion ?? '-'),
            (string) ($a->mascota_nombre ?? '-'),
            (string) (($a->especie ?? '-').' · '.($a->raza ?? 'Mestizo')),
            (string) ($a->adoptante_nombre ?? '-'),
            (string) ($a->adoptante_ci ?? '-'),
            (string) ($a->adoptante_telefono ?? '-'),
        ])->all();

        $reporte = [
            'tipo_reporte' => 'adopciones',
            'titulo' => 'Reporte de Adopciones Formalizadas',
            'subtitulo' => 'Registro legal de adopciones con mascota y familia adoptante',
            'generado_por' => $user->nombre,
            'fecha_generacion' => Carbon::now()->format('d/m/Y H:i'),
            'filtros' => [
                'fecha_desde' => $fechaDesde,
                'fecha_hasta' => $fechaHasta,
            ],
            'resumen' => [
                ['etiqueta' => 'Total Adopciones', 'valor' => (string) $total],
            ],
            'columnas' => ['Código', 'Fecha Adopción', 'Mascota', 'Especie / Raza', 'Adoptante', 'CI', 'Teléfono'],
            'filas' => $filas,
        ];

        return [
            'autorizado' => true,
            'mensaje_defecto' => "Reporte de adopciones listo con {$total} adopciones formalizadas.",
            'resumen_para_ia' => [
                'tipo_reporte' => 'adopciones',
                'total_adopciones' => $total,
            ],
            'reporte' => $reporte,
        ];
    }

    /**
     * @param  array<string, mixed>  $args
     * @return array<string, mixed>
     */
    private function reportePostulantes(array $args, User $user): array
    {
        $estado = isset($args['estado']) ? trim((string) $args['estado']) : null;

        $query = DB::table('interesado_adopcions')
            ->select('id', 'ci', 'nombre', 'telefono', 'direccion', 'situacion_casa', 'puntaje_evaluacion', 'estado')
            ->orderByRaw("CASE WHEN LOWER(estado) = 'pendiente' THEN 0 WHEN LOWER(estado) = 'en evaluación' THEN 1 WHEN LOWER(estado) = 'aprobado' THEN 2 ELSE 3 END")
            ->orderByDesc('id');

        if (! empty($estado)) {
            $query->whereRaw('LOWER(estado) LIKE ?', ['%'.mb_strtolower($estado, 'UTF-8').'%']);
        }

        $registros = $query->limit(150)->get();
        $total = $registros->count();
        $aprobados = $registros->filter(static fn (object $p): bool => mb_strtolower(trim((string) $p->estado)) === 'aprobado')->count();
        $pendientes = $registros->filter(static fn (object $p): bool => mb_strtolower(trim((string) $p->estado)) === 'pendiente')->count();
        $rechazados = $registros->filter(static fn (object $p): bool => mb_strtolower(trim((string) $p->estado)) === 'rechazado')->count();

        $filas = $registros->map(static function (object $p): array {
            $est = trim((string) ($p->estado ?? 'Pendiente'));
            $estLower = mb_strtolower($est, 'UTF-8');
            $estNorm = $estLower === 'aprobado' ? 'Aprobado' : ($estLower === 'pendiente' ? 'Pendiente' : ($estLower === 'rechazado' ? 'Rechazado' : $est));

            return [
                (string) ($p->ci ?? '-'),
                (string) ($p->nombre ?? '-'),
                (string) ($p->telefono ?? '-'),
                (string) ($p->situacion_casa ?? '-'),
                (string) ($p->puntaje_evaluacion ?? '0').' pts',
                $estNorm,
            ];
        })->all();

        $reporte = [
            'tipo_reporte' => 'postulantes',
            'titulo' => 'Reporte de Postulantes a Adopción',
            'subtitulo' => $estado ? "Filtro de estado: {$estado}" : 'Evaluación de idoneidad de postulantes registrados',
            'generado_por' => $user->nombre,
            'fecha_generacion' => Carbon::now()->format('d/m/Y H:i'),
            'filtros' => ['estado' => $estado],
            'resumen' => [
                ['etiqueta' => 'Total Postulantes', 'valor' => (string) $total],
                ['etiqueta' => 'Aprobados', 'valor' => (string) $aprobados],
                ['etiqueta' => 'Pendientes', 'valor' => (string) $pendientes],
                ['etiqueta' => 'Rechazados', 'valor' => (string) $rechazados],
            ],
            'columnas' => ['CI', 'Postulante', 'Teléfono', 'Vivienda', 'Puntaje', 'Estado'],
            'filas' => $filas,
        ];

        return [
            'autorizado' => true,
            'mensaje_defecto' => "Reporte de postulantes listo con {$total} registros ({$aprobados} aprobados, {$pendientes} pendientes y {$rechazados} rechazados).",
            'resumen_para_ia' => ['tipo_reporte' => 'postulantes', 'total' => $total, 'aprobados' => $aprobados, 'pendientes' => $pendientes],
            'reporte' => $reporte,
        ];
    }

    /**
     * @param  array<string, mixed>  $args
     * @return array<string, mixed>
     */
    private function reporteVisitasSeguimiento(array $args, User $user): array
    {
        $estado = isset($args['estado_seguimiento']) ? trim((string) $args['estado_seguimiento']) : null;

        $query = DB::table('seguimiento_adopcions')
            ->join('adopcions', 'seguimiento_adopcions.id_adopcion', '=', 'adopcions.id')
            ->join('mascotas', 'adopcions.id_mascota', '=', 'mascotas.id')
            ->join('interesado_adopcions', 'adopcions.id_interesado', '=', 'interesado_adopcions.id')
            ->select(
                'seguimiento_adopcions.id',
                'seguimiento_adopcions.fecha_programada',
                'seguimiento_adopcions.fecha_realizada',
                'seguimiento_adopcions.estado_seguimiento',
                'seguimiento_adopcions.reporte_bienestar',
                'mascotas.nombre as mascota_nombre',
                'interesado_adopcions.nombre as adoptante_nombre'
            )
            ->orderBy('seguimiento_adopcions.fecha_programada');

        if (! empty($estado)) {
            $estLower = mb_strtolower($estado, 'UTF-8');
            if (str_contains($estLower, 'pendient') || str_contains($estLower, 'program')) {
                $query->whereIn('seguimiento_adopcions.estado_seguimiento', ['Pendiente', 'Programado']);
            } else {
                $query->whereRaw('LOWER(seguimiento_adopcions.estado_seguimiento) LIKE ?', ['%'.$estLower.'%']);
            }
        }

        $registros = $query->limit(150)->get();
        $total = $registros->count();
        $pendientes = $registros->filter(
            static fn (object $s): bool => in_array($s->estado_seguimiento, ['Pendiente', 'Programado'], true)
        )->count();

        $filas = $registros->map(static fn (object $s): array => [
            "#{$s->id}",
            (string) ($s->mascota_nombre ?? '-'),
            (string) ($s->adoptante_nombre ?? '-'),
            (string) ($s->fecha_programada ?? '-'),
            (string) ($s->fecha_realizada ?: 'Pendiente'),
            (string) ($s->estado_seguimiento ?? '-'),
            (string) ($s->reporte_bienestar ?? '-'),
        ])->all();

        $reporte = [
            'tipo_reporte' => 'visitas_seguimiento',
            'titulo' => 'Reporte de Visitas de Seguimiento Post-Adopción',
            'subtitulo' => $estado ? "Visitas filtradas por estado: {$estado}" : 'Control domiciliario y bienestar animal',
            'generado_por' => $user->nombre,
            'fecha_generacion' => Carbon::now()->format('d/m/Y H:i'),
            'filtros' => ['estado_seguimiento' => $estado],
            'resumen' => [
                ['etiqueta' => 'Total Visitas', 'valor' => (string) $total],
                ['etiqueta' => 'Pendientes / Programadas', 'valor' => (string) $pendientes],
            ],
            'columnas' => ['Visita', 'Mascota', 'Adoptante', 'Programada', 'Realizada', 'Estado', 'Reporte de Bienestar'],
            'filas' => $filas,
        ];

        return [
            'autorizado' => true,
            'mensaje_defecto' => "Reporte de visitas post-adopción listo con {$total} visitas ({$pendientes} pendientes).",
            'resumen_para_ia' => ['tipo_reporte' => 'visitas_seguimiento', 'total' => $total, 'pendientes' => $pendientes],
            'reporte' => $reporte,
        ];
    }

    /**
     * @param  array<string, mixed>  $args
     * @return array<string, mixed>
     */
    private function reporteAtencionesClinicas(array $args, User $user): array
    {
        $tipoProc = isset($args['tipo_procedimiento']) ? trim((string) $args['tipo_procedimiento']) : null;
        $fechaDesde = $this->normalizarFecha($args['fecha_desde'] ?? null);
        $fechaHasta = $this->normalizarFecha($args['fecha_hasta'] ?? null);

        $query = DB::table('historial_clinicos')
            ->join('mascotas', 'historial_clinicos.id_mascota', '=', 'mascotas.id')
            ->leftJoin('users', 'historial_clinicos.id_usuario', '=', 'users.id')
            ->select(
                'historial_clinicos.id',
                'historial_clinicos.fecha_atencion',
                'mascotas.nombre as mascota_nombre',
                'mascotas.especie',
                'historial_clinicos.tipo_procedimiento',
                'historial_clinicos.diagnostico',
                'users.nombre as veterinario_nombre'
            )
            ->orderByDesc('historial_clinicos.fecha_atencion')
            ->orderByDesc('historial_clinicos.id');

        if (! empty($tipoProc)) {
            $query->whereRaw('LOWER(historial_clinicos.tipo_procedimiento) LIKE ?', ['%'.mb_strtolower($tipoProc, 'UTF-8').'%']);
        }
        if ($fechaDesde !== null) {
            $query->where('historial_clinicos.fecha_atencion', '>=', $fechaDesde);
        }
        if ($fechaHasta !== null) {
            $query->where('historial_clinicos.fecha_atencion', '<=', $fechaHasta);
        }

        $registros = $query->limit(150)->get();
        $total = $registros->count();

        $filas = $registros->map(static fn (object $h): array => [
            (string) ($h->fecha_atencion ?? '-'),
            (string) ($h->mascota_nombre ?? '-'),
            (string) ($h->especie ?? '-'),
            (string) ($h->tipo_procedimiento ?? '-'),
            (string) ($h->diagnostico ?? '-'),
            (string) ($h->veterinario_nombre ?? 'Veterinario'),
        ])->all();

        $reporte = [
            'tipo_reporte' => 'atenciones_clinicas',
            'titulo' => 'Reporte de Atenciones Clínicas Veterinarias',
            'subtitulo' => $tipoProc ? "Procedimiento: {$tipoProc}" : 'Historial médico de consultas, curaciones y cirugías',
            'generado_por' => $user->nombre,
            'fecha_generacion' => Carbon::now()->format('d/m/Y H:i'),
            'filtros' => ['tipo_procedimiento' => $tipoProc, 'fecha_desde' => $fechaDesde, 'fecha_hasta' => $fechaHasta],
            'resumen' => [
                ['etiqueta' => 'Total Atenciones', 'valor' => (string) $total],
            ],
            'columnas' => ['Fecha', 'Paciente', 'Especie', 'Procedimiento', 'Diagnóstico', 'Veterinario'],
            'filas' => $filas,
        ];

        return [
            'autorizado' => true,
            'mensaje_defecto' => "Reporte clínico veterinario listo con {$total} atenciones registradas.",
            'resumen_para_ia' => ['tipo_reporte' => 'atenciones_clinicas', 'total' => $total],
            'reporte' => $reporte,
        ];
    }

    /**
     * @param  array<string, mixed>  $args
     * @return array<string, mixed>
     */
    private function reporteFacturacionIva(array $args, User $user): array
    {
        $mes = (int) ($args['mes'] ?? now()->month);
        $anio = (int) ($args['anio'] ?? now()->year);

        $ventas = DB::table('facturas_legales')
            ->whereYear('fecha_emision', $anio)
            ->whereMonth('fecha_emision', $mes)
            ->orderBy('numero_factura')
            ->get();

        $totalVentas = 0.0;
        $totalDebito = 0.0;
        $filas = [];

        foreach ($ventas as $v) {
            $anulada = ($v->estado ?? '') === 'ANULADA';
            $imp = $anulada ? 0.0 : (float) $v->importe_total;
            $deb = $anulada ? 0.0 : (float) $v->debito_fiscal;
            $totalVentas += $imp;
            $totalDebito += $deb;

            $filas[] = [
                (string) $v->numero_factura,
                Carbon::parse((string) $v->fecha_emision)->format('d/m/Y'),
                $anulada ? '0' : (string) $v->nit_ci_cliente,
                $anulada ? 'ANULADA' : (string) $v->razon_social_cliente,
                $anulada ? 'A' : 'V',
                'Bs. '.number_format($imp, 2, '.', ''),
                'Bs. '.number_format($deb, 2, '.', ''),
            ];
        }

        $totalCredito = (float) (DB::table('facturas_compras')
            ->whereYear('fecha_factura', $anio)
            ->whereMonth('fecha_factura', $mes)
            ->sum('credito_fiscal') ?? 0);

        $saldoIva = round($totalDebito - $totalCredito, 2);

        $reporte = [
            'tipo_reporte' => 'facturacion_iva',
            'titulo' => "Libro de Ventas y Resumen IVA ({$mes}/{$anio})",
            'subtitulo' => 'Facturación legal computarizada y balance tributario SIN',
            'generado_por' => $user->nombre,
            'fecha_generacion' => Carbon::now()->format('d/m/Y H:i'),
            'filtros' => ['mes' => $mes, 'anio' => $anio],
            'resumen' => [
                ['etiqueta' => 'Facturas Período', 'valor' => (string) count($filas)],
                ['etiqueta' => 'Total Facturado', 'valor' => 'Bs. '.number_format($totalVentas, 2, '.', '')],
                ['etiqueta' => 'Débito Fiscal 13%', 'valor' => 'Bs. '.number_format($totalDebito, 2, '.', '')],
                ['etiqueta' => 'Crédito Fiscal 13%', 'valor' => 'Bs. '.number_format($totalCredito, 2, '.', '')],
                ['etiqueta' => 'Saldo IVA', 'valor' => 'Bs. '.number_format($saldoIva, 2, '.', '')],
            ],
            'columnas' => ['N° Factura', 'Fecha', 'NIT / CI', 'Razón Social', 'Est.', 'Importe Total', 'Débito 13%'],
            'filas' => $filas,
        ];

        return [
            'autorizado' => true,
            'mensaje_defecto' => "Reporte tributario IVA de {$mes}/{$anio} listo: ".count($filas).' facturas y débito fiscal de '.number_format($totalDebito, 2, '.', '').' bolivianos.',
            'resumen_para_ia' => ['tipo_reporte' => 'facturacion_iva', 'facturas' => count($filas), 'total_bs' => round($totalVentas, 2)],
            'reporte' => $reporte,
        ];
    }

    /**
     * @param  array<string, mixed>  $args
     * @return array<string, mixed>
     */
    private function reporteComprasProveedores(array $args, User $user): array
    {
        $fechaDesde = $this->normalizarFecha($args['fecha_desde'] ?? null);
        $fechaHasta = $this->normalizarFecha($args['fecha_hasta'] ?? null);

        $query = DB::table('compras')
            ->join('proveedors', 'compras.id_proveedor', '=', 'proveedors.id')
            ->leftJoin('users', 'compras.id_usuario', '=', 'users.id')
            ->select(
                'compras.id',
                'compras.fecha_compra',
                'compras.numero_documento',
                'compras.monto_total',
                'proveedors.nombre_empresa',
                'proveedors.tipo_insumo_provisto',
                'users.nombre as usuario_nombre'
            )
            ->orderByDesc('compras.fecha_compra')
            ->orderByDesc('compras.id');

        if ($fechaDesde !== null) {
            $query->where('compras.fecha_compra', '>=', $fechaDesde);
        }
        if ($fechaHasta !== null) {
            $query->where('compras.fecha_compra', '<=', $fechaHasta);
        }

        $registros = $query->limit(150)->get();
        $total = $registros->count();
        $montoTotal = (float) $registros->sum('monto_total');

        $filas = $registros->map(static fn (object $c): array => [
            (string) ($c->numero_documento ?: "COMP-#{$c->id}"),
            (string) ($c->fecha_compra ?? '-'),
            (string) ($c->nombre_empresa ?? '-'),
            (string) ($c->tipo_insumo_provisto ?? '-'),
            'Bs. '.number_format((float) $c->monto_total, 2, '.', ''),
            (string) ($c->usuario_nombre ?? '-'),
        ])->all();

        $reporte = [
            'tipo_reporte' => 'compras_proveedores',
            'titulo' => 'Reporte de Compras a Proveedores',
            'subtitulo' => 'Abastecimiento de alimentos, fármacos e insumos del refugio',
            'generado_por' => $user->nombre,
            'fecha_generacion' => Carbon::now()->format('d/m/Y H:i'),
            'filtros' => ['fecha_desde' => $fechaDesde, 'fecha_hasta' => $fechaHasta],
            'resumen' => [
                ['etiqueta' => 'Total Compras', 'valor' => (string) $total],
                ['etiqueta' => 'Inversión Total', 'valor' => 'Bs. '.number_format($montoTotal, 2, '.', '')],
            ],
            'columnas' => ['Documento', 'Fecha', 'Proveedor', 'Rubro', 'Monto Total', 'Registrado Por'],
            'filas' => $filas,
        ];

        return [
            'autorizado' => true,
            'mensaje_defecto' => "Reporte de compras listo: {$total} compras registradas por ".number_format($montoTotal, 2, '.', '').' bolivianos.',
            'resumen_para_ia' => ['tipo_reporte' => 'compras_proveedores', 'total' => $total, 'monto_bs' => round($montoTotal, 2)],
            'reporte' => $reporte,
        ];
    }

    /**
     * @param  array<string, mixed>  $args
     * @return array<string, mixed>
     */
    private function reporteSalidasMermas(array $args, User $user): array
    {
        $tipo = mb_strtolower(trim((string) ($args['tipo'] ?? 'todos')), 'UTF-8');

        if ($tipo === 'mermas') {
            $mermas = DB::table('ajuste_inventarios')
                ->join('articulo_inventarios', 'ajuste_inventarios.id_articulo', '=', 'articulo_inventarios.id')
                ->select(
                    'ajuste_inventarios.created_at',
                    'articulo_inventarios.nombre',
                    'articulo_inventarios.unidad_medida',
                    'ajuste_inventarios.cantidad',
                    'ajuste_inventarios.motivo',
                    'ajuste_inventarios.usuario_nombre'
                )
                ->orderByDesc('ajuste_inventarios.id')
                ->limit(100)
                ->get();

            $filas = $mermas->map(static fn (object $m): array => [
                Carbon::parse((string) $m->created_at)->format('d/m/Y H:i'),
                (string) $m->nombre,
                (string) $m->cantidad.' '.($m->unidad_medida ?? ''),
                (string) $m->motivo,
                (string) $m->usuario_nombre,
            ])->all();

            $reporte = [
                'tipo_reporte' => 'salidas_mermas',
                'titulo' => 'Reporte de Mermas y Ajustes de Inventario',
                'subtitulo' => 'Bajas por daño, caducidad o conteo físico',
                'generado_por' => $user->nombre,
                'fecha_generacion' => Carbon::now()->format('d/m/Y H:i'),
                'filtros' => ['tipo' => 'mermas'],
                'resumen' => [
                    ['etiqueta' => 'Total Mermas', 'valor' => (string) count($filas)],
                ],
                'columnas' => ['Fecha', 'Artículo', 'Cantidad Retirada', 'Motivo', 'Responsable'],
                'filas' => $filas,
            ];

            return [
                'autorizado' => true,
                'mensaje_defecto' => 'Reporte de mermas listo con '.count($filas).' registros.',
                'resumen_para_ia' => ['tipo_reporte' => 'mermas', 'total' => count($filas)],
                'reporte' => $reporte,
            ];
        }

        $salidas = DB::table('detalle_salidas')
            ->join('salida_inventarios', 'detalle_salidas.id_salida', '=', 'salida_inventarios.id')
            ->join('articulo_inventarios', 'detalle_salidas.id_articulo', '=', 'articulo_inventarios.id')
            ->leftJoin('users', 'salida_inventarios.id_usuario', '=', 'users.id')
            ->select(
                'salida_inventarios.fecha_salida',
                'articulo_inventarios.nombre',
                'articulo_inventarios.unidad_medida',
                'detalle_salidas.cantidad',
                'salida_inventarios.motivo',
                'users.nombre as usuario_nombre'
            )
            ->orderByDesc('salida_inventarios.fecha_salida')
            ->orderByDesc('detalle_salidas.id')
            ->limit(120)
            ->get();

        $filas = $salidas->map(static fn (object $s): array => [
            (string) ($s->fecha_salida ?? '-'),
            (string) ($s->nombre ?? '-'),
            (string) $s->cantidad.' '.($s->unidad_medida ?? ''),
            (string) ($s->motivo ?? '-'),
            (string) ($s->usuario_nombre ?? '-'),
        ])->all();

        $reporte = [
            'tipo_reporte' => 'salidas_mermas',
            'titulo' => 'Reporte de Salidas y Consumo de Despensa',
            'subtitulo' => 'Consumo operativo de alimentos e insumos del albergue',
            'generado_por' => $user->nombre,
            'fecha_generacion' => Carbon::now()->format('d/m/Y H:i'),
            'filtros' => ['tipo' => 'salidas'],
            'resumen' => [
                ['etiqueta' => 'Movimientos de Salida', 'valor' => (string) count($filas)],
            ],
            'columnas' => ['Fecha Salida', 'Artículo', 'Cantidad', 'Motivo / Destino', 'Responsable'],
            'filas' => $filas,
        ];

        return [
            'autorizado' => true,
            'mensaje_defecto' => 'Reporte de salidas de despensa listo con '.count($filas).' movimientos.',
            'resumen_para_ia' => ['tipo_reporte' => 'salidas', 'total' => count($filas)],
            'reporte' => $reporte,
        ];
    }

    private function normalizarFecha(mixed $valor): ?string
    {
        if (! is_string($valor) || trim($valor) === '') {
            return null;
        }

        try {
            return Carbon::parse($valor)->toDateString();
        } catch (\Throwable) {
            return null;
        }
    }
}
