<?php

use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;

function createVoiceTestUser(string $rol = 'Recepcionista'): string
{
    $user = new User([
        'nombre' => 'Test User Voice',
        'email' => 'voice-test-'.uniqid().'@example.org',
        'rol' => $rol,
        'password' => 'password123',
    ]);
    $user->forceFill(['telefono' => '70000000'])->save();

    return $user->createToken('voice-token')->plainTextToken;
}

function seedVoiceReportFixtures(): void
{
    $now = now()->toDateTimeString();
    $today = now()->toDateString();

    $userId = DB::table('users')->value('id')
        ?? DB::table('users')->insertGetId([
            'nombre' => 'Seed User',
            'email' => 'seed-'.uniqid().'@example.org',
            'rol' => 'Administrador',
            'password' => bcrypt('password123'),
            'telefono' => '70000001',
            'created_at' => $now,
            'updated_at' => $now,
        ]);

    $mascotaId = DB::table('mascotas')->insertGetId([
        'nombre' => 'Firulais',
        'especie' => 'Canino',
        'raza' => 'Mestizo',
        'sexo' => 'Macho',
        'edad' => '2 años',
        'estado_actual' => 'Disponible',
        'zona_rescate' => 'Zona Sur',
        'fecha_ingreso' => $today,
        'foto' => '/images/default-pet.png',
        'created_at' => $now,
        'updated_at' => $now,
    ]);

    $articuloId = DB::table('articulo_inventarios')->insertGetId([
        'nombre' => 'Vacuna Triple',
        'categoria' => 'Medicamento',
        'unidad_medida' => 'Dosis',
        'stock_actual' => 10,
        'stock_minimo_alerta' => 5,
        'created_at' => $now,
        'updated_at' => $now,
    ]);

    $interesadoId = DB::table('interesado_adopcions')->insertGetId([
        'ci' => '1234567',
        'nombre' => 'Ana Postulante',
        'telefono' => '71234567',
        'direccion' => 'Av. Principal 10',
        'situacion_casa' => 'Casa propia con patio',
        'referencias' => 'Vecino verificado',
        'puntaje_evaluacion' => 88,
        'estado' => 'Aprobado',
        'created_at' => $now,
        'updated_at' => $now,
    ]);

    DB::table('interesado_adopcions')->insert([
        'ci' => '7654321',
        'nombre' => 'Luis Pendiente',
        'telefono' => '77654321',
        'direccion' => 'Calle Secundaria 20',
        'situacion_casa' => 'Departamento',
        'referencias' => 'Familiar',
        'puntaje_evaluacion' => 70,
        'estado' => 'Pendiente',
        'created_at' => $now,
        'updated_at' => $now,
    ]);

    $adopcionId = DB::table('adopcions')->insertGetId([
        'id_mascota' => $mascotaId,
        'id_interesado' => $interesadoId,
        'fecha_adopcion' => $today,
        'created_at' => $now,
        'updated_at' => $now,
    ]);

    DB::table('seguimiento_adopcions')->insert([
        'id_adopcion' => $adopcionId,
        'id_usuario' => $userId,
        'estado_seguimiento' => 'Pendiente',
        'fecha_programada' => $today,
        'fecha_realizada' => $today,
        'reporte_bienestar' => 'Control inicial programado',
        'fotografia' => '/images/default-check.png',
        'created_at' => $now,
        'updated_at' => $now,
    ]);

    DB::table('historial_clinicos')->insert([
        'id_mascota' => $mascotaId,
        'id_usuario' => $userId,
        'fecha_atencion' => $today,
        'tipo_procedimiento' => 'Consulta General',
        'diagnostico' => 'Sano',
        'observacion' => 'Control rutinario',
        'created_at' => $now,
        'updated_at' => $now,
    ]);

    $dosificacionId = DB::table('dosificaciones_fiscales')->insertGetId([
        'nit_emisor' => '1020304050',
        'numero_autorizacion' => '2904001122334',
        'llave_dosificacion' => 'ABC123DEF456',
        'numero_inicial' => 1,
        'numero_final' => 1000,
        'correlativo_actual' => 1,
        'fecha_limite_emision' => now()->addYear()->toDateString(),
        'leyenda_tributaria' => 'Ley N° 453',
        'activa' => true,
        'created_by' => $userId,
        'created_at' => $now,
        'updated_at' => $now,
    ]);

    DB::table('facturas_legales')->insert([
        'dosificacion_id' => $dosificacionId,
        'numero_factura' => 1,
        'numero_autorizacion' => '2904001122334',
        'fecha_emision' => $now,
        'nit_ci_cliente' => '9988776',
        'razon_social_cliente' => 'Cliente Test',
        'subtotal' => 100.00,
        'descuento' => 0.00,
        'importe_total' => 100.00,
        'importe_base_cf' => 100.00,
        'debito_fiscal' => 13.00,
        'codigo_control' => 'AA-BB-CC-11',
        'cadena_qr' => 'QR-TEST',
        'estado' => 'Válida',
        'usuario_emisor_id' => $userId,
        'created_at' => $now,
        'updated_at' => $now,
    ]);

    $proveedorId = DB::table('proveedors')->insertGetId([
        'nombre_empresa' => 'VetSupply SRL',
        'nombre_contacto' => 'Carlos Ruiz',
        'direccion' => 'Av. Industrial 50',
        'telefono' => '22445566',
        'identificacion' => 'NIT-100200300',
        'tipo_insumo_provisto' => 'Insumos Veterinarios',
        'activo' => true,
        'estado' => 'Activo',
        'created_at' => $now,
        'updated_at' => $now,
    ]);

    DB::table('compras')->insert([
        'id_proveedor' => $proveedorId,
        'id_usuario' => $userId,
        'fecha_compra' => $today,
        'monto_total' => 250.00,
        'numero_documento' => 'FAC-0001',
        'created_at' => $now,
        'updated_at' => $now,
    ]);

    DB::table('ajuste_inventarios')->insert([
        'id_articulo' => $articuloId,
        'id_usuario' => $userId,
        'usuario_nombre' => 'Test User Voice',
        'cantidad' => 2,
        'stock_anterior' => 10,
        'stock_nuevo' => 8,
        'saldo_disponible_anterior' => 10,
        'saldo_disponible_nuevo' => 8,
        'motivo' => 'Producto vencido',
        'created_at' => $now,
        'updated_at' => $now,
    ]);
}

