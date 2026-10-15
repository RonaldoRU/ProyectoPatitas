
FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    git unzip curl zip \
    libicu-dev libzip-dev libxml2-dev \
    libonig-dev libpng-dev \
    && docker-php-ext-install \
       pdo_mysql mbstring bcmath intl zip gd opcache \
    && for module in /etc/apache2/mods-enabled/mpm_*.load; do \
        [ -e "$module" ] || continue; \
        module_name="${module##*/}"; \
        module_name="${module_name%.load}"; \
        [ "$module_name" = "mpm_prefork" ] || a2dismod "$module_name"; \
    done \
    && a2enmod mpm_prefork rewrite headers \
    && [ "$(find /etc/apache2/mods-enabled -maxdepth 1 -type l -name 'mpm_*.load' | wc -l)" -eq 1 ] \
    && apache2ctl -M 2>&1 | grep -q 'mpm_prefork_module' \
    && apache2ctl -t \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN curl -fsSL https://deb.nodesource.com/setup_24.x -o /tmp/nodesource.sh \
    && bash /tmp/nodesource.sh \
    && apt-get update \
    && apt-get install -y nodejs \
    && rm -f /tmp/nodesource.sh \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN sed -ri \
    -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
    /etc/apache2/sites-available/*.conf \
    /etc/apache2/apache2.conf \
    /etc/apache2/conf-available/*.conf

COPY composer.json composer.lock ./
COPY package.json package-lock.json ./

COPY . .

RUN composer install \
    --no-interaction \
    --prefer-dist \
    --no-dev \
    --optimize-autoloader

RUN npm ci && npm run build

RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R ug+rwX storage bootstrap/cache

EXPOSE 80

CMD ["apache2-foreground"]