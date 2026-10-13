<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\BitacoraController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\PostulanteController;
use App\Http\Controllers\UsuarioController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// El bloqueo por intentos fallidos se maneja en AuthController para sincronizar
// el contador visible del botón con el mensaje del servidor.
Route::post('/login', [AuthController::class, 'login'])
    ->name('api.login');

Route::post('/solicitar-codigo', [AuthController::class, 'solicitarCodigo'])
    ->middleware('throttle:5,1')
    ->name('api.password.request');

Route::post('/restablecer-password', [AuthController::class, 'restablecerPassword'])
    ->middleware('throttle:5,1')
    ->name('api.password.reset');

Route::middleware('auth:sanctum')->group(function (): void {
    Route::post('/logout', [AuthController::class, 'logout'])->name('api.logout');

    Route::get('/bitacora', [BitacoraController::class, 'index'])->name('api.bitacora.index');

    Route::get('/usuarios', [UsuarioController::class, 'index'])->name('api.usuarios.index');
    Route::post('/usuarios', [UsuarioController::class, 'store'])->name('api.usuarios.store');
    Route::patch('/usuarios/{usuario}', [UsuarioController::class, 'update'])
        ->name('api.usuarios.update');
    Route::patch('/usuarios/{usuario}/rol', [UsuarioController::class, 'changeRole'])
        ->name('api.usuarios.role');
    Route::patch('/usuarios/{usuario}/estado', [UsuarioController::class, 'setStatus'])
        ->name('api.usuarios.status');

    Route::get('/postulantes', [PostulanteController::class, 'index'])
        ->name('api.postulantes.index');
    Route::post('/postulantes', [PostulanteController::class, 'store'])
        ->name('api.postulantes.store');
    Route::patch('/postulantes/{postulante}', [PostulanteController::class, 'update'])
        ->name('api.postulantes.update');
    Route::post('/postulantes/{postulante}/adopciones', [PostulanteController::class, 'storeAdoption'])
        ->name('api.postulantes.adopciones.store');

    Route::get('/user', function (Request $request) {
        return $request->user()->only(['id', 'nombre', 'email', 'rol']);
    })->name('api.user');

    Route::get('/dashboard', [DashboardController::class, 'getDashboardData'])
        ->name('api.dashboard');
});
