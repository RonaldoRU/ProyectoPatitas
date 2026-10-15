<?php

use App\Models\Bitacora;
use App\Models\Proveedor;
use App\Models\User;

function createProveedorAdmin(string $email, string $role = 'Administrador'): User
{
    $user = new User([
        'nombre' => 'Administradora de prueba',
        'email' => $email,
        'rol' => $role,
        'password' => 'refugio-password',
    ]);
    $user->forceFill(['telefono' => '70000000'])->save();

    return $user;
}

function proveedorPayload(array $overrides = []): array
{
    return array_merge([
        'nombre_empresa' => 'Distribuidora Huellas',
        'nombre_contacto' => 'Ana Flores',
        'telefono' => '70000021',
        'direccion' => 'Avenida Central 321',
        'identificacion' => '123456789',
        'tipo_insumo_provisto' => 'Alimentos y suplementos',
    ], $overrides);
}

test('an administrator registers, lists, and edits the supplier directory with audit records', function () {
    $administrator = createProveedorAdmin('proveedores-admin@example.org');
    $token = $administrator->createToken('supplier-directory-test')->plainTextToken;

    $response = $this->withToken($token)
        ->postJson('/api/proveedores', proveedorPayload([
            'nombre_empresa' => '  Distribuidora   Huellas  ',
            'identificacion' => '  123456789 ',
        ]))
        ->assertCreated()
        ->assertJsonPath('proveedor.nombre_empresa', 'Distribuidora Huellas')
        ->assertJsonPath('proveedor.identificacion', '123456789')
        ->assertJsonPath('proveedor.tipo_insumo_provisto', 'Alimentos y suplementos')
        ->assertJsonPath('proveedor.activo', true);

    $supplierId = $response->json('proveedor.id');

    $this->assertDatabaseHas('proveedors', [
        'id' => $supplierId,
        'nombre_empresa' => 'Distribuidora Huellas',
        'identificacion' => '123456789',
        'tipo_insumo_provisto' => 'Alimentos y suplementos',
        'activo' => true,
    ]);
    $this->assertDatabaseHas('bitacoras', [
        'tipo_accion' => 'Registrar proveedor de insumos',
        'id_usuario' => $administrator->id,
        'entidad_tipo' => 'Proveedor',
        'entidad_id' => (string) $supplierId,
    ]);

    $this->withToken($token)
        ->getJson('/api/proveedores')
        ->assertOk()
        ->assertJsonPath('proveedores.0.nombre_empresa', 'Distribuidora Huellas');

    $this->withToken($token)
        ->patchJson('/api/proveedores/'.$supplierId, proveedorPayload([
            'nombre_empresa' => 'Distribuidora Huellas del Sur',
            'tipo_insumo_provisto' => 'Medicamentos',
        ]))
        ->assertOk()
        ->assertJsonPath('proveedor.nombre_empresa', 'Distribuidora Huellas del Sur')
        ->assertJsonPath('proveedor.tipo_insumo_provisto', 'Medicamentos');

    $this->assertDatabaseHas('proveedors', [
        'id' => $supplierId,
        'nombre_empresa' => 'Distribuidora Huellas del Sur',
        'tipo_insumo_provisto' => 'Medicamentos',
    ]);
    $this->assertDatabaseHas('bitacoras', [
        'tipo_accion' => 'Modificar proveedor de insumos',
        'entidad_tipo' => 'Proveedor',
        'entidad_id' => (string) $supplierId,
    ]);
});

