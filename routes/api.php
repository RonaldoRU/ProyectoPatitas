<?php

use App\Http\Controllers\IAComandoVozController;
use App\Http\Controllers\P01_SeguridadUsuariosAuditoria\AuditoriaForenseController;
use App\Http\Controllers\P01_SeguridadUsuariosAuditoria\AuthController;
use App\Http\Controllers\P01_SeguridadUsuariosAuditoria\BitacoraController;
use App\Http\Controllers\P01_SeguridadUsuariosAuditoria\UsuarioController;
use App\Http\Controllers\P02_LogisticaInventario\AjusteInventarioController;
use App\Http\Controllers\P02_LogisticaInventario\ArticuloInventarioController;
use App\Http\Controllers\P02_LogisticaInventario\AutomatizacionClinicaController;
use App\Http\Controllers\P02_LogisticaInventario\EntradaInsumoController;
use App\Http\Controllers\P02_LogisticaInventario\ProveedorController;
use App\Http\Controllers\P02_LogisticaInventario\SalidaInventarioController;
use App\Http\Controllers\P03_RescateClinicaAdopciones\AdopcionController;
use App\Http\Controllers\P03_RescateClinicaAdopciones\HistorialClinicoController;
use App\Http\Controllers\P03_RescateClinicaAdopciones\MascotaController;
use App\Http\Controllers\P03_RescateClinicaAdopciones\PostulanteController;
use App\Http\Controllers\P03_RescateClinicaAdopciones\PrescripcionDosificacionController;
use App\Http\Controllers\P03_RescateClinicaAdopciones\SeguimientoAdopcionController;
use App\Http\Controllers\P04_DonacionesPasarela\DonacionController;
use App\Http\Controllers\P04_DonacionesPasarela\DonanteController;
use App\Http\Controllers\P04_DonacionesPasarela\PasarelaPagoController;
use App\Http\Controllers\P05_FacturacionReportes\DashboardController;
use App\Http\Controllers\P05_FacturacionReportes\DosificacionFiscalController;
use App\Http\Controllers\P05_FacturacionReportes\FacturaLegalController;
use App\Http\Controllers\P05_FacturacionReportes\LibroIvaController;
use App\Http\Controllers\P05_FacturacionReportes\RendicionCuentasController;
use App\Http\Controllers\P05_FacturacionReportes\ReporteGerencialController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes - Arquitectura Consolidada en 5 Macro-Paquetes
|--------------------------------------------------------------------------
|
| P01: Seguridad, Usuarios y Auditoría Forense (CU01-CU10, CU35)
| P02: Logística de Inventario, Despensa y Proveedores (CU11-CU16, CU18, CU24)
| P03: Gestión de Rescates, Clínica Veterinaria y Adopciones (CU17, CU19-CU23, CU34)
| P04: Donaciones Monetarias y Pasarela de Pagos (CU25-CU29)
| P05: Facturación Legal (SIN), Tributación y Reportes Gerenciales (CU30-CU33, CU36-CU37)
|
*/

// =========================================================================
// RUTAS PÚBLICAS (Sin autenticación requerida)
// =========================================================================

// Paquete 1: Autenticación, Registro Público (Donante / Postulante) y Recuperación
Route::post('/login', [AuthController::class, 'login'])->name('api.login'); // CU01
Route::post('/registro-publico', [AuthController::class, 'registroPublico'])->name('api.registro.publico');
Route::post('/solicitar-codigo', [AuthController::class, 'solicitarCodigo']) // CU03
    ->middleware('throttle:5,1')
    ->name('api.password.request');
Route::post('/restablecer-password', [AuthController::class, 'restablecerPassword']) // CU03
    ->middleware('throttle:5,1')
    ->name('api.password.reset');

// Paquete 4: Donaciones Públicas Online y Webhooks de Pasarela
Route::post('/donaciones/publica', [DonacionController::class, 'storePublica'])->name('api.donaciones.publica'); // CU25, CU27
Route::post('/pasarela/webhook', [PasarelaPagoController::class, 'webhook'])->name('api.pasarela.webhook'); // CU26

// Paquete 3: Catálogo público de adopción (solo lectura con fotos y estado)
Route::get('/mascotas-disponibles', [MascotaController::class, 'disponiblesPublico'])->name('api.mascotas.disponibles'); // CU19

