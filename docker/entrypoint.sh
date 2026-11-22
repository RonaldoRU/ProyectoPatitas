#!/bin/bash
set -e

# Configurar puerto dinámico para Railway o local
PORT="${PORT:-80}"
echo ">> Configurando Apache para escuchar en el puerto: $PORT"

if [ -f /etc/apache2/ports.conf ]; then
    sed -ri "s/Listen [0-9]+/Listen ${PORT}/g" /etc/apache2/ports.conf
fi

for conf in /etc/apache2/sites-available/*.conf /etc/apache2/sites-enabled/*.conf; do
    if [ -f "$conf" ]; then
        sed -ri "s/<VirtualHost \*:[0-9]+>/<VirtualHost \*:${PORT}>/g" "$conf"
    fi
done

# Asegurar permisos de directorios de Laravel
mkdir -p \
    /var/www/html/storage/framework/cache/data \
    /var/www/html/storage/framework/sessions \
    /var/www/html/storage/framework/views \
    /var/www/html/storage/logs \
    /var/www/html/bootstrap/cache

chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R ug+rwX /var/www/html/storage /var/www/html/bootstrap/cache

# Generar APP_KEY si no está definida
if [ -z "$APP_KEY" ]; then
    echo ">> Generando APP_KEY..."
    php artisan key:generate --force || true
fi

# Ejecutar migraciones y carga inicial automáticamente si hay conexión a la base de datos
if [ -n "$DATABASE_URL" ] || [ -n "$DB_HOST" ] || [ -n "$PGHOST" ]; then
    USERS_COUNT=$(php -r 'require "vendor/autoload.php"; $app = require_once "bootstrap/app.php"; $k = $app->make(Illuminate\Contracts\Console\Kernel::class); $k->bootstrap(); try { echo \App\Models\User::count(); } catch (\Throwable $e) { echo -1; }' 2>/dev/null || echo -1)
    DUMP_FILE="/var/www/html/database/basededatosdelawebanimalitos_dump.sql"

    if [ -f "$DUMP_FILE" ] && { [ "$USERS_COUNT" -le 0 ] 2>/dev/null || [ "${FORCE_IMPORT_DUMP:-false}" = "true" ]; }; then
        echo ">> Importando respaldo completo de base de datos ($DUMP_FILE)..."
        if [ -n "$DATABASE_URL" ]; then
            psql "$DATABASE_URL" -v ON_ERROR_STOP=0 -f "$DUMP_FILE" || echo ">> Aviso: Error al importar dump SQL vía DATABASE_URL."
        else
            PGPASSWORD="${PGPASSWORD:-$DB_PASSWORD}" psql \
                -h "${PGHOST:-$DB_HOST}" \
                -p "${PGPORT:-${DB_PORT:-5432}}" \
                -U "${PGUSER:-${DB_USERNAME:-postgres}}" \
                -d "${PGDATABASE:-$DB_DATABASE}" \
                -v ON_ERROR_STOP=0 \
                -f "$DUMP_FILE" || echo ">> Aviso: Error al importar dump SQL vía host."
        fi
    fi

    echo ">> Verificando migraciones pendientes de base de datos..."
    php artisan migrate --force || echo ">> Aviso: No se pudieron ejecutar migraciones automáticas en este inicio."

    # Respaldo: si aún no hay usuarios y no existía dump, ejecutar seeders
    USERS_COUNT=$(php -r 'require "vendor/autoload.php"; $app = require_once "bootstrap/app.php"; $k = $app->make(Illuminate\Contracts\Console\Kernel::class); $k->bootstrap(); try { echo \App\Models\User::count(); } catch (\Throwable $e) { echo -1; }' 2>/dev/null || echo -1)
    if [ "$USERS_COUNT" = "0" ]; then
        echo ">> Base de datos vacía detectada. Ejecutando seeders iniciales..."
        php artisan db:seed --force || echo ">> Aviso: Falló la siembra inicial de datos."
    fi
fi

# Optimizar caches de Laravel en producción
if [ "${APP_ENV:-production}" = "production" ]; then
    echo ">> Optimizando caches de Laravel..."
    php artisan config:cache || true
    php artisan route:cache || true
    php artisan view:cache || true
fi

# Asegurar AllowOverride All para habilitar .htaccess de Laravel
if [ -f /etc/apache2/apache2.conf ]; then
    sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf 2>/dev/null || true
fi

# ==============================================================================
# Prevenir error AH00534: apache2: Configuration error: More than one MPM loaded
# ==============================================================================
echo ">> Verificando módulos MPM de Apache..."
rm -f /etc/apache2/mods-enabled/mpm_event.* /etc/apache2/mods-enabled/mpm_worker.* 2>/dev/null || true
if [ ! -f /etc/apache2/mods-enabled/mpm_prefork.load ]; then
    a2enmod mpm_prefork || true
fi

# Verificar sintaxis de configuración de Apache
apache2ctl -t || true

echo ">> Iniciando servidor Apache..."
exec apache2-foreground
