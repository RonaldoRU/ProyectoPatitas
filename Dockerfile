# =========================================================
# ETAPA 1: PHP + APACHE CON SOPORTE MYSQL Y POSTGRESQL
# =========================================================
FROM php:8.3-apache AS php-base

# Instalar dependencias del sistema y extensiones PHP (incluyendo PostgreSQL)
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
        libpng-dev \
        libpq-dev; \
    docker-php-ext-install \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
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
    echo "ServerName localhost" >> /etc/apache2/apache2.conf; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Configurar public como raíz web de Laravel
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN sed -ri \
    -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
    /etc/apache2/sites-available/*.conf \
    /etc/apache2/apache2.conf \
    /etc/apache2/conf-available/*.conf \
    && sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

RUN echo "ServerName localhost" \
    > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername


# =========================================================
# ETAPA 2: CONSTRUIR DEPENDENCIAS Y FRONTEND (REACT / VITE)
# =========================================================
FROM php-base AS build

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instalar Node.js 22 LTS para compilar assets de frontend
RUN curl -fsSL https://deb.nodesource.com/setup_22.x -o /tmp/nodesource.sh \
    && bash /tmp/nodesource.sh \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -f /tmp/nodesource.sh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Copiar archivos de dependencias primero para aprovechar cache de Docker
COPY composer.json composer.lock package.json package-lock.json ./

# Instalar dependencias PHP de producción
RUN composer install \
    --no-interaction \
    --prefer-dist \
    --no-dev \
    --no-scripts \
    --optimize-autoloader

# Copiar todo el código fuente
COPY . .

# Ejecutar autoloader y scripts una vez que el código y artisan están presentes
RUN composer dump-autoload --optimize

# Instalar dependencias de frontend y compilar
RUN npm ci \
    && npm run build \
    && rm -rf node_modules


# =========================================================
# ETAPA 3: IMAGEN FINAL DE PRODUCCIÓN
# =========================================================
FROM php-base AS runtime

WORKDIR /var/www/html

# Copiar proyecto compilado
COPY --from=build --chown=www-data:www-data /var/www/html /var/www/html

# Copiar script de arranque
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Directorios de Laravel y permisos
RUN mkdir -p \
        storage/framework/cache/data \
        storage/framework/sessions \
        storage/framework/views \
        storage/logs \
        bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R ug+rwX storage bootstrap/cache

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
