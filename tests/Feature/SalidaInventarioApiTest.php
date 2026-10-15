<?php

use App\Models\ArticuloInventario;
use App\Models\Bitacora;
use App\Models\DetalleSalida;
use App\Models\SalidaInventario;
use App\Models\User;

function createSalidaInventarioUser(string $email, string $role = 'Recepcionista'): User
{
    $user = new User([
        'nombre' => 'Personal de Despensa',
        'email' => $email,
        'rol' => $role,
        'password' => 'refugio-password',
    ]);
    $user->forceFill(['telefono' => '70000000'])->save();

    return $user;
}

function createSalidaInventarioArticulo(array $overrides = []): ArticuloInventario
{
    return ArticuloInventario::query()->create(array_merge([
        'nombre' => 'Arroz',
        'categoria' => 'Alimento',
        'unidad_medida' => 'Kilogramo',
        'stock_actual' => '10.00',
        'stock_minimo_alerta' => '2.00',
    ], $overrides));
}

function salidaInventarioPayload(array $lineas): array
{
    return [
        'motivo' => 'Consumo diario del refugio',
        'destino' => 'Cocina',
        'fecha_salida' => '2026-10-14',
        'lineas' => $lineas,
    ];
}

test('a receptionist can record a stockout and stock is decreased with an audit entry', function () {
    $user = createSalidaInventarioUser('recepcionista-salida@example.org');
    $article = createSalidaInventarioArticulo();
    $token = $user->createToken('stockout-reception-test')->plainTextToken;

    $this->withToken($token)
        ->getJson('/api/salidas-inventario/catalogos')
        ->assertOk()
        ->assertJsonPath('articulos.0.id', $article->id)
        ->assertJsonPath('articulos.0.stock_actual', 10);

    $this->withToken($token)
        ->postJson('/api/salidas-inventario', salidaInventarioPayload([
            ['id_articulo' => $article->id, 'cantidad' => '2'],
        ]))
        ->assertCreated()
        ->assertJsonPath('salida.destino', 'Cocina')
        ->assertJsonPath('salida.articulos_actualizados.0.stock_actual', '8.00');

    $stockout = SalidaInventario::query()->firstOrFail();

    $this->assertDatabaseHas('salida_inventarios', [
        'id' => $stockout->id,
        'motivo' => 'Consumo diario del refugio | Destino: Cocina',
        'fecha_salida' => '2026-10-14',
        'id_usuario' => $user->id,
    ]);
    $this->assertDatabaseHas('detalle_salidas', [
        'id_salida' => $stockout->id,
        'id_articulo' => $article->id,
        'cantidad' => '2',
    ]);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $article->id,
        'stock_actual' => '8.00',
    ]);
    $this->assertDatabaseHas('bitacoras', [
        'tipo_accion' => 'Registrar salida de inventario',
        'modulo' => 'inventario',
        'entidad_tipo' => 'SalidaInventario',
        'entidad_id' => (string) $stockout->id,
        'resultado' => 'exitosa',
    ]);

    $audit = Bitacora::query()
        ->where('tipo_accion', 'Registrar salida de inventario')
        ->firstOrFail();
    expect($audit->contexto['motivo'])->toBe('Consumo diario del refugio')
        ->and($audit->contexto['destino'])->toBe('Cocina')
        ->and($audit->contexto['articulos'])->toBe(['Arroz']);
});

test('a volunteer can record a stockout using multiple articles', function () {
    $user = createSalidaInventarioUser('voluntario-salida@example.org', 'Voluntario');
    $firstArticle = createSalidaInventarioArticulo();
    $secondArticle = createSalidaInventarioArticulo([
        'nombre' => 'Detergente',
        'categoria' => 'Limpieza',
        'unidad_medida' => 'Litro',
        'stock_actual' => '4.00',
    ]);

    $this->withToken($user->createToken('stockout-volunteer-test')->plainTextToken)
        ->postJson('/api/salidas-inventario', salidaInventarioPayload([
            ['id_articulo' => $firstArticle->id, 'cantidad' => '1'],
            ['id_articulo' => $secondArticle->id, 'cantidad' => '1'],
        ]))
        ->assertCreated()
        ->assertJsonPath('salida.articulos_actualizados.0.stock_actual', '9.00')
        ->assertJsonPath('salida.articulos_actualizados.1.stock_actual', '3.00');

    expect(DetalleSalida::query()->count())->toBe(2);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $firstArticle->id,
        'stock_actual' => '9.00',
    ]);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $secondArticle->id,
        'stock_actual' => '3.00',
    ]);
});

