{{--
    Plantilla Principal Blade (app.blade.php):
    Sirve como contenedor inicial para montar la SPA con Inertia.js y React.
    Incluye la familia tipográfica principal Outfit y JetBrains Mono (datos numéricos y códigos),
    además del logotipo oficial del Refugio Angelitos de Edgar.
--}}
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" @class(['dark' => ($appearance ?? 'system') == 'dark'])>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        {{-- Forzar peticiones por HTTPS para evitar contenido mixto en despliegues en la nube --}}
        <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">

        <link rel="icon" type="image/jpeg" href="/images/logo-refugio-angelitos.jpg">
        <link rel="shortcut icon" type="image/jpeg" href="/images/logo-refugio-angelitos.jpg">
        <link rel="apple-touch-icon" href="/images/logo-refugio-angelitos.jpg">

        {{-- Familia Tipográfica Principal: Outfit + Monospaciada JetBrains Mono --}}
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;600;700&family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

        {{-- Directiva para inyección de fuentes locales --}}
        @fonts

        {{-- Inyección de Vite para React y componentes dinámicos de Inertia --}}
        @viteReactRefresh
        @vite(['resources/css/app.css', 'resources/js/app.tsx', "resources/js/pages/{$page['component']}.tsx"])
        <x-inertia::head>
            <title>{{ config('app.name', 'Refugio Angelitos de Edgar') }}</title>
        </x-inertia::head>
    </head>
    <body class="font-sans antialiased">
        {{-- Contenedor donde Inertia renderiza el componente React correspondiente a la ruta actual --}}
        <x-inertia::app />
    </body>
</html>
