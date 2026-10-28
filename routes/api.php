<?php

use App\Http\Controllers\P10_IndicadoresGerenciales\DashboardController;
use App\Http\Controllers\P10_IndicadoresGerenciales\ReporteGerencialController;
use App\Http\Controllers\P1_Seguridad\AuthController;
use App\Http\Controllers\P2_Usuarios\UsuarioController;
use App\Http\Controllers\P3_Auditoria\BitacoraController;
use App\Http\Controllers\P4_CatalogoExistencias\AjusteInventarioController;
use App\Http\Controllers\P4_CatalogoExistencias\ArticuloInventarioController;
use App\Http\Controllers\P5_Abastecimiento\EntradaInsumoController;
use App\Http\Controllers\P5_Abastecimiento\ProveedorController;
use App\Http\Controllers\P5_Abastecimiento\SalidaInventarioController;
use App\Http\Controllers\P6_AutomatizacionClinica\AutomatizacionClinicaController;
use App\Http\Controllers\P7_RescateClinico\HistorialClinicoController;
use App\Http\Controllers\P7_RescateClinico\MascotaController;
use App\Http\Controllers\P8_Adopciones\AdopcionController;
use App\Http\Controllers\P8_Adopciones\PostulanteController;
use App\Http\Controllers\P8_Adopciones\SeguimientoAdopcionController;
use App\Http\Controllers\P9_PagosDonaciones\DonacionController;
use App\Http\Controllers\P9_PagosDonaciones\DonanteController;
use App\Http\Controllers\P9_PagosDonaciones\PasarelaPagoController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Rutas públicas de autenticación (P1)
Route::post('/login', [AuthController::class, 'login'])->name('api.login');
Route::post('/solicitar-codigo', [AuthController::class, 'solicitarCodigo'])
    ->middleware('throttle:5,1')
    ->name('api.password.request');
Route::post('/restablecer-password', [AuthController::class, 'restablecerPassword'])
    ->middleware('throttle:5,1')
    ->name('api.password.reset');

// Webhook bancario público (P9 - CU27)
Route::post('/pasarela/webhook', [PasarelaPagoController::class, 'webhook'])->name('api.pasarela.webhook');