test('endpoint de info de IA retorna configuracion especializada en reportes y herramientas', function () {
    $token = createVoiceTestUser();

    $response = $this->withToken($token)->getJson('/api/ia/info');

    $response->assertOk()
        ->assertJsonStructure([
            'proveedor',
            'modo',
            'modelo',
            'configurado_en_env',
            'especialidad',
            'herramientas',
        ])
        ->assertJson([
            'proveedor' => 'Google Gemini',
            'especialidad' => 'reportes_pdf',
        ]);
});

test('clasificador local genera reporte de mascotas y rechaza comandos fuera de alcance', function () {
    $token = createVoiceTestUser('Recepcionista');
    seedVoiceReportFixtures();
    config(['services.gemini.api_key' => null]);

    $reporteResponse = $this->withToken($token)->postJson('/api/ia/comando-voz', [
        'comando' => 'quiero un reporte de perros en adopcion',
        'contexto_pantalla' => '/mascotas',
    ]);

    $reporteResponse->assertOk()
        ->assertJson([
            'accion' => 'generar_reporte_pdf',
            'motor_usado' => 'Local (NLU)',
            'herramienta_usada' => 'generar_reporte_mascotas',
        ])
        ->assertJsonStructure([
            'reporte' => ['tipo_reporte', 'titulo', 'subtitulo', 'resumen', 'columnas', 'filas'],
        ]);

    $fueraResponse = $this->withToken($token)->postJson('/api/ia/comando-voz', [
        'comando' => 'cerrar sesion ahora',
        'contexto_pantalla' => '/mascotas',
    ]);

    $fueraResponse->assertOk()
        ->assertJson([
            'accion' => 'fuera_de_alcance',
            'motor_usado' => 'Local (NLU)',
            'reporte' => null,
        ]);
});

test('comando de voz usa Gemini Tool Calling para generar reporte de inventario en texto', function () {
    $token = createVoiceTestUser('Recepcionista');
    seedVoiceReportFixtures();
    config([
        'services.gemini.api_key' => 'fake-gemini-key',
        'services.gemini.model' => 'gemini-1.5-flash',
    ]);

    Http::fake([
        'generativelanguage.googleapis.com/*' => Http::sequence()
            ->push([
                'candidates' => [
                    [
                        'content' => [
                            'parts' => [
                                [
                                    'functionCall' => [
                                        'name' => 'generar_reporte_inventario',
                                        'args' => [
                                            'solo_bajo_stock' => true,
                                        ],
                                    ],
                                ],
                            ],
                        ],
                    ],
                ],
            ], 200)
            ->push([
                'candidates' => [
                    [
                        'content' => [
                            'parts' => [
                                [
                                    'text' => 'Tu reporte de stock crítico está listo para imprimir en PDF.',
                                ],
                            ],
                        ],
                    ],
                ],
            ], 200),
    ]);

    $response = $this->withToken($token)->postJson('/api/ia/comando-voz', [
        'comando' => 'dame un reporte de articulos con stock bajo',
        'contexto_pantalla' => '/articulos-inventario',
    ]);

    $response->assertOk()
        ->assertJson([
            'accion' => 'generar_reporte_pdf',
            'mensaje_hablado' => 'Tu reporte de stock crítico está listo para imprimir en PDF.',
            'motor_usado' => 'Google Gemini (gemini-1.5-flash)',
            'herramienta_usada' => 'generar_reporte_inventario',
        ])
        ->assertJsonPath('reporte.tipo_reporte', 'inventario');
});

