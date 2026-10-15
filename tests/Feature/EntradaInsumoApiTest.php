<?php

use App\Models\ArticuloInventario;
use App\Models\Bitacora;
use App\Models\Compra;
use App\Models\DetalleCompra;
use App\Models\Donacion;
use App\Models\InventarioLote;
use App\Models\Proveedor;
use App\Models\User;

function createEntradaInsumoUser(string $email, string $role = 'Administrador'): User
{
    $user = new User([
        'nombre' => 'María Recepción',
        'email' => $email,
        'rol' => $role,
        'password' => 'refugio-password',
    ]);
    $user->forceFill(['telefono' => '70000000'])->save();

    return $user;
}

function createEntradaInsumoArticulo(array $overrides = []): ArticuloInventario
{
    return ArticuloInventario::query()->create(array_merge([
        'nombre' => 'Alimento para perros',
        'categoria' => 'Alimento',
        'unidad_medida' => 'Bolsa',
        'stock_actual' => 5,
        'stock_minimo_alerta' => 2,
    ], $overrides));
}

function entradaInsumoCompraPayload(ArticuloInventario $articulo, array $overrides = []): array
{
    $supplier = Proveedor::query()->create([
        'nombre_empresa' => 'Distribuidora Patitas',
        'nombre_contacto' => 'Luis Mercado',
        'telefono' => '70000011',
        'direccion' => 'Avenida Central 123',
    ]);

    return array_merge([
        'tipo' => 'compra',
        'fecha' => '2026-10-14',
        'numero_documento' => 'FAC-2026-100',
        'id_proveedor' => $supplier->id,
        'lineas' => [
            [
                'id_articulo' => $articulo->id,
                'cantidad' => '2',
                'costo_unitario' => '10.00',
                'fecha_vencimiento' => '2027-10-14',
            ],
        ],
    ], $overrides);
}

test('a receptionist can record a purchase and stock is increased transactionally', function () {
    $user = createEntradaInsumoUser('recepcionista-compra@example.org', 'Recepcionista');
    $article = createEntradaInsumoArticulo();
    $token = $user->createToken('purchase-entry-test')->plainTextToken;

    $this->withToken($token)
        ->getJson('/api/entradas-insumos/catalogos')
        ->assertOk()
        ->assertJsonPath('articulos.0.id', $article->id);

    $this->withToken($token)
        ->postJson('/api/entradas-insumos', entradaInsumoCompraPayload($article))
        ->assertCreated()
        ->assertJsonPath('entrada.tipo', 'compra')
        ->assertJsonPath('entrada.numero_documento', 'FAC-2026-100')
        ->assertJsonPath('entrada.monto_total', '20.00')
        ->assertJsonPath('entrada.articulos_actualizados.0.stock_actual', '7.00');

    $purchase = Compra::query()->firstOrFail();
    $supplier = Proveedor::query()->firstOrFail();

    expect($purchase->id_proveedor)->toBe($supplier->id)
        ->and($purchase->id_usuario)->toBe($user->id);
    $this->assertDatabaseHas('compras', [
        'id' => $purchase->id,
        'monto_total' => '20.00',
        'fecha_compra' => '2026-10-14',
        'numero_documento' => 'FAC-2026-100',
    ]);
    $this->assertDatabaseHas('detalle_compras', [
        'id_compra' => $purchase->id,
        'id_articulo' => $article->id,
        'cantidad' => '2',
        'costo_unitario' => '10.00',
        'fecha_vencimiento' => '2027-10-14',
    ]);
    $this->assertDatabaseHas('inventario_lotes', [
        'id_detalle_compra' => DetalleCompra::query()->where('id_compra', $purchase->id)->value('id'),
        'cantidad_inicial' => '2.00',
        'cantidad_disponible' => '2.00',
    ]);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $article->id,
        'stock_actual' => '7.00',
    ]);
    $this->assertDatabaseHas('bitacoras', [
        'tipo_accion' => 'Registrar entrada por compra',
        'modulo' => 'inventario',
        'entidad_tipo' => 'Compra',
        'entidad_id' => (string) $purchase->id,
        'resultado' => 'exitosa',
    ]);
});

