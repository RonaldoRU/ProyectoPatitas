<?php

namespace Database\Seeders;

use App\Http\Controllers\P03_RescateClinicaAdopciones\MascotaController;
use App\Models\DosificacionFiscal;
use App\Models\User;
use App\Services\Facturacion\CodigoControlService;
use Carbon\Carbon;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class Ciclo4DatosCoherentesSeeder extends Seeder
{
    public function run(): void
    {
        $codigoControlService = app(CodigoControlService::class);

        $admin = User::query()->where('rol', 'Administrador')->where('activo', true)->first()
            ?? User::query()->where('rol', 'Administrador')->firstOrFail();
        $recepcionista = User::query()->where('rol', 'Recepcionista')->first() ?? $admin;
        $veterinarios = User::query()->where('rol', 'Veterinario')->pluck('id')->all();
        if (count($veterinarios) === 0) {
            $veterinarios = [$admin->id];
        }

        $todasMascotas = DB::table('mascotas')->orderBy('id')->get();
        foreach ($todasMascotas as $idx => $mItem) {
            $fotoUrl = MascotaController::resolverFotoPorRaza(
                (string) $mItem->especie,
                (string) ($mItem->raza ?? ''),
                (int) $mItem->id,
                (string) $mItem->nombre
            );
            $estado = ($idx % 5 === 3) ? 'En Recuperación' : (($idx % 5 === 4) ? 'Adoptado' : 'Disponible');
            DB::table('mascotas')->where('id', $mItem->id)->update([
                'foto' => $fotoUrl,
                'estado_actual' => $estado,
            ]);
        }

        $mascotas = DB::table('mascotas')->select('id', 'nombre')->limit(30)->get();
        $articulos = DB::table('articulo_inventarios')->select('id', 'nombre', 'unidad_medida')->limit(20)->get();
        $proveedores = DB::table('proveedors')->select('id', 'nombre_empresa', 'identificacion')->limit(15)->get();
        $lotes = DB::table('inventario_lotes')->select('id', 'id_articulo')->orderBy('fecha_vencimiento')->get();

        // Limpiar tablas Ciclo 4 para re-sembrado coherente sin duplicados
        if (DB::getDriverName() === 'pgsql') {
            DB::statement('TRUNCATE TABLE detalle_facturas_legales, facturas_legales, dosificaciones_fiscales, cronograma_tratamientos, prescripciones_dosificacion, facturas_compras, cierres_periodos_reportes, auditoria_forense RESTART IDENTITY CASCADE');
        } else {
            DB::table('detalle_facturas_legales')->delete();
            DB::table('facturas_legales')->delete();
            DB::table('dosificaciones_fiscales')->delete();
            DB::table('cronograma_tratamientos')->delete();
            DB::table('prescripciones_dosificacion')->delete();
            DB::table('facturas_compras')->delete();
            DB::table('cierres_periodos_reportes')->delete();
            DB::table('auditoria_forense')->delete();
        }

        $eventosForenses = [];
        $eventosBitacora = [];

        // Conservar bitácora previa ajustando fechas dentro de Enero–Noviembre 2026 si corresponde
        $bitacorasPrevias = DB::table('bitacoras')->orderBy('created_at')->get();
        foreach ($bitacorasPrevias as $b) {
            $fecha = $b->created_at ? Carbon::parse($b->created_at) : Carbon::create(2026, 1, 10, 9, 0, 0);
            if ($fecha->year !== 2026 || $fecha->gt(Carbon::create(2026, 11, 12, 23, 59, 59))) {
                $fecha = Carbon::create(2026, random_int(1, 10), random_int(1, 28), random_int(8, 18), random_int(0, 59));
            }
            $eventosBitacora[] = [
                'tipo_accion' => $b->tipo_accion,
                'id_usuario' => $b->id_usuario,
                'created_at' => $fecha->toDateTimeString(),
                'updated_at' => $fecha->toDateTimeString(),
                'usuario_nombre' => $b->usuario_nombre,
                'modulo' => $b->modulo ?? 'general',
                'descripcion' => $b->descripcion ?? $b->tipo_accion,
                'entidad_tipo' => $b->entidad_tipo,
                'entidad_id' => $b->entidad_id,
                'ip' => $b->ip ?? '127.0.0.1',
                'http_method' => $b->http_method ?? 'POST',
                'ruta' => $b->ruta ?? '/api/sistema',
                'resultado' => $b->resultado ?? 'exitosa',
                'contexto' => $b->contexto,
            ];
        }

        // 1. Dosificaciones Fiscales (Semestre 1 y Semestre 2 de 2026)
        $dosif1 = DosificacionFiscal::query()->create([
            'nit_emisor' => '1020304021',
            'numero_autorizacion' => '290400202601',
            'llave_dosificacion' => 'zZ7Z]xssKqkEf_6K9uH(551234AB',
            'numero_inicial' => 1,
            'numero_final' => 500,
            'correlativo_actual' => 25,
            'fecha_limite_emision' => '2026-06-30',
            'leyenda_tributaria' => 'Ley N° 453: Tienes derecho a recibir información sobre las características y contenidos de los servicios que utilices.',
            'activa' => false,
            'created_by' => $admin->id,
            'created_at' => '2026-01-02 08:30:00',
            'updated_at' => '2026-06-30 18:00:00',
        ]);

        $dosif2 = DosificacionFiscal::query()->create([
            'nit_emisor' => '1020304021',
            'numero_autorizacion' => '290400202602',
            'llave_dosificacion' => 'A9pQ#7mK2xR!8vN4wL1zC6yB3tD',
            'numero_inicial' => 501,
            'numero_final' => 1500,
            'correlativo_actual' => 521,
            'fecha_limite_emision' => '2026-12-31',
            'leyenda_tributaria' => 'Ley N° 453: Tienes derecho a recibir información sobre las características y contenidos de los servicios que utilices.',
            'activa' => true,
            'created_by' => $admin->id,
            'created_at' => '2026-07-01 08:15:00',
            'updated_at' => '2026-11-12 16:00:00',
        ]);

        $clientes = [
            ['nit' => '4589123', 'razon' => 'Roberto Carlos Justiniano'],
            ['nit' => '7812345', 'razon' => 'María Elena Suárez'],
            ['nit' => '3298451', 'razon' => 'Clínica Aliada Santa Cruz'],
            ['nit' => '6541298', 'razon' => 'Fernanda Paz Ribera'],
            ['nit' => '8912304', 'razon' => 'Comercial Agropecuaria Oriente'],
        ];

        $conceptos = [
            ['concepto' => 'Consulta veterinaria general y valoración', 'precio' => 120.00],
            ['concepto' => 'Vacunación antirrábica y carnet sanitario', 'precio' => 85.00],
            ['concepto' => 'Desparasitación interna y externa', 'precio' => 65.00],
            ['concepto' => 'Esterilización quirúrgica controlada', 'precio' => 350.00],
            ['concepto' => 'Curación y tratamiento dermatológico', 'precio' => 140.00],
        ];

        $corr1 = 1;
        $corr2 = 501;

        // 2. Generar datos coherentes mes a mes (Enero 2026 -> 12 Noviembre 2026)
        for ($mes = 1; $mes <= 11; $mes++) {
            $maxDia = $mes === 11 ? 12 : Carbon::create(2026, $mes, 1)->daysInMonth;
            $dosifActual = $mes <= 6 ? $dosif1 : $dosif2;
            $llaveActual = $mes <= 6 ? 'zZ7Z]xssKqkEf_6K9uH(551234AB' : 'A9pQ#7mK2xR!8vN4wL1zC6yB3tD';

            // 4 Facturas legales por mes (44 en total)
            for ($k = 0; $k < 4; $k++) {
                $dia = min($maxDia, 3 + ($k * 6));
                $fechaFactura = Carbon::create(2026, $mes, $dia, 9 + $k * 2, 15 + $k * 7, 0);
                $nroFactura = $mes <= 6 ? $corr1++ : $corr2++;
                $cliente = $clientes[($mes + $k) % count($clientes)];
                $item = $conceptos[($mes + $k) % count($conceptos)];

                $cantidad = ($k % 2 === 0) ? 1 : 2;
                $subtotal = round($item['precio'] * $cantidad, 2);
                $descuento = ($k === 3) ? 10.00 : 0.00;
                $total = round($subtotal - $descuento, 2);
                $debito = round($total * 0.13, 2);

                $codigoControl = $codigoControlService->generar(
                    $dosifActual->numero_autorizacion,
                    $nroFactura,
                    $cliente['nit'],
                    $fechaFactura->format('Ymd'),
                    $total,
                    $llaveActual
                );

                $cadenaQr = implode('|', [
                    $dosifActual->nit_emisor,
                    $nroFactura,
                    $dosifActual->numero_autorizacion,
                    $fechaFactura->format('d/m/Y'),
                    number_format($total, 2, '.', ''),
                    number_format($total, 2, '.', ''),
                    $codigoControl,
                    $cliente['nit'],
                    '0.00',
                    '0.00',
                    number_format($descuento, 2, '.', ''),
                ]);

                $anular = ($mes % 3 === 0 && $k === 2);
                $fechaAnulacion = $anular ? $fechaFactura->copy()->addHours(3) : null;

                $facturaId = DB::table('facturas_legales')->insertGetId([
                    'dosificacion_id' => $dosifActual->id,
                    'numero_factura' => $nroFactura,
                    'numero_autorizacion' => $dosifActual->numero_autorizacion,
                    'fecha_emision' => $fechaFactura->toDateTimeString(),
                    'nit_ci_cliente' => $cliente['nit'],
                    'complemento_ci' => null,
                    'razon_social_cliente' => $cliente['razon'],
                    'subtotal' => $subtotal,
                    'descuento' => $descuento,
                    'importe_total' => $total,
                    'importe_base_cf' => $total,
                    'debito_fiscal' => $debito,
                    'codigo_control' => $codigoControl,
                    'cadena_qr' => $cadenaQr,
                    'estado' => $anular ? 'ANULADA' : 'EMITIDA',
                    'motivo_anulacion' => $anular ? 'Error en transcripción de razón social' : null,
                    'fecha_anulacion' => $fechaAnulacion?->toDateTimeString(),
                    'usuario_emisor_id' => $recepcionista->id,
                    'usuario_anulador_id' => $anular ? $admin->id : null,
                    'created_at' => $fechaFactura->toDateTimeString(),
                    'updated_at' => ($fechaAnulacion ?? $fechaFactura)->toDateTimeString(),
                ]);

                DB::table('detalle_facturas_legales')->insert([
                    'factura_id' => $facturaId,
                    'concepto' => $item['concepto'],
                    'cantidad' => $cantidad,
                    'precio_unitario' => $item['precio'],
                    'subtotal' => $subtotal,
                    'referencia_tipo' => 'CONSULTA_MEDICA',
                    'referencia_id' => null,
                ]);

                $eventosForenses[] = $this->armarEventoForense($fechaFactura, $recepcionista->id, 'INFO', 'P11_FacturacionLegal', 'EMITIR_FACTURA', 'facturas_legales', $facturaId, null, ['numero_factura' => $nroFactura, 'importe_total' => $total]);
                $eventosBitacora[] = $this->armarEventoBitacora($fechaFactura, $recepcionista, 'Emitir factura legal', 'facturacion', "Factura N° {$nroFactura} por Bs. {$total}", 'FacturaLegal', $facturaId);

                if ($anular && $fechaAnulacion !== null) {
                    $eventosForenses[] = $this->armarEventoForense($fechaAnulacion, $admin->id, 'CRITICAL', 'P11_FacturacionLegal', 'ANULAR_FACTURA', 'facturas_legales', $facturaId, ['estado' => 'EMITIDA'], ['estado' => 'ANULADA']);
                    $eventosBitacora[] = $this->armarEventoBitacora($fechaAnulacion, $admin, 'Anular factura legal', 'facturacion', "Anulación de Factura N° {$nroFactura}", 'FacturaLegal', $facturaId);
                }
            }

            // 2 Facturas de compra por mes (22 en total)
            if ($proveedores->count() > 0) {
                for ($c = 0; $c < 2; $c++) {
                    $prov = $proveedores[($mes + $c) % $proveedores->count()];
                    $diaCompra = min($maxDia, 6 + ($c * 10));
                    $fechaCompra = Carbon::create(2026, $mes, $diaCompra, 11 + $c, 20, 0);
                    $totalCompra = round(280 + ($mes * 25) + ($c * 95), 2);
                    $credito = round($totalCompra * 0.13, 2);

                    $compraId = DB::table('facturas_compras')->insertGetId([
                        'proveedor_id' => $prov->id,
                        'fecha_factura' => $fechaCompra->toDateString(),
                        'nit_proveedor' => $prov->identificacion ?: ('10020030'.$prov->id),
                        'razon_social_proveedor' => $prov->nombre_empresa,
                        'numero_factura' => 'FC-2026-'.str_pad((string) (($mes * 10) + $c), 4, '0', STR_PAD_LEFT),
                        'numero_autorizacion' => '3904002026'.str_pad((string) $mes, 2, '0', STR_PAD_LEFT),
                        'codigo_control' => strtoupper(substr(md5("compra-{$mes}-{$c}"), 0, 10)),
                        'importe_total' => $totalCompra,
                        'importe_exento' => 0.00,
                        'importe_base_cf' => $totalCompra,
                        'credito_fiscal' => $credito,
                        'registrado_por' => $admin->id,
                        'created_at' => $fechaCompra->toDateTimeString(),
                    ]);

                    $eventosForenses[] = $this->armarEventoForense($fechaCompra, $admin->id, 'INFO', 'P13_ReportesFiscales', 'REGISTRAR_FACTURA_COMPRA', 'facturas_compras', $compraId, null, ['importe_total' => $totalCompra]);
                    $eventosBitacora[] = $this->armarEventoBitacora($fechaCompra, $admin, 'Registrar factura de compra IVA', 'reportes_fiscales', "Compra a {$prov->nombre_empresa} por Bs. {$totalCompra}", 'FacturaCompra', $compraId);
                }
            }

            // 2 Prescripciones clínicas con cronograma FEFO por mes (22 en total)
            if ($mascotas->count() > 0 && $articulos->count() > 0) {
                for ($p = 0; $p < 2; $p++) {
                    $mascota = $mascotas[($mes * 2 + $p) % $mascotas->count()];
                    $articulo = $articulos[($mes + $p) % $articulos->count()];
                    $vetId = $veterinarios[($mes + $p) % count($veterinarios)];
                    $lote = $lotes->firstWhere('id_articulo', $articulo->id) ?? $lotes->first();

                    $diaPresc = min($maxDia, 4 + ($p * 9));
                    $fechaPresc = Carbon::create(2026, $mes, $diaPresc, 10 + $p, 40, 0);
                    $peso = 8.5 + ($p * 4.0);
                    $dosisMgKg = 10.0;
                    $concentracion = 50.0;
                    $dosisCalc = round(($peso * $dosisMgKg) / $concentracion, 3);

                    $prescId = DB::table('prescripciones_dosificacion')->insertGetId([
                        'mascota_id' => $mascota->id,
                        'articulo_id' => $articulo->id,
                        'veterinario_id' => $vetId,
                        'peso_mascota_kg' => $peso,
                        'dosis_mg_kg' => $dosisMgKg,
                        'concentracion_farmaco' => $concentracion,
                        'dosis_calculada_unidad' => $dosisCalc,
                        'unidad_medida' => $articulo->unidad_medida ?: 'ml',
                        'frecuencia_horas' => 12,
                        'duracion_dias' => 3,
                        'observaciones_clinicas' => "Tratamiento programado para {$mascota->nombre} con control FEFO.",
                        'estado' => $mes < 11 ? 'COMPLETADO' : 'ACTIVO',
                        'created_at' => $fechaPresc->toDateTimeString(),
                        'updated_at' => $fechaPresc->toDateTimeString(),
                    ]);

                    for ($t = 0; $t < 4; $t++) {
                        $tomaFecha = $fechaPresc->copy()->addHours($t * 12);
                        $yaPaso = $tomaFecha->lte(Carbon::create(2026, 11, 12, 18, 0, 0));
                        DB::table('cronograma_tratamientos')->insert([
                            'prescripcion_id' => $prescId,
                            'lote_inventario_id' => $lote?->id,
                            'fecha_hora_programada' => $tomaFecha->toDateTimeString(),
                            'fecha_hora_administrada' => $yaPaso ? $tomaFecha->copy()->addMinutes(5)->toDateTimeString() : null,
                            'administrado_por' => $yaPaso ? $vetId : null,
                            'estado' => $yaPaso ? 'ADMINISTRADO' : 'PENDIENTE',
                            'notas' => $yaPaso ? 'Dosis aplicada sin novedades.' : null,
                        ]);
                    }

                    $eventosForenses[] = $this->armarEventoForense($fechaPresc, $vetId, 'INFO', 'P12_ControlClinicoSeguridad', 'CREAR_DOSIFICACION_CLINICA', 'prescripciones_dosificacion', $prescId, null, ['mascota' => $mascota->nombre, 'dosis' => $dosisCalc]);
                    $eventosBitacora[] = $this->armarEventoBitacora($fechaPresc, User::find($vetId) ?? $admin, 'Programar dosificación clínica', 'clinica', "Prescripción FEFO para {$mascota->nombre}", 'PrescripcionDosificacion', $prescId);
                }
            }

            // Cierre mensual de Libro IVA y Rendición trimestral
            $fechaCierre = Carbon::create(2026, $mes, $maxDia, 17, 50, 0);
            DB::table('cierres_periodos_reportes')->insert([
                'anio' => 2026,
                'mes' => $mes,
                'tipo_reporte' => 'LIBRO_VENTAS',
                'periodo_cerrado' => $mes < 11,
                'hash_documento' => hash('sha256', "libro-ventas-2026-{$mes}"),
                'generado_por' => $admin->id,
                'created_at' => $fechaCierre->toDateTimeString(),
            ]);

            if (in_array($mes, [3, 6, 9, 11], true)) {
                DB::table('cierres_periodos_reportes')->insert([
                    'anio' => 2026,
                    'mes' => $mes,
                    'tipo_reporte' => 'RENDICION_CUENTAS',
                    'periodo_cerrado' => $mes < 11,
                    'hash_documento' => hash('sha256', "rendicion-2026-{$mes}"),
                    'generado_por' => $admin->id,
                    'created_at' => $fechaCierre->copy()->addMinutes(5)->toDateTimeString(),
                ]);
            }
        }

        // 3. Ordenar cronológicamente TODA la auditoría forense y TODA la bitácora (Enero -> 12/11/2026)
        usort($eventosForenses, static fn (array $a, array $b): int => strcmp($a['fecha_evento'], $b['fecha_evento']));
        foreach (array_chunk($eventosForenses, 50) as $chunk) {
            DB::table('auditoria_forense')->insert($chunk);
        }

        usort($eventosBitacora, static fn (array $a, array $b): int => strcmp($a['created_at'], $b['created_at']));
        if (DB::getDriverName() === 'pgsql') {
            DB::statement('TRUNCATE TABLE bitacoras RESTART IDENTITY CASCADE');
        } else {
            DB::table('bitacoras')->delete();
        }
        foreach (array_chunk($eventosBitacora, 50) as $chunk) {
            DB::table('bitacoras')->insert($chunk);
        }
    }

    /**
     * @param  array<string, mixed>|null  $anterior
     * @param  array<string, mixed>|null  $nuevo
     * @return array<string, mixed>
     */
    private function armarEventoForense(
        Carbon $fecha,
        int $usuarioId,
        string $severidad,
        string $modulo,
        string $accion,
        string $tabla,
        int $registroId,
        ?array $anterior,
        ?array $nuevo
    ): array {
        $payloadBase = json_encode([
            'fecha' => $fecha->toIso8601String(),
            'usuario_id' => $usuarioId,
            'severidad' => $severidad,
            'modulo' => $modulo,
            'accion' => $accion,
            'tabla' => $tabla,
            'registro_id' => (string) $registroId,
            'anterior' => $anterior,
            'nuevo' => $nuevo,
        ], JSON_UNESCAPED_UNICODE) ?: '';

        return [
            'fecha_evento' => $fecha->toDateTimeString(),
            'usuario_id' => $usuarioId,
            'ip_origen' => '192.168.1.'.random_int(10, 90),
            'user_agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
            'severidad' => $severidad,
            'modulo' => $modulo,
            'accion' => $accion,
            'tabla_afectada' => $tabla,
            'registro_id' => (string) $registroId,
            'payload_anterior' => $anterior ? json_encode($anterior) : null,
            'payload_nuevo' => $nuevo ? json_encode($nuevo) : null,
            'hash_integridad' => hash('sha256', $payloadBase),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function armarEventoBitacora(
        Carbon $fecha,
        User $usuario,
        string $tipoAccion,
        string $modulo,
        string $descripcion,
        string $entidadTipo,
        int $entidadId
    ): array {
        return [
            'tipo_accion' => $tipoAccion,
            'id_usuario' => $usuario->id,
            'created_at' => $fecha->toDateTimeString(),
            'updated_at' => $fecha->toDateTimeString(),
            'usuario_nombre' => $usuario->nombre,
            'modulo' => $modulo,
            'descripcion' => $descripcion,
            'entidad_tipo' => $entidadTipo,
            'entidad_id' => (string) $entidadId,
            'ip' => '192.168.1.25',
            'http_method' => 'POST',
            'ruta' => "/api/{$modulo}",
            'resultado' => 'exitosa',
            'contexto' => json_encode(['fecha_operacion' => $fecha->toDateString()]),
        ];
    }
}
