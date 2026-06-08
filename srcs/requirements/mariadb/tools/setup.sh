#!/bin/bash

# 1. Temporarily run MariaDB to set it up
service mariadb start

# 2. Create the data base and user
mariadb -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mariadb -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mariadb -e "FLUSH PRIVILEGES;"

# 3. Temporarily stop MariaDb instance used for configuration
mysqladmin shutdown -u root -p"${MYSQL_ROOT_PASSWORD}"

# 4. Reboot final mode
exec mysqld --bind-address=0.0.0.0 --port=3306