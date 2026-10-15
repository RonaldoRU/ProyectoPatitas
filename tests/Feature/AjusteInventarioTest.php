<?php

use App\Models\AjusteInventario;
use App\Models\AjusteInventarioLote;
use App\Models\ArticuloInventario;
use App\Models\Bitacora;
use App\Models\InventarioLote;
use App\Models\User;

function createAjusteInventarioUser(string $email, string $role = 'Administrador'): User
{
    $user = new User([
        'nombre' => 'Rosa Méndez',
        'email' => $email,
        'rol' => $role,
        'password' => 'refugio-password',
    ]);
    $user->forceFill(['telefono' => '70000000'])->save();

    return $user;
}

function createAjusteInventarioArticulo(string $category, string $stock): ArticuloInventario
{
    return ArticuloInventario::query()->create([
        'nombre' => $category === 'Medicamento' ? 'Antibiótico de prueba' : 'Alimento de prueba',
        'categoria' => $category,
        'unidad_medida' => 'Unidad',
        'stock_actual' => $stock,
        'stock_minimo_alerta' => 1,
    ]);
}

function createAjusteInventarioLote(
    ArticuloInventario $article,
    string $quantity,
    ?string $expiry = null,
): InventarioLote {
    return InventarioLote::query()->create([
        'id_articulo' => $article->id,
        'fecha_vencimiento' => $expiry,
        'cantidad_inicial' => $quantity,
        'cantidad_disponible' => $quantity,
    ]);
}

test('an administrator registers a merma with a reason and an immutable lot allocation', function () {
    $administrator = createAjusteInventarioUser('ajuste-inventario-admin@example.org');
    $article = createAjusteInventarioArticulo('Alimento', '10.00');
    $firstLot = createAjusteInventarioLote($article, '3.00');
    $secondLot = createAjusteInventarioLote($article, '2.00');
    $token = $administrator->createToken('inventory-adjustment-test')->plainTextToken;

    $response = $this->withToken($token)
        ->postJson('/api/ajustes-inventario', [
            'id_articulo' => $article->id,
            'cantidad' => 4,
            'motivo' => 'Envase dañado durante el almacenamiento.',
        ])
        ->assertCreated()
        ->assertJsonPath('ajuste.cantidad', 4)
        ->assertJsonPath('ajuste.usuario_nombre', 'Rosa Méndez')
        ->assertJsonPath('ajuste.saldo_disponible_anterior', '10.00')
        ->assertJsonPath('ajuste.saldo_disponible_nuevo', '6.00')
        ->assertJsonPath('stock_actual', '6.00');

    $adjustmentId = $response->json('ajuste.id');
    $this->assertDatabaseHas('ajuste_inventarios', [
        'id' => $adjustmentId,
        'id_articulo' => $article->id,
        'id_usuario' => $administrator->id,
        'cantidad' => 4,
        'motivo' => 'Envase dañado durante el almacenamiento.',
    ]);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $article->id,
        'stock_actual' => '6.00',
    ]);
    $this->assertDatabaseHas('inventario_lotes', [
        'id' => $firstLot->id,
        'cantidad_disponible' => '0.00',
    ]);
    $this->assertDatabaseHas('inventario_lotes', [
        'id' => $secondLot->id,
        'cantidad_disponible' => '1.00',
    ]);
    $this->assertDatabaseHas('ajuste_inventario_lotes', [
        'id_ajuste_inventario' => $adjustmentId,
        'id_inventario_lote' => $firstLot->id,
        'cantidad' => '3.00',
    ]);
    $this->assertDatabaseHas('ajuste_inventario_lotes', [
        'id_ajuste_inventario' => $adjustmentId,
        'id_inventario_lote' => $secondLot->id,
        'cantidad' => '1.00',
    ]);
    $this->assertDatabaseHas('bitacoras', [
        'tipo_accion' => 'Registrar merma de inventario',
        'id_usuario' => $administrator->id,
        'modulo' => 'inventario',
        'entidad_tipo' => 'AjusteInventario',
        'entidad_id' => (string) $adjustmentId,
    ]);

    $this->withToken($token)
        ->getJson('/api/ajustes-inventario')
        ->assertOk()
        ->assertJsonPath('ajustes.0.id', $adjustmentId)
        ->assertJsonPath('ajustes.0.articulo.nombre', 'Alimento de prueba');

    expect(AjusteInventario::query()->count())->toBe(1)
        ->and(AjusteInventarioLote::query()->count())->toBe(2);
});

