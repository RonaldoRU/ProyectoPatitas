<?php

use App\Http\Controllers\AdopcionController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', fn () => Inertia::render('login'))->name('home');
Route::get('/login', fn () => Inertia::render('login'))->name('login');
Route::get('/dashboard', fn () => Inertia::render('dashboard'))->name('dashboard');
Route::get('/usuarios', fn () => Inertia::render('usuarios'))->name('usuarios.index');
Route::get('/bitacora', fn () => Inertia::render('bitacora'))->name('bitacora.index');
Route::get('/postulantes', fn () => Inertia::render('postulantes'))->name('postulantes.index');
Route::get('/recuperar-password', fn () => Inertia::render('recuperar-password'))
    ->name('password.recover');

Route::prefix('adopciones')->controller(AdopcionController::class)->group(function () {
    Route::get('/', 'index')->name('adopciones.index');
    Route::get('/create', 'create')->name('adopciones.create');
    Route::post('/', 'store')->name('adopciones.store');
    Route::get('/{adopcion}', 'show')->name('adopciones.show');
    Route::get('/{adopcion}/edit', 'edit')->name('adopciones.edit');
    Route::put('/{adopcion}', 'update')->name('adopciones.update');
    Route::delete('/{adopcion}', 'destroy')->name('adopciones.destroy');
});
