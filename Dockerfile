# Utilise l'image officielle PHP 8.2 avec FPM
FROM php:8.2-fpm

# Installations de dépendances système
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpq-dev \
    libzip-dev \
    zip \
    nginx \
    postgresql-client \
    libgd-dev \
    && docker-php-ext-install pdo pdo_pgsql zip gd \
    && pecl install grpc \
    && docker-php-ext-enable grpc

# Configurer Nginx
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Installe Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crée un répertoire pour l'application
WORKDIR /var/www/html

# Copie les fichiers dans le conteneur
COPY . .

# Installe les dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Permissions pour le stockage et le cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copie le script de démarrage
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose le port 80 pour Nginx et le port 9000 pour PHP-FPM
EXPOSE 80
EXPOSE 9000

# Lancer le script de démarrage quand le conteneur démarre
CMD ["sh", "/usr/local/bin/start.sh"]
