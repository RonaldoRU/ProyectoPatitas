<?php

use App\Models\ArticuloInventario;
use App\Models\Bitacora;
use App\Models\DetalleSalida;
use App\Models\DetalleSalidaLote;
use App\Models\InventarioLote;
use App\Models\Mascota;
use App\Models\SalidaInventario;
use App\Models\User;
use Illuminate\Support\Facades\DB;

function createVencimientoUser(string $email, string $rol): User
{
    $user = new User([
        'nombre' => 'Personal de prueba',
        'email' => $email,
        'rol' => $rol,
        'password' => 'refugio-password',
    ]);
    $user->forceFill(['telefono' => '70000000'])->save();

    return $user;
}

function createVencimientoArticulo(string $categoria = 'Medicamento', string $stock = '10.00'): ArticuloInventario
{
    return ArticuloInventario::query()->create([
        'nombre' => $categoria === 'Alimento' ? 'Alimento de prueba' : 'Antibiótico de prueba',
        'categoria' => $categoria,
        'unidad_medida' => 'Frasco',
        'stock_actual' => $stock,
        'stock_minimo_alerta' => '2.00',
    ]);
}

function createVencimientoLote(
    ArticuloInventario $articulo,
    int $cantidad,
    ?string $fechaVencimiento,
): InventarioLote {
    return InventarioLote::query()->create([
        'id_articulo' => $articulo->id,
        'fecha_vencimiento' => $fechaVencimiento,
        'cantidad_inicial' => $cantidad,
        'cantidad_disponible' => $cantidad,
    ]);
}

function createVencimientoMascota(): Mascota
{
    return Mascota::query()->create([
        'nombre' => 'Luna',
        'raza' => 'Mestiza',
        'edad' => '3 años',
        'especie' => 'Canino',
        'estado_actual' => 'En tratamiento',
        'fecha_ingreso' => now()->toDateString(),
        'sexo' => 'Hembra',
        'zona_rescate' => 'Centro',
        'foto' => 'mascotas/luna.jpg',
    ]);
}

test('dashboard alerts admins by lot within 30 days without repeating consumed or unrelated stock', function () {
    $admin = createVencimientoUser('alertas-vencimiento-admin@example.org', 'Administrador');
    $article = createVencimientoArticulo(stock: '10.00');
    $expired = createVencimientoLote($article, 1, now()->subDay()->toDateString());
    $upcoming = createVencimientoLote($article, 2, now()->addDays(30)->toDateString());
    createVencimientoLote($article, 3, now()->addDays(31)->toDateString());
    createVencimientoLote($article, 1, null);
    $consumed = createVencimientoLote($article, 2, now()->addDays(2)->toDateString());
    $consumed->update(['cantidad_disponible' => 0]);
    $food = createVencimientoArticulo('Alimento', '1.00');
    createVencimientoLote($food, 1, now()->subDay()->toDateString());

    $response = $this->withToken($admin->createToken('expiry-dashboard-admin')->plainTextToken)
        ->getJson('/api/dashboard')
        ->assertOk();

    $response->assertJsonPath('alertas_vencimiento.vencidos.0.id', $expired->id)
        ->assertJsonPath('alertas_vencimiento.proximos.0.id', $upcoming->id)
        ->assertJsonPath('alertas_vencimiento.sin_fecha.0.articulo', $article->nombre);
    expect($response->json('alertas_vencimiento.proximos'))->toHaveCount(1)
        ->and($response->json('alertas_vencimiento.vencidos'))->toHaveCount(1)
        ->and($response->json('alertas_vencimiento.sin_fecha'))->toHaveCount(1);
});

test('dashboard hides medication expiration alerts from roles outside administrator and veterinarian', function () {
    $receptionist = createVencimientoUser('alertas-vencimiento-recepcionista@example.org', 'Recepcionista');
    $article = createVencimientoArticulo();
    createVencimientoLote($article, 2, now()->addDays(5)->toDateString());

    $this->withToken($receptionist->createToken('expiry-dashboard-staff')->plainTextToken)
        ->getJson('/api/dashboard')
        ->assertOk()
        ->assertJsonPath('alertas_vencimiento.proximos', [])
        ->assertJsonPath('alertas_vencimiento.vencidos', [])
        ->assertJsonPath('alertas_vencimiento.sin_fecha', []);
});

test('veterinarians receive medication expiration alerts in their dashboard', function () {
    $veterinarian = createVencimientoUser('alertas-vencimiento-veterinario@example.org', 'Veterinario');
    $article = createVencimientoArticulo();
    createVencimientoLote($article, 2, now()->addDays(5)->toDateString());

    $this->withToken($veterinarian->createToken('expiry-dashboard-veterinarian')->plainTextToken)
        ->getJson('/api/dashboard')
        ->assertOk()
        ->assertJsonPath('user.rol', 'Veterinario')
        ->assertJsonPath('alertas_vencimiento.proximos.0.articulo', $article->nombre);
});

