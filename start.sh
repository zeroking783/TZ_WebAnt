#!/bin/bash
set -e

# Ожидание PostgreSQL (до 30 секунд)
echo "⏳ Waiting for database to be ready..."
until nc -z -v -w30 $DB_HOST 5432; do
  sleep 5
done
echo "✅ Database is ready!"

# Выполняем миграции (если БД доступна)
php artisan migrate 
php artisan winter:up
php artisan winter:passwd admin admin

# Запускаем основной процесс (PHP-FPM)
exec php-fpm
