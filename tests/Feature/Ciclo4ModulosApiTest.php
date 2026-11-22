<?php

use App\Models\User;
use Illuminate\Support\Facades\DB;

function createCiclo4User(string $rol = 'Administrador'): User
{
    $user = new User([
        'nombre' => "Test {$rol}",
        'email' => 'ciclo4-'.uniqid().'@example.org',
        'rol' => $rol,
        'password' => 'Password123!',
    ]);
    $user->forceFill(['telefono' => '70000000', 'activo' => true])->save();

    return $user;
}

test('P11 CU31 CU32 CU33: dosificacion, emision de factura con codigo de control y anulacion', function () {
    $admin = createCiclo4User('Administrador');
    $token = $admin->createToken('ciclo4-p11')->plainTextToken;

    $dosif = $this->withToken($token)->postJson('/api/dosificaciones-fiscales', [
        'nit_emisor' => '1020304021',
        'numero_autorizacion' => '290400'.random_int(10000, 99999),
        'llave_dosificacion' => 'zZ7Z]xssKqkEf_6K9uH(551234',
        'numero_inicial' => 1,
        'numero_final' => 500,
        'fecha_limite_emision' => now()->addMonths(6)->toDateString(),
        'leyenda_tributaria' => 'Ley N° 453',
    ]);
    $dosif->assertCreated();

    $factura = $this->withToken($token)->postJson('/api/facturas-legales', [
        'nit_ci_cliente' => '1234567',
        'razon_social_cliente' => 'Juan Perez',
        'items' => [
            ['concepto' => 'Consulta veterinaria', 'cantidad' => 1, 'precio_unitario' => 150],
        ],
    ]);
    $factura->assertCreated()
        ->assertJsonPath('factura.estado', 'EMITIDA');

    $facturaId = $factura->json('factura.id');

    $anular = $this->withToken($token)->postJson("/api/facturas-legales/{$facturaId}/anular", [
        'motivo_anulacion' => 'Error en NIT del cliente',
        'password' => 'Password123!',
    ]);
    $anular->assertOk()
        ->assertJsonPath('factura.estado', 'ANULADA');
});

test('P12 CU34 CU35: dosificacion clinica automatica y auditoria forense', function () {
    $admin = createCiclo4User('Administrador');
    $token = $admin->createToken('ciclo4-p12')->plainTextToken;

    $mascotaId = DB::table('mascotas')->insertGetId([
        'nombre' => 'Firulais Test',
        'especie' => 'Perro',
        'raza' => 'Mestizo',
        'edad' => '2 años',
        'estado_actual' => 'En tratamiento',
        'fecha_ingreso' => now()->toDateString(),
        'sexo' => 'Macho',
        'zona_rescate' => 'Centro',
        'foto' => 'default.jpg',
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    $articuloId = DB::table('articulo_inventarios')->insertGetId([
        'nombre' => 'Amoxicilina Test '.uniqid(),
        'categoria' => 'Medicamento',
        'unidad_medida' => 'ml',
        'stock_actual' => 50,
        'stock_minimo_alerta' => 5,
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    $prescripcion = $this->withToken($token)->postJson('/api/dosificacion-clinica', [
        'mascota_id' => $mascotaId,
        'articulo_id' => $articuloId,
        'peso_mascota_kg' => 10,
        'dosis_mg_kg' => 15,
        'concentracion_farmaco' => 50,
        'unidad_medida' => 'ml',
        'frecuencia_horas' => 12,
        'duracion_dias' => 2,
    ]);
    $prescripcion->assertCreated()
        ->assertJsonPath('prescripcion.dosis_calculada_unidad', '3.000');

    $forense = $this->withToken($token)->getJson('/api/auditoria-forense');
    $forense->assertOk()
        ->assertJsonStructure(['eventos', 'resumen_severidad']);
});

test('P13 CU36 CU37: libro IVA y rendicion de cuentas con hash SHA-256', function () {
    $admin = createCiclo4User('Administrador');
    $token = $admin->createToken('ciclo4-p13')->plainTextToken;

    $libro = $this->withToken($token)->getJson('/api/libro-iva');
    $libro->assertOk()
        ->assertJsonStructure(['anio', 'mes', 'ventas', 'compras', 'resumen']);

    $rendicion = $this->withToken($token)->postJson('/api/rendicion-cuentas/emitir', [
        'fecha_inicio' => now()->startOfYear()->toDateString(),
        'fecha_fin' => now()->toDateString(),
        'plantilla' => 'Informe Semestral Entidad Pública',
    ]);
    $rendicion->assertCreated()
        ->assertJsonStructure(['mensaje', 'cierre' => ['id', 'hash_documento'], 'datos']);
});

test('P03 CU23: registrar visita de seguimiento post-adopcion con subida de imagenes del animal y control estricto por rol', function () {
    foreach (['Administrador', 'Recepcionista', 'Voluntario'] as $rol) {
        $staff = createCiclo4User($rol);
        $token = $staff->createToken('ciclo4-visita-'.$rol)->plainTextToken;

        $mascotaId = DB::table('mascotas')->insertGetId([
            'nombre' => 'Mascota Visita '.$rol,
            'especie' => 'Canino',
            'raza' => 'Pastor Alemán',
            'edad' => '2 años',
            'estado_actual' => 'Adoptado',
            'fecha_ingreso' => now()->toDateString(),
            'sexo' => 'Macho',
            'zona_rescate' => 'Equipetrol',
            'foto' => '/images/mascotas/perro_1.png',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $interesadoId = DB::table('interesado_adopcions')->insertGetId([
            'ci' => 'CI-'.uniqid(),
            'nombre' => 'Adoptante '.$rol,
            'telefono' => '70012345',
            'direccion' => 'Av. Banzer',
            'situacion_casa' => 'Casa propia con patio',
            'referencias' => 'Vecino',
            'puntaje_evaluacion' => '95',
            'estado' => 'Aprobado',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $adopcionId = DB::table('adopcions')->insertGetId([
            'id_mascota' => $mascotaId,
            'id_interesado' => $interesadoId,
            'fecha_adopcion' => now()->toDateString(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $imagenBase64 = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';

        $crearVisita = $this->withToken($token)->postJson('/api/seguimientos', [
            'id_adopcion' => $adopcionId,
            'fecha_programada' => now()->addDays(30)->toDateString(),
            'estado_seguimiento' => 'Pendiente',
            'reporte_bienestar' => 'Control inicial programado por '.$rol,
            'imagenes_base64' => [$imagenBase64],
        ]);

        $crearVisita->assertCreated();
        $seguimientoId = $crearVisita->json('seguimiento.id');
        expect($crearVisita->json('seguimiento.fotografia'))->toStartWith('/uploads/visitas/');

        $completarVisita = $this->withToken($token)->patchJson("/api/seguimientos/{$seguimientoId}", [
            'fecha_realizada' => now()->toDateString(),
            'estado_seguimiento' => 'Concluido Satisfactorio',
            'reporte_bienestar' => 'El animalito visitado está en excelente estado de salud y nutrición.',
            'imagenes_base64' => [$imagenBase64],
        ]);

        $completarVisita->assertOk()
            ->assertJsonPath('seguimiento.estado_seguimiento', 'Concluido Satisfactorio');
    }
});