// =========================================================================
// RUTAS PRIVADAS (Protegidas con autenticación Sanctum)
// =========================================================================
Route::middleware('auth:sanctum')->group(function (): void {

    // ---------------------------------------------------------------------
    // ASISTENCIA IA POR COMANDO DE VOZ
    // ---------------------------------------------------------------------
    Route::get('/ia/info', [IAComandoVozController::class, 'info'])->name('api.ia.info');
    Route::post('/ia/comando-voz', [IAComandoVozController::class, 'procesar'])->name('api.ia.comando-voz');

    // ---------------------------------------------------------------------
    // PAQUETE 1: SEGURIDAD, USUARIOS Y AUDITORÍA FORENSE (11 CUs)
    // ---------------------------------------------------------------------
    // CU02: Cerrar Sesión y Revocar Token JWT
    Route::post('/logout', [AuthController::class, 'logout'])->name('api.logout');
    Route::get('/user', function (Request $request) {
        return $request->user()->only(['id', 'nombre', 'email', 'rol']);
    })->name('api.user');

    // CU04 - CU08: Gestión de Usuarios, Roles RBAC y Estado
    Route::get('/usuarios', [UsuarioController::class, 'index'])->name('api.usuarios.index'); // CU05
    Route::post('/usuarios', [UsuarioController::class, 'store'])->name('api.usuarios.store'); // CU04
    Route::patch('/usuarios/{usuario}', [UsuarioController::class, 'update'])->name('api.usuarios.update'); // CU06
    Route::patch('/usuarios/{usuario}/rol', [UsuarioController::class, 'changeRole'])->name('api.usuarios.role'); // CU07
    Route::patch('/usuarios/{usuario}/estado', [UsuarioController::class, 'setStatus'])->name('api.usuarios.status'); // CU08

    // CU09, CU10: Bitácora de Auditoría Básica
    Route::get('/bitacora', [BitacoraController::class, 'index'])->name('api.bitacora.index'); // CU10

    // CU35: Auditoría Forense y Verificación de Integridad Inmutable
    Route::get('/auditoria-forense', [AuditoriaForenseController::class, 'index'])->name('api.auditoria-forense.index'); // CU35

    // ---------------------------------------------------------------------
    // PAQUETE 2: LOGÍSTICA DE INVENTARIO, DESPENSA Y PROVEEDORES (8 CUs)
    // ---------------------------------------------------------------------
    // CU11, CU12: Catálogo de Artículos y Control de Stock Mínimo
    Route::apiResource('articulos-inventario', ArticuloInventarioController::class)
        ->only(['index', 'store', 'update'])
        ->parameters(['articulos-inventario' => 'articuloInventario'])
        ->names('api.articulos-inventario');

    // CU13: Registrar Mermas y Ajustes de Inventario (FEFO)
    Route::get('/ajustes-inventario', [AjusteInventarioController::class, 'index'])->name('api.ajustes-inventario.index');
    Route::post('/ajustes-inventario', [AjusteInventarioController::class, 'store'])->name('api.ajustes-inventario.store');

    // CU14, CU24: Registrar Entradas de Insumos / Compras / Donaciones en Especie
    Route::get('/entradas-insumos/catalogos', [EntradaInsumoController::class, 'catalogos'])->name('api.entradas-insumos.catalogos');
    Route::post('/entradas-insumos', [EntradaInsumoController::class, 'store'])->name('api.entradas-insumos.store');

    // CU15: Registrar Salidas y Consumo de Despensa
    Route::get('/salidas-inventario/catalogos', [SalidaInventarioController::class, 'catalogos'])->name('api.salidas-inventario.catalogos');
    Route::post('/salidas-inventario', [SalidaInventarioController::class, 'store'])->name('api.salidas-inventario.store');

    // CU16: Gestión de Proveedores
    Route::get('/proveedores', [ProveedorController::class, 'index'])->name('api.proveedores.index');
    Route::post('/proveedores', [ProveedorController::class, 'store'])->name('api.proveedores.store');
    Route::patch('/proveedores/{proveedor}', [ProveedorController::class, 'update'])->name('api.proveedores.update');
    Route::patch('/proveedores/{proveedor}/estado', [ProveedorController::class, 'setStatus'])->name('api.proveedores.status');

    // CU18: Control y Alertas de Vencimiento de Fármacos (FEFO)
    Route::get('/clinica/vencimientos', [AutomatizacionClinicaController::class, 'alertasVencimiento'])->name('api.clinica.vencimientos');

    // ---------------------------------------------------------------------
    // PAQUETE 3: GESTIÓN DE RESCATES, CLÍNICA VETERINARIA Y ADOPCIONES (7 CUs)
    // ---------------------------------------------------------------------
    // CU19: Registrar Ficha de Rescate e Ingreso de Mascota
    Route::get('/mascotas', [MascotaController::class, 'index'])->name('api.mascotas.index');
    Route::post('/mascotas', [MascotaController::class, 'store'])->name('api.mascotas.store');
    Route::get('/mascotas/{mascota}', [MascotaController::class, 'show'])->name('api.mascotas.show');
    Route::match(['put', 'patch'], '/mascotas/{mascota}', [MascotaController::class, 'update'])->name('api.mascotas.update');

    // CU17, CU20: Expediente Clínico y Atención Médica con Descargo Automático
    Route::get('/atenciones-clinicas/catalogos', [HistorialClinicoController::class, 'catalogos'])->name('api.atenciones-clinicas.catalogos');
    Route::post('/atenciones-clinicas', [HistorialClinicoController::class, 'store'])->name('api.atenciones-clinicas.store'); // CU20
    Route::get('/historial-clinico/mascota/{mascota}', [HistorialClinicoController::class, 'porMascota'])->name('api.historial-clinico.mascota');
    Route::post('/clinica/descargo-stock', [AutomatizacionClinicaController::class, 'descargoStockClinico'])->name('api.clinica.descargo-stock'); // CU17

    // CU34: Dosificación Automática y Programación de Tratamientos Veterinarios
    Route::get('/dosificacion-clinica/catalogos', [PrescripcionDosificacionController::class, 'catalogos'])->name('api.dosificacion-clinica.catalogos');
    Route::get('/dosificacion-clinica', [PrescripcionDosificacionController::class, 'index'])->name('api.dosificacion-clinica.index');
    Route::post('/dosificacion-clinica', [PrescripcionDosificacionController::class, 'store'])->name('api.dosificacion-clinica.store');
    Route::patch('/dosificacion-clinica/tomas/{toma}', [PrescripcionDosificacionController::class, 'marcarToma'])->name('api.dosificacion-clinica.marcar-toma');

    // CU21: Registrar y Evaluar Postulante a Adopción
    Route::get('/postulantes', [PostulanteController::class, 'index'])->name('api.postulantes.index');
    Route::post('/postulantes', [PostulanteController::class, 'store'])->name('api.postulantes.store');
    Route::patch('/postulantes/{postulante}', [PostulanteController::class, 'update'])->name('api.postulantes.update');
    Route::post('/postulantes/{postulante}/adopciones', [PostulanteController::class, 'storeAdoption'])->name('api.postulantes.adopciones.store');

    // CU22: Formalizar Adopción y Contrato Legal
    Route::get('/adopciones', [AdopcionController::class, 'index'])->name('api.adopciones.index');
    Route::post('/adopciones', [AdopcionController::class, 'store'])->name('api.adopciones.store');
    Route::get('/adopciones/{adopcion}', [AdopcionController::class, 'show'])->name('api.adopciones.show');
    Route::get('/adopciones/{adopcion}/acta', [AdopcionController::class, 'actaPdf'])->name('api.adopciones.acta');

    // CU23: Consultar y Registrar Visitas de Seguimiento
    Route::get('/seguimientos', [SeguimientoAdopcionController::class, 'index'])->name('api.seguimientos.index');
    Route::post('/seguimientos', [SeguimientoAdopcionController::class, 'store'])->name('api.seguimientos.store');
    Route::get('/seguimientos/{seguimiento}', [SeguimientoAdopcionController::class, 'show'])->name('api.seguimientos.show');
    Route::match(['post', 'put', 'patch'], '/seguimientos/{seguimiento}', [SeguimientoAdopcionController::class, 'update'])->name('api.seguimientos.update');

    // ---------------------------------------------------------------------
    // PAQUETE 4: DONACIONES MONETARIAS Y PASARELA DE PAGOS (5 CUs)
    // ---------------------------------------------------------------------
    // Catálogo de Donantes
    Route::get('/donantes', [DonanteController::class, 'index'])->name('api.donantes.index');
    Route::post('/donantes', [DonanteController::class, 'store'])->name('api.donantes.store');
    Route::get('/donantes/search', [DonanteController::class, 'search'])->name('api.donantes.search');

    // CU25, CU27: Donaciones Físicas y Comprobantes
    Route::get('/donaciones', [DonacionController::class, 'index'])->name('api.donaciones.index');
    Route::post('/donaciones', [DonacionController::class, 'store'])->name('api.donaciones.store');

    // CU25, CU26, CU28, CU29: Pasarela de Pagos Digital (QR / Tarjetas)
    Route::post('/pasarela/iniciar', [PasarelaPagoController::class, 'iniciarPago'])->name('api.pasarela.iniciar'); // CU25
    Route::post('/pasarela/confirmar-tarjeta', [PasarelaPagoController::class, 'confirmarTarjeta'])->name('api.pasarela.confirmar-tarjeta');
    Route::post('/pasarela/confirmar-manual', [PasarelaPagoController::class, 'confirmarManual'])->name('api.pasarela.confirmar-manual');
    Route::get('/pasarela/comprobante/{id}', [PasarelaPagoController::class, 'generarComprobante'])->name('api.pasarela.comprobante'); // CU27
    Route::get('/pasarela/conciliacion', [PasarelaPagoController::class, 'conciliacion'])->name('api.pasarela.conciliacion'); // CU28
    Route::post('/pasarela/reembolso', [PasarelaPagoController::class, 'reembolso'])->name('api.pasarela.reembolso'); // CU29

    // ---------------------------------------------------------------------
    // PAQUETE 5: FACTURACIÓN LEGAL, TRIBUTACIÓN Y REPORTES GERENCIALES (6 CUs)
    // ---------------------------------------------------------------------
    // CU30: Generar Reportes e Indicadores Gerenciales
    Route::get('/dashboard', [DashboardController::class, 'getDashboardData'])->name('api.dashboard');
    Route::get('/reportes-gerenciales', [ReporteGerencialController::class, 'index'])->name('api.reportes-gerenciales.index');
    Route::get('/reportes-gerenciales/exportar', [ReporteGerencialController::class, 'exportar'])->name('api.reportes-gerenciales.exportar');
    Route::get('/reportes/indicadores', [ReporteGerencialController::class, 'index'])->name('api.reportes.indicadores');
    Route::get('/reportes/exportar', [ReporteGerencialController::class, 'exportar'])->name('api.reportes.exportar');

    // CU31: Dosificación y Autorización Fiscal (SIN)
    Route::get('/dosificaciones-fiscales', [DosificacionFiscalController::class, 'index'])->name('api.dosificaciones-fiscales.index');
    Route::post('/dosificaciones-fiscales', [DosificacionFiscalController::class, 'store'])->name('api.dosificaciones-fiscales.store');

    // CU32, CU33: Facturas Legales Computarizadas / Electrónicas y Anulaciones
    Route::get('/facturas-legales', [FacturaLegalController::class, 'index'])->name('api.facturas-legales.index');
    Route::post('/facturas-legales', [FacturaLegalController::class, 'store'])->name('api.facturas-legales.store'); // CU32
    Route::post('/facturas-legales/{factura}/anular', [FacturaLegalController::class, 'anular'])->name('api.facturas-legales.anular'); // CU33

    // CU36: Generar Libro de Compras y Ventas IVA Tributario
    Route::get('/libro-iva', [LibroIvaController::class, 'index'])->name('api.libro-iva.index');
    Route::post('/libro-iva/compras', [LibroIvaController::class, 'storeCompra'])->name('api.libro-iva.compras.store');
    Route::get('/libro-iva/exportar-csv', [LibroIvaController::class, 'exportarCsv'])->name('api.libro-iva.exportar-csv');

    // CU37: Exportar Estados Financieros y Rendición de Cuentas Institucional
    Route::get('/rendicion-cuentas', [RendicionCuentasController::class, 'index'])->name('api.rendicion-cuentas.index');
    Route::post('/rendicion-cuentas/emitir', [RendicionCuentasController::class, 'emitirOficial'])->name('api.rendicion-cuentas.emitir');
});