test('a medication merma only consumes current lots and preserves expired lots', function () {
    $administrator = createAjusteInventarioUser('ajuste-medicamento-admin@example.org');
    $article = createAjusteInventarioArticulo('Medicamento', '8.00');
    $expiredLot = createAjusteInventarioLote($article, '3.00', now()->subDay()->toDateString());
    $currentLot = createAjusteInventarioLote($article, '5.00', now()->addDays(10)->toDateString());
    $token = $administrator->createToken('medication-adjustment-test')->plainTextToken;

    $response = $this->withToken($token)
        ->postJson('/api/ajustes-inventario', [
            'id_articulo' => $article->id,
            'cantidad' => 2,
            'motivo' => 'Rotura de unidades vigentes.',
        ])
        ->assertCreated()
        ->assertJsonPath('ajuste.stock_anterior', '8.00')
        ->assertJsonPath('ajuste.stock_nuevo', '6.00')
        ->assertJsonPath('ajuste.saldo_disponible_anterior', '5.00')
        ->assertJsonPath('ajuste.saldo_disponible_nuevo', '3.00')
        ->assertJsonPath('stock_actual', '3.00');

    $this->assertDatabaseHas('inventario_lotes', [
        'id' => $expiredLot->id,
        'cantidad_disponible' => '3.00',
    ]);
    $this->assertDatabaseHas('inventario_lotes', [
        'id' => $currentLot->id,
        'cantidad_disponible' => '3.00',
    ]);
    $this->assertDatabaseHas('ajuste_inventario_lotes', [
        'id_ajuste_inventario' => $response->json('ajuste.id'),
        'id_inventario_lote' => $currentLot->id,
        'cantidad' => '2.00',
    ]);
});

test('a merma cannot exceed available stock and rolls back every inventory write', function () {
    $administrator = createAjusteInventarioUser('ajuste-exceso-admin@example.org');
    $article = createAjusteInventarioArticulo('Alimento', '3.00');
    $lot = createAjusteInventarioLote($article, '3.00');
    $token = $administrator->createToken('inventory-over-adjustment-test')->plainTextToken;

    $this->withToken($token)
        ->postJson('/api/ajustes-inventario', [
            'id_articulo' => $article->id,
            'cantidad' => 4,
            'motivo' => 'Intento de merma excesiva.',
        ])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['cantidad'])
        ->assertJsonPath('errors.cantidad.0', 'La merma supera el stock disponible de Alimento de prueba. Disponible: 3.00 Unidad.');

    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $article->id,
        'stock_actual' => '3.00',
    ]);
    $this->assertDatabaseHas('inventario_lotes', [
        'id' => $lot->id,
        'cantidad_disponible' => '3.00',
    ]);
    expect(AjusteInventario::query()->count())->toBe(0)
        ->and(Bitacora::query()->where('tipo_accion', 'Registrar merma de inventario')->count())->toBe(0);
});

test('the adjustment endpoint requires an administrator, an integer quantity, and a reason', function () {
    $this->postJson('/api/ajustes-inventario')
        ->assertUnauthorized();

    $staff = createAjusteInventarioUser('ajuste-staff@example.org', 'Veterinario');
    $staffToken = $staff->createToken('inventory-adjustment-staff-test')->plainTextToken;

    $this->withToken($staffToken)
        ->postJson('/api/ajustes-inventario')
        ->assertForbidden();

    $this->withToken($staffToken)
        ->getJson('/api/ajustes-inventario')
        ->assertForbidden();

    $this->app['auth']->forgetGuards();

    $administrator = createAjusteInventarioUser('ajuste-validation-admin@example.org');
    $article = createAjusteInventarioArticulo('Alimento', '3.00');
    $token = $administrator->createToken('inventory-adjustment-validation-test')->plainTextToken;

    $this->withToken($token)
        ->postJson('/api/ajustes-inventario', [])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['id_articulo', 'cantidad', 'motivo'])
        ->assertJsonPath('errors.motivo.0', 'El motivo de la merma es obligatorio.');

    $this->withToken($token)
        ->postJson('/api/ajustes-inventario', [
            'id_articulo' => $article->id,
            'cantidad' => '1.5',
            'motivo' => 'Cantidad no entera.',
        ])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['cantidad'])
        ->assertJsonPath('errors.cantidad.0', 'La cantidad de merma debe ser un número entero.');

    expect(AjusteInventario::query()->count())->toBe(0);
});
