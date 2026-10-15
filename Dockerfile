
# =========================================================
# ETAPA 1: PHP + APACHE
# =========================================================
FROM php:8.3-apache AS php-base

# Instalar dependencias y extensiones PHP necesarias para Laravel
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        git \
        unzip \
        curl \
        zip \
        libicu-dev \
        libzip-dev \
        libxml2-dev \
        libonig-dev \
        libpng-dev; \
    docker-php-ext-install \
        pdo_mysql \
        mbstring \
        bcmath \
        intl \
        zip \
        gd \
        opcache \
        pcntl; \
    for module in /etc/apache2/mods-enabled/mpm_*.load; do \
        [ -e "$module" ] || continue; \
        module_name="${module##*/}"; \
        module_name="${module_name%.load}"; \
        a2dismod "$module_name" || true; \
    done; \
    a2enmod mpm_prefork rewrite headers; \
    enabled_mpm="$(find /etc/apache2/mods-enabled -maxdepth 1 -type l -name 'mpm_*.load' | wc -l)"; \
    test "$enabled_mpm" -eq 1; \
    apache2ctl -M 2>&1 | grep -q 'mpm_prefork_module'; \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf; \
    apache2ctl -t; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Configurar public como raíz web de Laravel
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN sed -ri \
    -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
    /etc/apache2/sites-available/*.conf \
    /etc/apache2/apache2.conf \
    /etc/apache2/conf-available/*.conf

# Configurar el nombre del servidor sin depender del dominio de Railway
RUN echo "ServerName localhost" \
    > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername \
    && apache2ctl -t


# =========================================================
# ETAPA 2: CONSTRUIR LARAVEL Y REACT
# =========================================================
FROM php-base AS build

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instalar Node.js 24 para compilar React
RUN curl -fsSL https://deb.nodesource.com/setup_24.x -o /tmp/nodesource.sh \
    && bash /tmp/nodesource.sh \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && node --version \
    && npm --version \
    && rm -f /tmp/nodesource.sh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Carpeta de trabajo del proyecto
WORKDIR /var/www/html

# Copiar primero los archivos de dependencias
COPY composer.json composer.lock package.json package-lock.json ./

# Copiar el resto del proyecto Laravel + React
COPY . .

# Instalar dependencias PHP de producción
RUN composer install \
    --no-interaction \
    --prefer-dist \
    --no-dev \
    --optimize-autoloader

# Instalar dependencias de React y compilar los archivos del frontend
RUN npm ci \
    && npm run build \
    && rm -rf node_modules


# =========================================================
# ETAPA 3: IMAGEN FINAL DE PRODUCCIÓN
# =========================================================
FROM php-base AS runtime

WORKDIR /var/www/html

# Copiar la aplicación construida y asignar permisos
COPY --from=build --chown=www-data:www-data /var/www/html /var/www/html

# Preparar directorios que Laravel necesita para funcionar
RUN mkdir -p \
        storage/framework/cache/data \
        storage/framework/sessions \
        storage/framework/views \
        storage/logs \
        bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R ug+rwX storage bootstrap/cache \
    && apache2ctl -t

# Apache escucha en el puerto 80 dentro del contenedor
EXPOSE 80

# Mantener Apache ejecutándose en primer plano
CMD ["apache2-foreground"]
