#!/bin/bash

# Параметры, которые можно передать через аргументы
DB_HOST="${DB_HOST:-postgre-postgresql.winter-dev.svc.cluster.local}"
DB_PORT="${DB_PORT:-5432}"
DB_DATABASE="${DB_DATABASE:-mywinter}"
DB_USERNAME="${DB_USERNAME:-mywinter}"
DB_PASSWORD="${DB_PASSWORD:-password}"

MAIL_HOST="${MAIL_HOST:-smtp.mailgun.org}"
MAIL_PORT="${MAIL_PORT:-587}"
MAIL_USERNAME="${MAIL_USERNAME:-null}"
MAIL_PASSWORD="${MAIL_PASSWORD:-null}"

# Заполняем файл .env
echo "APP_DEBUG=true" > .env
echo "APP_URL=\"http://localhost\"" >> .env
echo "APP_KEY=" >> .env

echo "DB_CONNECTION=\"pgsql\"" >> .env
echo "DB_HOST=\"$DB_HOST\"" >> .env
echo "DB_PORT=$DB_PORT" >> .env
echo "DB_DATABASE=\"$DB_DATABASE\"" >> .env
echo "DB_USERNAME=\"$DB_USERNAME\"" >> .env
echo "DB_PASSWORD=\"$DB_PASSWORD\"" >> .env

echo "CACHE_DRIVER=\"file\"" >> .env
echo "SESSION_DRIVER=\"file\"" >> .env
echo "QUEUE_CONNECTION=\"sync\"" >> .env

echo "MAIL_MAILER=\"smtp\"" >> .env
echo "MAIL_ENCRYPTION=\"null\"" >> .env
echo "MAIL_HOST=\"$MAIL_HOST\"" >> .env
echo "MAIL_PORT=$MAIL_PORT" >> .env
echo "MAIL_USERNAME=\"$MAIL_USERNAME\"" >> .env
echo "MAIL_PASSWORD=\"$MAIL_PASSWORD\"" >> .env
echo "MAIL_ENCRYPTION=\"null\"" >> .env
echo "MAIL_FROM_ADDRESS=noreply@example.com" >> .env
echo "MAIL_FROM_NAME=\"${APP_NAME}\"" >> .env

echo "ROUTES_CACHE=false" >> .env
echo "ASSET_CACHE=false" >> .env
echo "LINK_POLICY=\"detect\"" >> .env
echo "ENABLE_CSRF=true" >> .env
echo "DATABASE_TEMPLATES=false" >> .env