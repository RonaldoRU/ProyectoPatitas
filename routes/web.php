<?php

use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

// P1: Seguridad y Autenticación
Route::get('/', fn () => Inertia::render('login'))->name('home');
Route::get('/login', fn () => Inertia::render('login'))->name('login');
Route::get('/recuperar-password', fn () => Inertia::render('recuperar-password'))->name('password.recover');

// P2: Administración de Usuarios (RBAC)
Route::get('/usuarios', fn () => Inertia::render('usuarios'))->name('usuarios.index');

// P3: Auditoría y Bitácora
Route::get('/bitacora', fn () => Inertia::render('bitacora'))->name('bitacora.index');

// P4: Catálogo y Existencias
Route::get('/articulos-inventario', fn () => Inertia::render('articulos-inventario'))->name('articulos-inventario.index');

// P5: Abastecimiento y Proveedores
Route::get('/proveedores', fn () => Inertia::render('proveedores'))->name('proveedores.index');
Route::get('/entradas-insumos', fn () => Inertia::render('entradas-insumos'))->name('entradas-insumos.index');
Route::get('/salidas-inventario', fn () => Inertia::render('salidas-inventario'))->name('salidas-inventario.index');

// P6: Automatización Clínica
Route::get('/control-vencimientos', fn () => Inertia::render('control-vencimientos'))->name('control-vencimientos.index');

// P7: Rescate e Historial Clínico
Route::get('/mascotas', fn () => Inertia::render('mascotas'))->name('mascotas.index');
Route::get('/atenciones-clinicas', fn () => Inertia::render('atenciones-clinicas'))->name('atenciones-clinicas.index');

// P8: Adopciones y Seguimiento
Route::get('/postulantes', fn () => Inertia::render('postulantes'))->name('postulantes.index');
Route::get('/adopciones', fn () => Inertia::render('adopciones'))->name('adopciones.index');

// P9: Pasarela de Pagos y Donaciones
Route::get('/donaciones', fn () => Inertia::render('donaciones'))->name('donaciones.index');
Route::get('/pasarela-pagos', fn () => Inertia::render('pasarela-pagos'))->name('pasarela-pagos.index');

// P10: Indicadores Gerenciales
Route::get('/dashboard', fn () => Inertia::render('dashboard'))->name('dashboard');
Route::get('/reportes-gerenciales', fn () => Inertia::render('reportes-gerenciales'))->name('reportes-gerenciales.index');
