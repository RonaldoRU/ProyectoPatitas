<?php

use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

/*
|--------------------------------------------------------------------------
| Web Routes - Arquitectura Consolidada en 5 Macro-Paquetes
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
// PAQUETE 1: SEGURIDAD, USUARIOS Y AUDITORÍA FORENSE
// =========================================================================
Route::get('/', fn () => Inertia::render('P01_SeguridadUsuariosAuditoria/login'))->name('home');
Route::get('/login', fn () => Inertia::render('P01_SeguridadUsuariosAuditoria/login'))->name('login');
Route::get('/recuperar-password', fn () => Inertia::render('P01_SeguridadUsuariosAuditoria/recuperar-password'))->name('password.recover');
Route::get('/usuarios', fn () => Inertia::render('P01_SeguridadUsuariosAuditoria/usuarios'))->name('usuarios.index');
Route::get('/bitacora', fn () => Inertia::render('P01_SeguridadUsuariosAuditoria/bitacora'))->name('bitacora.index');
Route::get('/auditoria-forense', fn () => Inertia::render('P01_SeguridadUsuariosAuditoria/auditoria-forense'))->name('auditoria-forense.index');

// =========================================================================
// PAQUETE 2: LOGÍSTICA DE INVENTARIO, DESPENSA Y PROVEEDORES
// =========================================================================
Route::get('/articulos-inventario', fn () => Inertia::render('P02_LogisticaInventario/articulos-inventario'))->name('articulos-inventario.index');
Route::get('/entradas-insumos', fn () => Inertia::render('P02_LogisticaInventario/entradas-insumos'))->name('entradas-insumos.index');
Route::get('/salidas-inventario', fn () => Inertia::render('P02_LogisticaInventario/salidas-inventario'))->name('salidas-inventario.index');
Route::get('/proveedores', fn () => Inertia::render('P02_LogisticaInventario/proveedores'))->name('proveedores.index');
Route::get('/control-vencimientos', fn () => Inertia::render('P02_LogisticaInventario/control-vencimientos'))->name('control-vencimientos.index');

// =========================================================================
// PAQUETE 3: GESTIÓN DE RESCATES, CLÍNICA VETERINARIA Y ADOPCIONES
// =========================================================================
Route::get('/mascotas', fn () => Inertia::render('P03_RescateClinicaAdopciones/mascotas'))->name('mascotas.index');
Route::get('/atenciones-clinicas', fn () => Inertia::render('P03_RescateClinicaAdopciones/atenciones-clinicas'))->name('atenciones-clinicas.index');
Route::get('/dosificacion-clinica', fn () => Inertia::render('P03_RescateClinicaAdopciones/dosificacion-clinica'))->name('dosificacion-clinica.index');
Route::get('/postulantes', fn () => Inertia::render('P03_RescateClinicaAdopciones/postulantes'))->name('postulantes.index');
Route::get('/adopciones', fn () => Inertia::render('P03_RescateClinicaAdopciones/adopciones'))->name('adopciones.index');

// =========================================================================
// PAQUETE 4: DONACIONES MONETARIAS Y PASARELA DE PAGOS
// =========================================================================
Route::get('/donaciones', fn () => Inertia::render('P04_DonacionesPasarela/donaciones'))->name('donaciones.index');
Route::get('/pasarela-pagos', fn () => Inertia::render('P04_DonacionesPasarela/pasarela-pagos'))->name('pasarela-pagos.index');

// =========================================================================
// PAQUETE 5: FACTURACIÓN LEGAL (SIN), TRIBUTACIÓN Y REPORTES GERENCIALES
// =========================================================================
Route::get('/dashboard', fn () => Inertia::render('P05_FacturacionReportes/dashboard'))->name('dashboard');
Route::get('/reportes-gerenciales', fn () => Inertia::render('P05_FacturacionReportes/reportes-gerenciales'))->name('reportes-gerenciales.index');
Route::get('/dosificaciones-fiscales', fn () => Inertia::render('P05_FacturacionReportes/dosificaciones'))->name('dosificaciones-fiscales.index');
Route::get('/facturas-legales', fn () => Inertia::render('P05_FacturacionReportes/facturas-legales'))->name('facturas-legales.index');
Route::get('/libro-iva', fn () => Inertia::render('P05_FacturacionReportes/libro-iva'))->name('libro-iva.index');
Route::get('/rendicion-cuentas', fn () => Inertia::render('P05_FacturacionReportes/rendicion-cuentas'))->name('rendicion-cuentas.index');
