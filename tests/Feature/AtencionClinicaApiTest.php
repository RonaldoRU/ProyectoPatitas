<?php

use App\Models\ArticuloInventario;
use App\Models\Bitacora;
use App\Models\DetalleSalida;
use App\Models\HistorialClinico;
use App\Models\InventarioLote;
use App\Models\Mascota;
use App\Models\SalidaInventario;
use App\Models\User;

function createAtencionClinicaUser(string $email, string $role = 'Veterinario'): User
{
    $user = new User([
        'nombre' => 'Dra. Clínica',
        'email' => $email,
        'rol' => $role,
        'password' => 'refugio-password',
    ]);
    $user->forceFill(['telefono' => '70000000'])->save();

    return $user;
}

function createAtencionClinicaMascota(array $overrides = []): Mascota
{
    return Mascota::query()->create(array_merge([
        'nombre' => 'Luna',
        'raza' => 'Mestiza',
        'edad' => '3 años',
        'especie' => 'Canino',
        'estado_actual' => 'En tratamiento',
        'fecha_ingreso' => '2026-01-10',
        'sexo' => 'Hembra',
        'zona_rescate' => 'Centro',
        'foto' => 'mascotas/luna.jpg',
    ], $overrides));
}

function createAtencionClinicaArticulo(array $overrides = []): ArticuloInventario
{
    return ArticuloInventario::query()->create(array_merge([
        'nombre' => 'Antibiótico veterinario',
        'categoria' => 'Medicamento',
        'unidad_medida' => 'Frasco',
        'stock_actual' => '10.00',
        'stock_minimo_alerta' => '2.00',
    ], $overrides));
}

function createAtencionClinicaLote(ArticuloInventario $articulo, int $cantidad = 10): InventarioLote
{
    return InventarioLote::query()->create([
        'id_articulo' => $articulo->id,
        'fecha_vencimiento' => now()->addYear()->toDateString(),
        'cantidad_inicial' => $cantidad,
        'cantidad_disponible' => $cantidad,
    ]);
}

function atencionClinicaPayload(Mascota $mascota, array $lineas): array
{
    return [
        'fecha_atencion' => '2026-10-14',
        'id_mascota' => $mascota->id,
        'diagnostico' => 'Infección leve',
        'observacion' => 'Mantener hidratada y vigilar apetito.',
        'tipo_procedimiento' => 'Tratamiento antibiótico',
        'lineas' => $lineas,
    ];
}

test('a veterinarian can register a clinical attention and inventory consumption atomically', function () {
    $veterinarian = createAtencionClinicaUser('veterinario-atencion@example.org');
    $mascota = createAtencionClinicaMascota();
    $article = createAtencionClinicaArticulo();
    createAtencionClinicaLote($article);
    $token = $veterinarian->createToken('clinical-attention-test')->plainTextToken;

    $this->withToken($token)
        ->getJson('/api/atenciones-clinicas/catalogos')
        ->assertOk()
        ->assertJsonPath('mascotas.0.id', $mascota->id)
        ->assertJsonPath('articulos.0.id', $article->id);

    $response = $this->withToken($token)
        ->postJson('/api/atenciones-clinicas', atencionClinicaPayload($mascota, [
            ['id_articulo' => $article->id, 'cantidad' => '2'],
        ]))
        ->assertCreated()
        ->assertJsonPath('atencion.mascota', 'Luna')
        ->assertJsonPath('atencion.articulos_actualizados.0.cantidad', 2)
        ->assertJsonPath('atencion.articulos_actualizados.0.stock_actual', '8.00');

    $historial = HistorialClinico::query()->firstOrFail();
    $salida = SalidaInventario::query()->findOrFail($response->json('atencion.salida_inventario_id'));

    $this->assertDatabaseHas('historial_clinicos', [
        'id' => $historial->id,
        'fecha_atencion' => '2026-10-14',
        'diagnostico' => 'Infección leve',
        'tipo_procedimiento' => 'Tratamiento antibiótico',
        'id_mascota' => $mascota->id,
        'id_usuario' => $veterinarian->id,
    ]);
    $this->assertDatabaseHas('salida_inventarios', [
        'id' => $salida->id,
        'motivo' => 'Consumo clínico de atención #'.$historial->id,
        'id_historial_clinico' => $historial->id,
        'id_usuario' => $veterinarian->id,
    ]);
    $this->assertDatabaseHas('detalle_salidas', [
        'id_salida' => $salida->id,
        'id_articulo' => $article->id,
        'cantidad' => '2.00',
    ]);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $article->id,
        'stock_actual' => '8.00',
    ]);
    $this->assertDatabaseHas('bitacoras', [
        'tipo_accion' => 'Registrar atención clínica y consumir inventario',
        'modulo' => 'historial_clinico',
        'entidad_tipo' => 'HistorialClinico',
        'entidad_id' => (string) $historial->id,
        'resultado' => 'exitosa',
    ]);
});