test('active suppliers cannot share a commercial name or identification number', function () {
    $administrator = createProveedorAdmin('proveedores-duplicados@example.org');
    $existing = Proveedor::query()->create(proveedorPayload([
        'nombre_empresa' => 'Distribuidora Huéllas',
        'identificacion' => 'ABC-123',
    ]));
    $editable = Proveedor::query()->create(proveedorPayload([
        'nombre_empresa' => 'Comercial Patitas',
        'identificacion' => 'XYZ-789',
    ]));
    $token = $administrator->createToken('supplier-duplicates-test')->plainTextToken;

    $this->withToken($token)
        ->postJson('/api/proveedores', proveedorPayload([
            'nombre_empresa' => '  DISTRIBUIDORA HUELLAS ',
            'identificacion' => 'abc-123',
        ]))
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['nombre_empresa', 'identificacion'])
        ->assertJsonPath('errors.nombre_empresa.0', 'Ya existe un proveedor activo con ese nombre comercial.')
        ->assertJsonPath('errors.identificacion.0', 'Ya existe un proveedor activo con ese número de identificación.');

    $this->withToken($token)
        ->patchJson('/api/proveedores/'.$editable->id, proveedorPayload([
            'nombre_empresa' => 'Distribuidora Huellas',
            'identificacion' => 'abc-123',
        ]))
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['nombre_empresa', 'identificacion']);

    $this->assertModelExists($existing);
    $this->assertDatabaseHas('proveedors', [
        'id' => $editable->id,
        'nombre_empresa' => 'Comercial Patitas',
        'identificacion' => 'XYZ-789',
    ]);
    expect(Proveedor::query()->count())->toBe(2);
});

test('inactive supplier duplicates are allowed but cannot be reactivated while an active duplicate exists', function () {
    $administrator = createProveedorAdmin('proveedores-reactivar@example.org');
    $inactive = Proveedor::query()->create([
        ...proveedorPayload(),
        'activo' => false,
    ]);
    $active = Proveedor::query()->create(proveedorPayload([
        'nombre_empresa' => 'Distribuidora Huellas',
        'identificacion' => '987654321',
    ]));
    $token = $administrator->createToken('supplier-reactivate-test')->plainTextToken;

    $this->withToken($token)
        ->patchJson('/api/proveedores/'.$inactive->id.'/estado', ['activo' => true])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['nombre_empresa']);

    $this->assertDatabaseHas('proveedors', [
        'id' => $inactive->id,
        'activo' => false,
    ]);
    $this->assertDatabaseHas('proveedors', [
        'id' => $active->id,
        'activo' => true,
    ]);
    expect(Proveedor::query()->count())->toBe(2);
});

test('deactivating a supplier retains the supplier record and audit history', function () {
    $administrator = createProveedorAdmin('proveedores-desactivar@example.org');
    $supplier = Proveedor::query()->create(proveedorPayload());
    $token = $administrator->createToken('supplier-deactivate-test')->plainTextToken;

    $this->withToken($token)
        ->patchJson('/api/proveedores/'.$supplier->id.'/estado', ['activo' => false])
        ->assertOk()
        ->assertJsonPath('proveedor.activo', false);

    $this->assertDatabaseHas('proveedors', [
        'id' => $supplier->id,
        'activo' => false,
    ]);
    $this->assertDatabaseHas('bitacoras', [
        'tipo_accion' => 'Desactivar proveedor de insumos',
        'entidad_id' => (string) $supplier->id,
    ]);
    expect(Proveedor::query()->count())->toBe(1)
        ->and(Bitacora::query()->where('tipo_accion', 'Desactivar proveedor de insumos')->count())->toBe(1);
});

test('provider management endpoints require an administrator and reject incomplete data', function () {
    $this->getJson('/api/proveedores')->assertUnauthorized();

    $staff = createProveedorAdmin('proveedores-staff@example.org', 'Recepcionista');
    $staffToken = $staff->createToken('supplier-management-staff-test')->plainTextToken;

    $this->withToken($staffToken)
        ->getJson('/api/proveedores')
        ->assertForbidden();
    $this->withToken($staffToken)
        ->postJson('/api/proveedores', proveedorPayload())
        ->assertForbidden();

    $this->app['auth']->forgetGuards();
    $administrator = createProveedorAdmin('proveedores-validacion@example.org');
    $adminToken = $administrator->createToken('supplier-validation-test')->plainTextToken;

    $this->withToken($adminToken)
        ->postJson('/api/proveedores', [])
        ->assertUnprocessable()
        ->assertJsonValidationErrors([
            'nombre_empresa',
            'nombre_contacto',
            'telefono',
            'direccion',
            'tipo_insumo_provisto',
        ])
        ->assertJsonPath('errors.tipo_insumo_provisto.0', 'Indica qué tipo de insumos provee la empresa.');

    expect(Proveedor::query()->count())->toBe(0);
});

test('supplier management page renders through Inertia', function () {
    $this->get('/proveedores')
        ->assertOk()
        ->assertInertia(fn ($page) => $page->component('proveedores'));
});
