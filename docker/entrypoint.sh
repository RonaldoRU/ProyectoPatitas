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

# Ejecutar migraciones automáticamente si hay conexión a la base de datos configurada
if [ -n "$DATABASE_URL" ] || [ -n "$DB_HOST" ] || [ -n "$PGHOST" ]; then
    echo ">> Ejecutando migraciones de base de datos..."
    php artisan migrate --force --isolated || echo ">> Aviso: No se pudieron ejecutar migraciones automáticas en este inicio."
fi

# Optimizar caches de Laravel en producción
if [ "${APP_ENV:-production}" = "production" ]; then
    echo ">> Optimizando caches de Laravel..."
    php artisan config:cache || true
    php artisan route:cache || true
    php artisan view:cache || true
fi

# Verificar sintaxis de configuración de Apache
apache2ctl -t || true

echo ">> Iniciando servidor Apache..."
exec apache2-foreground