test('insufficient clinical stock rejects the attention and rolls back every write', function () {
    $veterinarian = createAtencionClinicaUser('veterinario-stock-clinico@example.org');
    $mascota = createAtencionClinicaMascota();
    $availableArticle = createAtencionClinicaArticulo();
    createAtencionClinicaLote($availableArticle);
    $unavailableArticle = createAtencionClinicaArticulo([
        'nombre' => 'Analgésico',
        'stock_actual' => '0.50',
    ]);

    $response = $this->withToken($veterinarian->createToken('clinical-stock-shortage')->plainTextToken)
        ->postJson('/api/atenciones-clinicas', atencionClinicaPayload($mascota, [
            ['id_articulo' => $availableArticle->id, 'cantidad' => '1'],
            ['id_articulo' => $unavailableArticle->id, 'cantidad' => '1'],
        ]))
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.1.cantidad']);

    expect($response->json('errors')['lineas.1.cantidad'][0])
        ->toBe('Stock insuficiente para Analgésico. Disponible: 0.00 Frasco.');
    expect(HistorialClinico::query()->count())->toBe(0)
        ->and(SalidaInventario::query()->count())->toBe(0)
        ->and(DetalleSalida::query()->count())->toBe(0)
        ->and(Bitacora::query()->count())->toBe(0);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $availableArticle->id,
        'stock_actual' => '10.00',
    ]);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $unavailableArticle->id,
        'stock_actual' => '0.50',
    ]);
});

test('clinical attention rejects fractional and nonpositive quantities and repeated articles', function () {
    $veterinarian = createAtencionClinicaUser('veterinario-validacion-clinica@example.org');
    $mascota = createAtencionClinicaMascota();
    $article = createAtencionClinicaArticulo();
    $token = $veterinarian->createToken('clinical-validation-test')->plainTextToken;

    $this->withToken($token)
        ->postJson('/api/atenciones-clinicas', atencionClinicaPayload($mascota, [
            ['id_articulo' => $article->id, 'cantidad' => '0'],
        ]))
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.0.cantidad']);

    $fractionalResponse = $this->withToken($token)
        ->postJson('/api/atenciones-clinicas', atencionClinicaPayload($mascota, [
            ['id_articulo' => $article->id, 'cantidad' => '1.5'],
        ]))
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.0.cantidad']);

    expect($fractionalResponse->json('errors')['lineas.0.cantidad'][0])
        ->toBe('Cada cantidad utilizada debe ser un número entero.');

    $this->withToken($token)
        ->postJson('/api/atenciones-clinicas', atencionClinicaPayload($mascota, [
            ['id_articulo' => $article->id, 'cantidad' => '1'],
            ['id_articulo' => $article->id, 'cantidad' => '1'],
        ]))
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.1.id_articulo']);

    expect(HistorialClinico::query()->count())->toBe(0)
        ->and(SalidaInventario::query()->count())->toBe(0);
});

test('only veterinarians can read clinical catalogs or register an attention', function () {
    $this->getJson('/api/atenciones-clinicas/catalogos')->assertUnauthorized();

    $administrator = createAtencionClinicaUser('admin-clinico-forbidden@example.org', 'Administrador');

    $this->withToken($administrator->createToken('clinical-admin-forbidden')->plainTextToken)
        ->getJson('/api/atenciones-clinicas/catalogos')
        ->assertForbidden();

    expect(HistorialClinico::query()->count())->toBe(0)
        ->and(SalidaInventario::query()->count())->toBe(0);
});

test('the clinical attention registration page renders through Inertia', function () {
    $this->get('/atenciones-clinicas')
        ->assertOk()
        ->assertInertia(fn ($page) => $page->component('atenciones-clinicas'));
});
