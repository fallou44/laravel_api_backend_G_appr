#!/bin/sh

# Teste la configuration Nginx
nginx -t

# Si la configuration est correcte, démarre Nginx
if [ $? -eq 0 ]; then
    echo "Nginx configuration is OK. Starting Nginx..."
    service nginx start
else
    echo "Nginx configuration failed."
    exit 1
fi

# Démarre PHP-FPM
echo "Starting PHP-FPM..."
php-fpm