test('an administrator can record an insumos donation and update stock', function () {
    $user = createEntradaInsumoUser('admin-donacion@example.org');
    $article = createEntradaInsumoArticulo([
        'nombre' => 'Medicamento veterinario',
        'categoria' => 'Salud',
        'unidad_medida' => 'Frasco',
    ]);

    $this->withToken($user->createToken('donation-entry-test')->plainTextToken)
        ->postJson('/api/entradas-insumos', [
            'tipo' => 'donacion',
            'fecha' => '2026-10-14',
            'numero_documento' => 'REC-44',
            'donante' => [
                'nombre' => 'Fundación Huellas',
                'telefono' => '70000022',
                'tipo_persona' => 'Jurídica',
            ],
            'lineas' => [
                [
                    'id_articulo' => $article->id,
                    'cantidad' => '3',
                    'fecha_vencimiento' => now()->addYear()->toDateString(),
                ],
            ],
        ])
        ->assertCreated()
        ->assertJsonPath('entrada.tipo', 'donacion')
        ->assertJsonPath('entrada.numero_documento', 'REC-44')
        ->assertJsonPath('entrada.monto_total', null);

    $donation = Donacion::query()->firstOrFail();

    expect($donation->tipo_aporte)->toBe('Insumos')
        ->and($donation->donante?->nombre)->toBe('Fundación Huellas');
    $this->assertDatabaseHas('detalle_donacion_insumos', [
        'id_donacion' => $donation->id,
        'id_articulo' => $article->id,
        'cantidad' => '3.00',
    ]);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $article->id,
        'stock_actual' => '8.00',
    ]);
    $this->assertDatabaseHas('bitacoras', [
        'tipo_accion' => 'Registrar entrada por donación',
        'entidad_tipo' => 'Donacion',
        'entidad_id' => (string) $donation->id,
    ]);
});

test('the entry endpoint rejects invalid quantities without saving or changing stock', function () {
    $user = createEntradaInsumoUser('admin-cantidad-invalida@example.org');
    $article = createEntradaInsumoArticulo();
    $payload = entradaInsumoCompraPayload($article);
    $payload['lineas'][0]['cantidad'] = '-1';

    $response = $this->withToken($user->createToken('invalid-entry-test')->plainTextToken)
        ->postJson('/api/entradas-insumos', $payload)
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.0.cantidad']);

    expect($response->json('errors')['lineas.0.cantidad'][0])
        ->toBe('Cada cantidad debe ser un número entero mayor que cero.');

    $payload['lineas'][0]['cantidad'] = '1.5';

    $fractionalResponse = $this->withToken($user->createToken('fractional-entry-test')->plainTextToken)
        ->postJson('/api/entradas-insumos', $payload)
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.0.cantidad']);

    expect($fractionalResponse->json('errors')['lineas.0.cantidad'][0])
        ->toBe('Cada cantidad debe ser un número entero.');

    expect(Compra::query()->count())->toBe(0)
        ->and(DetalleCompra::query()->count())->toBe(0)
        ->and(Bitacora::query()->count())->toBe(0);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $article->id,
        'stock_actual' => '5.00',
    ]);
});

test('purchase registration requires a document number and a unit cost for each line', function () {
    $user = createEntradaInsumoUser('admin-compra-incompleta@example.org');
    $article = createEntradaInsumoArticulo();
    $payload = entradaInsumoCompraPayload($article);
    unset($payload['numero_documento'], $payload['lineas'][0]['costo_unitario']);

    $this->withToken($user->createToken('incomplete-entry-test')->plainTextToken)
        ->postJson('/api/entradas-insumos', $payload)
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['numero_documento', 'lineas.0.costo_unitario']);

    expect(Compra::query()->count())->toBe(0)
        ->and(DetalleCompra::query()->count())->toBe(0)
        ->and(Bitacora::query()->count())->toBe(0);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $article->id,
        'stock_actual' => '5.00',
    ]);
});

test('medicine entries require a current expiry date and create one lot per intake detail', function () {
    $user = createEntradaInsumoUser('admin-vencimiento-obligatorio@example.org');
    $article = createEntradaInsumoArticulo([
        'nombre' => 'Antibiótico veterinario',
        'categoria' => 'Salud',
    ]);
    $token = $user->createToken('medicine-expiry-entry')->plainTextToken;
    $payload = entradaInsumoCompraPayload($article);
    $payload['lineas'][0]['fecha_vencimiento'] = null;

    $this->withToken($token)
        ->getJson('/api/entradas-insumos/catalogos')
        ->assertOk()
        ->assertJsonPath('articulos.0.requiere_vencimiento', true);

    $this->withToken($token)
        ->postJson('/api/entradas-insumos', $payload)
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.0.fecha_vencimiento']);

    $payload['lineas'][0]['fecha_vencimiento'] = now()->subDay()->toDateString();

    $this->withToken($token)
        ->postJson('/api/entradas-insumos', $payload)
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.0.fecha_vencimiento']);

    expect(Compra::query()->count())->toBe(0)
        ->and(DetalleCompra::query()->count())->toBe(0)
        ->and(InventarioLote::query()->count())->toBe(0);
});