test('stockout consumes medication lots by earliest expiry and does not offer expired quantities', function () {
    $user = createVencimientoUser('salida-fefo@example.org', 'Recepcionista');
    $article = createVencimientoArticulo(stock: '10.00');
    $expired = createVencimientoLote($article, 2, now()->subDay()->toDateString());
    $firstExpiring = createVencimientoLote($article, 3, now()->addDays(2)->toDateString());
    $secondExpiring = createVencimientoLote($article, 5, now()->addDays(10)->toDateString());
    $token = $user->createToken('expiry-stockout-test')->plainTextToken;

    $this->withToken($token)
        ->getJson('/api/salidas-inventario/catalogos')
        ->assertOk()
        ->assertJsonPath('articulos.0.stock_actual', 8);

    $response = $this->withToken($token)
        ->postJson('/api/salidas-inventario', [
            'motivo' => 'Tratamiento',
            'destino' => 'Clínica',
            'fecha_salida' => now()->toDateString(),
            'lineas' => [['id_articulo' => $article->id, 'cantidad' => '4']],
        ])
        ->assertCreated()
        ->assertJsonPath('salida.articulos_actualizados.0.stock_actual', '4.00');

    $salidaId = $response->json('salida.id');
    $detalleId = DetalleSalida::query()->where('id_salida', $salidaId)->value('id');

    $this->assertDatabaseHas('detalle_salida_lotes', [
        'id_detalle_salida' => $detalleId,
        'id_inventario_lote' => $firstExpiring->id,
        'cantidad' => '3.00',
    ]);
    $this->assertDatabaseHas('detalle_salida_lotes', [
        'id_detalle_salida' => $detalleId,
        'id_inventario_lote' => $secondExpiring->id,
        'cantidad' => '1.00',
    ]);
    expect(DetalleSalidaLote::query()->count())->toBe(2)
        ->and((float) $expired->fresh()->cantidad_disponible)->toBe(2.0)
        ->and((float) $secondExpiring->fresh()->cantidad_disponible)->toBe(4.0);
});

test('clinical attention cannot consume a medication lot past its expiry date', function () {
    $veterinarian = createVencimientoUser('atencion-lote-vencido@example.org', 'Veterinario');
    $article = createVencimientoArticulo(stock: '2.00');
    createVencimientoLote($article, 2, now()->subDay()->toDateString());
    $mascota = createVencimientoMascota();

    $this->withToken($veterinarian->createToken('clinical-expired-lot')->plainTextToken)
        ->postJson('/api/atenciones-clinicas', [
            'fecha_atencion' => now()->toDateString(),
            'id_mascota' => $mascota->id,
            'diagnostico' => 'Revisión',
            'observacion' => 'Sin observaciones',
            'tipo_procedimiento' => 'Consulta',
            'lineas' => [['id_articulo' => $article->id, 'cantidad' => '1']],
        ])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['lineas.0.cantidad']);

    expect(SalidaInventario::query()->count())->toBe(0)
        ->and(DB::table('historial_clinicos')->count())->toBe(0);
    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $article->id,
        'stock_actual' => '2.00',
    ]);
});

test('scheduled expiry processing removes expired medicine once and records the automatic action', function () {
    $article = createVencimientoArticulo(stock: '6.00');
    $expired = createVencimientoLote($article, 4, now()->subDay()->toDateString());
    $valid = createVencimientoLote($article, 2, now()->addDay()->toDateString());

    $this->artisan('app:expirar-lotes-inventario')->assertSuccessful();

    $this->assertDatabaseHas('articulo_inventarios', [
        'id' => $article->id,
        'stock_actual' => '2.00',
    ]);
    expect((float) $expired->fresh()->cantidad_disponible)->toBe(0.0)
        ->and((float) $expired->fresh()->cantidad_vencida)->toBe(4.0)
        ->and((float) $valid->fresh()->cantidad_disponible)->toBe(2.0);
    $this->assertDatabaseHas('bitacoras', [
        'tipo_accion' => 'Dar de baja lotes de medicamentos vencidos',
        'usuario_nombre' => 'Sistema automático',
        'entidad_tipo' => 'InventarioLote',
        'entidad_id' => (string) $expired->id,
    ]);

    $this->artisan('app:expirar-lotes-inventario')->assertSuccessful();

    expect(Bitacora::query()->where('tipo_accion', 'Dar de baja lotes de medicamentos vencidos')->count())
        ->toBe(1);
});
