<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Inertia\Middleware;

/**
 * Middleware HandleInertiaRequests: Conecta Laravel con la aplicación frontend en React.
 * Comparte datos globales automáticos (usuario autenticado, nombre de la app, errores de validación)
 * con todos los componentes React renderizados con Inertia.
 */
class HandleInertiaRequests extends Middleware
{
    /**
     * Plantilla base de Blade cargada en la visita inicial (resources/views/app.blade.php).
     *
     * @var string
     */
    protected $rootView = 'app';

    /**
     * Determina la versión de los assets compilados para invalidar caché en despliegues.
     */
    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    /**
     * Define las propiedades compartidas globales disponibles en todas las páginas React:
     * - `name`: Nombre de la aplicación ("Los Angelitos de Edgar").
     * - `auth.user`: Usuario autenticado actual o null si no ha iniciado sesión.
     *
     * @return array<string, mixed>
     */
    public function share(Request $request): array
    {
        return [
            ...parent::share($request),
            'name' => config('app.name'),
            'auth' => [
                'user' => $request->user(),
            ],
        ];
    }
}
