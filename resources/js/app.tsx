/**
 * Punto de Entrada Principal de React con Inertia.js (app.tsx):
 * - Inicializa la aplicación Inertia del lado del cliente.
 * - Resuelve dinámicamente las páginas ubicadas en `resources/js/pages/`.
 * - Configura la barra de progreso de carga de navegación.
 */
import { createInertiaApp } from '@inertiajs/react';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import { createRoot } from 'react-dom/client';
import MenuHamburguesa from './components/MenuHamburguesa';
import '../css/app.css';

// Nombre de la aplicación obtenido de las variables de entorno de Vite
const appName = import.meta.env.VITE_APP_NAME || 'Los Angelitos de Edgar';

createInertiaApp({
    // Formato del título de pestaña del navegador
    title: (title) => (title ? `${title} - ${appName}` : appName),

    // Carga perezosa (lazy-loading) del componente de página correspondiente
    resolve: (name) =>
        resolvePageComponent<any>(
            `./pages/${name}.tsx`,
            import.meta.glob('./pages/**/*.tsx'),
        ),

    // Monta la aplicación React en el elemento raíz del DOM
    setup({ el, App, props }) {
        createRoot(el).render(<App {...props} />);
    },

    // Configuración estética de la barra de progreso de navegación
    progress: {
        color: '#4B5563',
    },
});
