#!/bin/bash

# 1. Download WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# 2. Config php-fpm to listen on TCP instead of the unix socket
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' \
    /etc/php/7.4/fpm/pool.d/www.conf

# 3. Prepare the web directory
mkdir -p /var/www/html
chmod -R 755 /var/www/html

# 4. Wait until MariaDB is ready
for i in $(seq 1 15); do
    if mariadb -h mariadb -P 3306 \
        -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" \
        -e "SELECT 1" > /dev/null 2>&1; then
        break
    fi
    sleep 3
done

# 5. Install WordPress
cd /var/www/html

wp core download --allow-root

wp config create \
    --dbname="${MYSQL_DATABASE}" \
    --dbuser="${MYSQL_USER}" \
    --dbpass="${MYSQL_PASSWORD}" \
    --dbhost="mariadb:3306" \
    --allow-root

wp core install \
    --url="https://${DOMAIN_NAME}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --allow-root

# 6. Create second user
wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
    --user_pass="${WP_USER_PASSWORD}" \
    --role=author \
    --allow-root

# 7. Grant privileges and run
chown -R www-data:www-data /var/www/html
mkdir -p /run/php

exec /usr/sbin/php-fpm7.4 -F