Route::middleware('auth:sanctum')->group(function (): void {
    // P1: Sesión
    Route::post('/logout', [AuthController::class, 'logout'])->name('api.logout');
    Route::get('/user', function (Request $request) {
        return $request->user()->only(['id', 'nombre', 'email', 'rol']);
    })->name('api.user');

    // P2: Usuarios (RBAC)
    Route::get('/usuarios', [UsuarioController::class, 'index'])->name('api.usuarios.index');
    Route::post('/usuarios', [UsuarioController::class, 'store'])->name('api.usuarios.store');
    Route::patch('/usuarios/{usuario}', [UsuarioController::class, 'update'])->name('api.usuarios.update');
    Route::patch('/usuarios/{usuario}/rol', [UsuarioController::class, 'changeRole'])->name('api.usuarios.role');
    Route::patch('/usuarios/{usuario}/estado', [UsuarioController::class, 'setStatus'])->name('api.usuarios.status');

    // P3: Bitácora y Auditoría
    Route::get('/bitacora', [BitacoraController::class, 'index'])->name('api.bitacora.index');

    // P4: Catálogo y Existencias
    Route::apiResource('articulos-inventario', ArticuloInventarioController::class)
        ->only(['index', 'store', 'update'])
        ->parameters(['articulos-inventario' => 'articuloInventario'])
        ->names('api.articulos-inventario');
    Route::get('/ajustes-inventario', [AjusteInventarioController::class, 'index'])->name('api.ajustes-inventario.index');
    Route::post('/ajustes-inventario', [AjusteInventarioController::class, 'store'])->name('api.ajustes-inventario.store');

    // P5: Abastecimiento y Proveedores
    Route::get('/proveedores', [ProveedorController::class, 'index'])->name('api.proveedores.index');
    Route::post('/proveedores', [ProveedorController::class, 'store'])->name('api.proveedores.store');
    Route::patch('/proveedores/{proveedor}', [ProveedorController::class, 'update'])->name('api.proveedores.update');
    Route::patch('/proveedores/{proveedor}/estado', [ProveedorController::class, 'setStatus'])->name('api.proveedores.status');

    Route::get('/entradas-insumos/catalogos', [EntradaInsumoController::class, 'catalogos'])->name('api.entradas-insumos.catalogos');
    Route::post('/entradas-insumos', [EntradaInsumoController::class, 'store'])->name('api.entradas-insumos.store');

    Route::get('/salidas-inventario/catalogos', [SalidaInventarioController::class, 'catalogos'])->name('api.salidas-inventario.catalogos');
    Route::post('/salidas-inventario', [SalidaInventarioController::class, 'store'])->name('api.salidas-inventario.store');

    // P6: Automatización Clínica
    Route::get('/clinica/vencimientos', [AutomatizacionClinicaController::class, 'alertasVencimiento'])->name('api.clinica.vencimientos');
    Route::post('/clinica/descargo-stock', [AutomatizacionClinicaController::class, 'descargoStockClinico'])->name('api.clinica.descargo-stock');

    // P7: Rescate e Historial Clínico
    Route::get('/mascotas', [MascotaController::class, 'index'])->name('api.mascotas.index');
    Route::post('/mascotas', [MascotaController::class, 'store'])->name('api.mascotas.store');
    Route::get('/mascotas/{mascota}', [MascotaController::class, 'show'])->name('api.mascotas.show');
    Route::patch('/mascotas/{mascota}', [MascotaController::class, 'update'])->name('api.mascotas.update');

    Route::get('/atenciones-clinicas/catalogos', [HistorialClinicoController::class, 'catalogos'])->name('api.atenciones-clinicas.catalogos');
    Route::post('/atenciones-clinicas', [HistorialClinicoController::class, 'store'])->name('api.atenciones-clinicas.store');
    Route::get('/historial-clinico/mascota/{mascota}', [HistorialClinicoController::class, 'porMascota'])->name('api.historial-clinico.mascota');

    // P8: Adopciones y Seguimiento
    Route::get('/postulantes', [PostulanteController::class, 'index'])->name('api.postulantes.index');
    Route::post('/postulantes', [PostulanteController::class, 'store'])->name('api.postulantes.store');
    Route::patch('/postulantes/{postulante}', [PostulanteController::class, 'update'])->name('api.postulantes.update');
    Route::post('/postulantes/{postulante}/adopciones', [PostulanteController::class, 'storeAdoption'])->name('api.postulantes.adopciones.store');

    Route::get('/adopciones', [AdopcionController::class, 'index'])->name('api.adopciones.index');
    Route::post('/adopciones', [AdopcionController::class, 'store'])->name('api.adopciones.store');
    Route::get('/adopciones/{adopcion}', [AdopcionController::class, 'show'])->name('api.adopciones.show');
    Route::get('/adopciones/{adopcion}/acta', [AdopcionController::class, 'actaPdf'])->name('api.adopciones.acta');

    Route::get('/seguimientos', [SeguimientoAdopcionController::class, 'index'])->name('api.seguimientos.index');
    Route::patch('/seguimientos/{seguimiento}', [SeguimientoAdopcionController::class, 'update'])->name('api.seguimientos.update');

    // P9: Donaciones y Pasarela de Pagos
    Route::get('/donantes', [DonanteController::class, 'index'])->name('api.donantes.index');
    Route::post('/donantes', [DonanteController::class, 'store'])->name('api.donantes.store');
    Route::get('/donantes/search', [DonanteController::class, 'search'])->name('api.donantes.search');

    Route::get('/donaciones', [DonacionController::class, 'index'])->name('api.donaciones.index');
    Route::post('/donaciones', [DonacionController::class, 'store'])->name('api.donaciones.store');

    Route::post('/pasarela/iniciar', [PasarelaPagoController::class, 'iniciarPago'])->name('api.pasarela.iniciar');
    Route::post('/pasarela/confirmar-manual', [PasarelaPagoController::class, 'confirmarManual'])->name('api.pasarela.confirmar-manual');
    Route::get('/pasarela/comprobante/{id}', [PasarelaPagoController::class, 'generarComprobante'])->name('api.pasarela.comprobante');
    Route::get('/pasarela/conciliacion', [PasarelaPagoController::class, 'conciliacion'])->name('api.pasarela.conciliacion');
    Route::post('/pasarela/reembolso', [PasarelaPagoController::class, 'reembolso'])->name('api.pasarela.reembolso');

    // P10: Indicadores Gerenciales
    Route::get('/dashboard', [DashboardController::class, 'getDashboardData'])->name('api.dashboard');
    Route::get('/reportes/indicadores', [ReporteGerencialController::class, 'index'])->name('api.reportes.indicadores');
    Route::get('/reportes/exportar', [ReporteGerencialController::class, 'exportar'])->name('api.reportes.exportar');
});