test('insufficient stock rejects the entire stockout without changing any record', function () {
    $user = createSalidaInventarioUser('stock-insuficiente@example.org');
    $firstArticle = createSalidaInventarioArticulo();
    $secondArticle = createSalidaInventarioArticulo([
        'nombre' => 'Detergente',
        'categoria' => 'Limpieza',
        'unidad_medida' => 'Litro',
        'stock_actual' => '0.50',
    ]);

    $response = $this->withToken($user->createToken('stockout-shortage-test')->plainTextToken)
        ->postJson('/api/salidas-inventario', salidaInventarioPayload([
            ['id_articulo' => $firstArticle->id, 'cantidad' => '2'],
            ['id_articulo' => $secondArticle->id, 'cantidad' => '1'],
        ]))
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.1.cantidad']);

    expect($response->json('errors')['lineas.1.cantidad'][0])
        ->toBe('Stock insuficiente para Detergente. Disponible: 0.50 Litro.');
    expect(SalidaInventario::query()->count())->toBe(0)
        ->and(DetalleSalida::query()->count())->toBe(0)
        ->and(Bitacora::query()->count())->toBe(0);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $firstArticle->id,
        'stock_actual' => '10.00',
    ]);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $secondArticle->id,
        'stock_actual' => '0.50',
    ]);
});

test('stockout validation rejects missing fields nonpositive quantities and duplicate articles', function () {
    $user = createSalidaInventarioUser('validacion-salida@example.org');
    $article = createSalidaInventarioArticulo();
    $token = $user->createToken('stockout-validation-test')->plainTextToken;

    $this->withToken($token)
        ->postJson('/api/salidas-inventario', [])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['motivo', 'destino', 'fecha_salida', 'lineas']);

    $this->withToken($token)
        ->postJson('/api/salidas-inventario', salidaInventarioPayload([
            ['id_articulo' => $article->id, 'cantidad' => '0'],
        ]))
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.0.cantidad']);

    $fractionalResponse = $this->withToken($token)
        ->postJson('/api/salidas-inventario', salidaInventarioPayload([
            ['id_articulo' => $article->id, 'cantidad' => '1.5'],
        ]))
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.0.cantidad']);

    expect($fractionalResponse->json('errors')['lineas.0.cantidad'][0])
        ->toBe('La cantidad a retirar debe ser un número entero.');

    $this->withToken($token)
        ->postJson('/api/salidas-inventario', salidaInventarioPayload([
            ['id_articulo' => $article->id, 'cantidad' => '1'],
            ['id_articulo' => $article->id, 'cantidad' => '1'],
        ]))
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.1.id_articulo']);

    expect(SalidaInventario::query()->count())->toBe(0)
        ->and(DetalleSalida::query()->count())->toBe(0);
});

test('stockout endpoints require receptionist or volunteer access', function () {
    $this->getJson('/api/salidas-inventario/catalogos')->assertUnauthorized();

    $administrator = createSalidaInventarioUser('admin-salida-forbidden@example.org', 'Administrador');

    $this->withToken($administrator->createToken('stockout-admin-forbidden')->plainTextToken)
        ->getJson('/api/salidas-inventario/catalogos')
        ->assertForbidden();
});

test('the stockout registration page renders through Inertia', function () {
    $this->get('/salidas-inventario')
        ->assertOk()
        ->assertInertia(fn ($page) => $page->component('salidas-inventario'));
});
