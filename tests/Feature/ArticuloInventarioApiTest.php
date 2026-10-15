<?php

use App\Models\ArticuloInventario;
use App\Models\Bitacora;
use App\Models\User;

function createArticuloInventarioAdmin(string $email, string $role = 'Administrador'): User
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

function articuloInventarioInput(array $overrides = []): array
{
    return array_merge([
        'nombre' => 'Alimento para perros adultos',
        'categoria' => 'Alimento',
        'unidad_medida' => 'Bolsa',
        'stock_minimo_alerta' => 4.5,
    ], $overrides);
}

test('an administrator can list and register inventory articles', function () {
    $administrator = createArticuloInventarioAdmin('inventory-admin@example.org');
    $token = $administrator->createToken('inventory-create-test')->plainTextToken;

    $this->withToken($token)
        ->getJson('/api/articulos-inventario')
        ->assertOk()
        ->assertJsonPath('articulos', []);

    $response = $this->withToken($token)->postJson('/api/articulos-inventario', [
        ...articuloInventarioInput(),
        'stock_actual' => 700,
    ]);

    $response->assertCreated()
        ->assertJsonPath('articulo.nombre', 'Alimento para perros adultos')
        ->assertJsonPath('articulo.stock_minimo_alerta', 4.5)
        ->assertJsonPath('articulo.stock_actual', 0);

    $this->assertDatabaseHas('articulo_inventarios', [
        'nombre' => 'Alimento para perros adultos',
        'categoria' => 'Alimento',
        'unidad_medida' => 'Bolsa',
        'stock_actual' => '0.00',
        'stock_minimo_alerta' => '4.50',
    ]);

    $audit = Bitacora::query()
        ->where('tipo_accion', 'Registrar artículo de inventario')
        ->firstOrFail();
    expect($audit->modulo)->toBe('inventario')
        ->and($audit->contexto)->toBe([
            'campos_registrados' => ['nombre', 'categoria', 'unidad_medida', 'stock_minimo_alerta'],
        ]);
});

test('inventory article registration rejects incomplete and duplicate catalog entries', function () {
    $administrator = createArticuloInventarioAdmin('inventory-validation@example.org');
    $token = $administrator->createToken('inventory-validation-test')->plainTextToken;

    $this->withToken($token)
        ->postJson('/api/articulos-inventario', [])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['nombre', 'categoria', 'unidad_medida', 'stock_minimo_alerta']);

    $article = ArticuloInventario::query()->create(articuloInventarioInput());

    $this->withToken($token)
        ->postJson('/api/articulos-inventario', articuloInventarioInput())
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['nombre'])
        ->assertJsonPath('errors.nombre.0', 'Ya existe un artículo con ese nombre en el catálogo.');

    expect(ArticuloInventario::query()->count())->toBe(1);
    $this->assertModelExists($article);
});

test('an administrator can update catalog fields without changing current stock', function () {
    $administrator = createArticuloInventarioAdmin('inventory-update@example.org');
    $article = ArticuloInventario::query()->create([
        ...articuloInventarioInput(),
        'stock_actual' => 8,
    ]);
    $token = $administrator->createToken('inventory-update-test')->plainTextToken;

    $this->withToken($token)
        ->patchJson('/api/articulos-inventario/'.$article->id, articuloInventarioInput([
            'nombre' => 'Alimento para perros senior',
            'categoria' => 'Nutrición',
            'unidad_medida' => 'Saco',
            'stock_minimo_alerta' => 6,
            'stock_actual' => 0,
        ]))
        ->assertOk()
        ->assertJsonPath('articulo.nombre', 'Alimento para perros senior')
        ->assertJsonPath('articulo.stock_actual', 8)
        ->assertJsonPath('articulo.stock_minimo_alerta', 6);

    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $article->id,
        'nombre' => 'Alimento para perros senior',
        'categoria' => 'Nutrición',
        'unidad_medida' => 'Saco',
        'stock_actual' => '8.00',
        'stock_minimo_alerta' => '6.00',
    ]);

    $this->assertDatabaseHas('bitacoras', [
        'tipo_accion' => 'Modificar artículo de inventario',
        'modulo' => 'inventario',
        'entidad_tipo' => 'ArticuloInventario',
        'entidad_id' => (string) $article->id,
    ]);
});

test('inventory catalog rejects invalid minimum stock and non-administrator access', function () {
    $this->postJson('/api/articulos-inventario', articuloInventarioInput())
        ->assertUnauthorized();

    $administrator = createArticuloInventarioAdmin('inventory-invalid@example.org');
    $administratorToken = $administrator->createToken('inventory-invalid-test')->plainTextToken;

    $this->withToken($administratorToken)
        ->postJson('/api/articulos-inventario', articuloInventarioInput([
            'stock_minimo_alerta' => -1,
        ]))
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['stock_minimo_alerta']);

    $staff = createArticuloInventarioAdmin('inventory-staff@example.org', 'Veterinario');
    $staffToken = $staff->createToken('inventory-staff-test')->plainTextToken;

    $this->app['auth']->forgetGuards();

    $this->withToken($staffToken)
        ->getJson('/api/articulos-inventario')
        ->assertForbidden();
});

test('inventory catalog page renders through Inertia', function () {
    $this->get('/articulos-inventario')
        ->assertOk()
        ->assertInertia(fn ($page) => $page
            ->component('articulos-inventario')
            ->has('errors'));
});