test('a failure on a later line rolls back earlier stock changes and records', function () {
    $user = createEntradaInsumoUser('admin-rollback@example.org');
    $firstArticle = createEntradaInsumoArticulo();
    $lastArticle = createEntradaInsumoArticulo([
        'nombre' => 'Stock al máximo',
        'stock_actual' => '99999999.99',
    ]);
    $supplier = Proveedor::query()->create([
        'nombre_empresa' => 'Proveedor existente',
        'nombre_contacto' => 'Contacto',
        'telefono' => '70000033',
        'direccion' => 'Calle 1',
    ]);
    $payload = entradaInsumoCompraPayload($firstArticle, [
        'id_proveedor' => $supplier->id,
        'lineas' => [
            [
                'id_articulo' => $firstArticle->id,
                'cantidad' => '1',
                'costo_unitario' => '2.00',
            ],
            [
                'id_articulo' => $lastArticle->id,
                'cantidad' => '1',
                'costo_unitario' => '2.00',
            ],
        ],
    ]);
    $this->withToken($user->createToken('rollback-entry-test')->plainTextToken)
        ->postJson('/api/entradas-insumos', $payload)
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.1.cantidad']);

    expect(Compra::query()->count())->toBe(0)
        ->and(DetalleCompra::query()->count())->toBe(0)
        ->and(Bitacora::query()->count())->toBe(0);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $firstArticle->id,
        'stock_actual' => '5.00',
    ]);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $lastArticle->id,
        'stock_actual' => '99999999.99',
    ]);
});

test('entry catalog and registration require an administrator or receptionist', function () {
    $this->getJson('/api/entradas-insumos/catalogos')->assertUnauthorized();

    $otherStaff = createEntradaInsumoUser('veterinario-entrada@example.org', 'Veterinario');

    $this->withToken($otherStaff->createToken('forbidden-entry-test')->plainTextToken)
        ->getJson('/api/entradas-insumos/catalogos')
        ->assertForbidden();
});

test('purchase catalog lists only active suppliers and purchases reject inactive suppliers', function () {
    $user = createEntradaInsumoUser('proveedor-inactivo-compra@example.org', 'Recepcionista');
    $article = createEntradaInsumoArticulo();
    $activeSupplier = Proveedor::query()->create([
        'nombre_empresa' => 'Proveedor activo',
        'nombre_contacto' => 'Contacto activo',
        'telefono' => '70000031',
        'direccion' => 'Calle 1',
        'tipo_insumo_provisto' => 'Alimentos',
    ]);
    $inactiveSupplier = Proveedor::query()->create([
        'nombre_empresa' => 'Proveedor inactivo',
        'nombre_contacto' => 'Contacto inactivo',
        'telefono' => '70000032',
        'direccion' => 'Calle 2',
        'tipo_insumo_provisto' => 'Medicamentos',
        'activo' => false,
    ]);
    $token = $user->createToken('inactive-supplier-purchase-test')->plainTextToken;

    $this->withToken($token)
        ->getJson('/api/entradas-insumos/catalogos')
        ->assertOk()
        ->assertJsonCount(1, 'proveedores')
        ->assertJsonPath('proveedores.0.id', $activeSupplier->id)
        ->assertJsonPath('proveedores.0.tipo_insumo_provisto', 'Alimentos');

    $this->withToken($token)
        ->postJson('/api/entradas-insumos', [
            'tipo' => 'compra',
            'fecha' => '2026-10-14',
            'numero_documento' => 'FAC-INACTIVO-1',
            'id_proveedor' => $inactiveSupplier->id,
            'lineas' => [
                [
                    'id_articulo' => $article->id,
                    'cantidad' => 2,
                    'costo_unitario' => '10.00',
                ],
            ],
        ])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['id_proveedor']);

    expect(Compra::query()->count())->toBe(0);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $article->id,
        'stock_actual' => '5.00',
    ]);
});

test('the entry registration page renders through Inertia', function () {
    $this->get('/entradas-insumos')
        ->assertOk()
        ->assertInertia(fn ($page) => $page->component('entradas-insumos'));
});
