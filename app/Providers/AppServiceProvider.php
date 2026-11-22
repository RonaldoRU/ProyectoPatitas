<?php

namespace App\Providers;

use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\Date;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;
use Illuminate\Validation\Rules\Password;

/**
 * Proveedor de Servicios Principal (AppServiceProvider):
 * Configura comportamientos globales del framework:
 * - Forzar HTTPS en producción / tras balanceadores o proxies (Railway).
 * - Uso de fechas inmutables con CarbonImmutable.
 * - Prohibición de comandos destructivos de base de datos en producción.
 * - Políticas de contraseñas seguras según el entorno.
 */
class AppServiceProvider extends ServiceProvider
{
    /**
     * Registra servicios y dependencias en el contenedor de inversión de control (IoC).
     */
    public function register(): void
    {
        //
    }

    /**
     * Inicializa configuraciones globales al arrancar la aplicación.
     */
    public function boot(): void
    {
        // Forzar HTTPS en producción o si la cabecera X-Forwarded-Proto indica HTTPS
        if (app()->isProduction() || request()->header('X-Forwarded-Proto') === 'https' || str_starts_with((string) config('app.url'), 'https://')) {
            URL::forceScheme('https');
        }

        $this->configureDefaults();
    }

    /**
     * Configuración de comportamientos estándar de seguridad y consistencia de datos.
     */
    protected function configureDefaults(): void
    {
        Date::use(CarbonImmutable::class);

        DB::prohibitDestructiveCommands(
            app()->isProduction(),
        );

        Password::defaults(fn (): ?Password => app()->isProduction()
            ? Password::min(12)
                ->mixedCase()
                ->letters()
                ->numbers()
                ->symbols()
                ->uncompromised()
            : null,
        );
    }
}