test('comando de voz procesa audio con Gemini Tool Calling para reporte gerencial de administrador', function () {
    $token = createVoiceTestUser('Administrador');
    config([
        'services.gemini.api_key' => 'fake-gemini-key',
        'services.gemini.model' => 'gemini-1.5-flash',
    ]);

    Http::fake([
        'generativelanguage.googleapis.com/*' => Http::sequence()
            ->push([
                'candidates' => [
                    [
                        'content' => [
                            'parts' => [
                                [
                                    'functionCall' => [
                                        'name' => 'generar_reporte_gerencial',
                                        'args' => [
                                            'meses' => 6,
                                        ],
                                    ],
                                ],
                            ],
                        ],
                    ],
                ],
            ], 200)
            ->push([
                'candidates' => [
                    [
                        'content' => [
                            'parts' => [
                                [
                                    'text' => 'Aquí tienes el informe gerencial de los últimos seis meses listo en PDF.',
                                ],
                            ],
                        ],
                    ],
                ],
            ], 200),
    ]);

    $response = $this->withToken($token)->postJson('/api/ia/comando-voz', [
        'audio' => base64_encode('fake-audio-bytes'),
        'audio_mime' => 'audio/webm',
        'contexto_pantalla' => '/reportes-gerenciales',
    ]);

    $response->assertOk()
        ->assertJson([
            'accion' => 'generar_reporte_pdf',
            'mensaje_hablado' => 'Aquí tienes el informe gerencial de los últimos seis meses listo en PDF.',
            'motor_usado' => 'Google Gemini (gemini-1.5-flash)',
            'herramienta_usada' => 'generar_reporte_gerencial',
        ])
        ->assertJsonPath('reporte.tipo_reporte', 'gerencial');
});

test('voluntario no puede generar reportes mediante el asistente de voz', function () {
    $token = createVoiceTestUser('Voluntario');
    config(['services.gemini.api_key' => null]);

    $response = $this->withToken($token)->postJson('/api/ia/comando-voz', [
        'comando' => 'reporte de mascotas',
        'contexto_pantalla' => '/mascotas',
    ]);

    $response->assertOk()
        ->assertJson([
            'accion' => 'fuera_de_alcance',
            'reporte' => null,
        ]);
});

test('clasificador local genera reportes especificos con datos reales y omite PDF cuando no existen datos', function () {
    $token = createVoiceTestUser('Administrador');
    seedVoiceReportFixtures();
    config(['services.gemini.api_key' => null]);

    // 1. Reportes que sí tienen datos reales en la BD deben generar PDF
    $casosConDatos = [
        ['comando' => 'reporte de inventario con stock bajo', 'tipo' => 'inventario'],
        ['comando' => 'reporte de visitas pendientes', 'tipo' => 'visitas_seguimiento'],
        ['comando' => 'reporte de postulantes a adopcion', 'tipo' => 'postulantes'],
        ['comando' => 'reporte de atenciones clinicas', 'tipo' => 'atenciones_clinicas'],
        ['comando' => 'reporte de facturacion libro iva', 'tipo' => 'facturacion_iva'],
        ['comando' => 'reporte de compras a proveedores', 'tipo' => 'compras_proveedores'],
        ['comando' => 'reporte de mermas de inventario', 'tipo' => 'salidas_mermas'],
    ];

    foreach ($casosConDatos as $caso) {
        $res = $this->withToken($token)->postJson('/api/ia/comando-voz', [
            'comando' => $caso['comando'],
            'contexto_pantalla' => '/dashboard',
        ]);

        $res->assertOk()
            ->assertJson(['accion' => 'generar_reporte_pdf'])
            ->assertJsonPath('reporte.tipo_reporte', $caso['tipo']);
    }

    // 2. Verificar que inventario con stock bajo detecta las alertas reales por lotes (> 0 filas)
    $resAlerta = $this->withToken($token)->postJson('/api/ia/comando-voz', [
        'comando' => 'reporte de inventario con stock bajo',
        'contexto_pantalla' => '/articulos-inventario',
    ]);
    $resAlerta->assertOk();
    expect(count($resAlerta->json('reporte.filas')))->toBeGreaterThan(0);

    // 3. Si un filtro no tiene registros (ej. postulantes rechazados), no genera PDF vacío
    $resVacio = $this->withToken($token)->postJson('/api/ia/comando-voz', [
        'comando' => 'reporte de postulantes rechazados',
        'contexto_pantalla' => '/postulantes',
    ]);
    $resVacio->assertOk()
        ->assertJson([
            'accion' => 'sin_datos',
            'reporte' => null,
        ]);
});
