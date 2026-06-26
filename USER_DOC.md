# USER DOCUMENTATION - INCEPTION

## Services Provided

This project runs a WordPress website using three services:

**NGINX:** is the web server. It is the only entry point to the site. All the HTTPS connections are dealt through the port 443.  
**WordPress:** is the website application. It allows you to create and manage content through an administrator panel.  
**MariaDB:** is the database. It stores all the site data: users, posts, pages and settings.

---

## How to start and stop the project

### To start

```bash
make
```

The first time it will take some time as it has to download and install everything.

### Check everything is running correctly

```bash
docker compose -f srcs/docker-compose.yml ps
```

This executes docker compose with the specific configuration file we have created. It will show us the process status of the container. It will say `Up` if they are running.

### To stop

```bash
make down
```

This stops the containers but **it does not delete any data**. If you run `make` again it will be exactly where you left it.

---

## Access the website

### Website

https://mnjie-me.42.fr

A security warning will appear because the SSL certificate is self-signed. Click **Advance** and then **Continue**.

### Administration panel

https://mnjie-me.42.fr/wp-admin

Login with the administrator's credentials (see next section)

---

## Locate and manage credentials

Credentials are stored in the **.env** file and **secrets** folder. They are **not uploaded** to git for security reasons. See **.gitignore** where they are specifically hidden.

### srcs/.env 

Contains all the usernames, passwords and configuration. You need to create the .env file, write the variables and replace the text:

> **DOMAIN_NAME=** *domain name for accesssing the web.*  
> **MYSQL_DATABASE=** *name of the database to be created.*  
> **MYSQL_USER=** *database user name for WordPress connection.*  
> **MYSQL_PASSWORD=** *database  user password for WordPress.*  
> **MYSQL_ROOT_PASSWORD=** *database root password for MariaDB.*  
> **WP_TITLE=** *website name.*  
> **WP_ADMIN_USER=** *WordPress administrator user name.*  
> **WP_ADMIN_PASSWORD=** *WordPress administrator password.*  
> **WP_ADMIN_EMAIL=** *WordPress administrator email.*  
> **WP_USER=** *WordPress regular user.*  
> **WP_USER_PASSWORD=** *WordPress regular user login.*  
> **WP_USER_EMAIL=** *WordPress regular email.*

The administrator's user name can't contain admin/Admin or administrator/Administrator.

### secrets/

Contains the database password as plain text files. You need to create and fill in these files:

> **secrets/db_password.txt** *database user password*.  
> **secrets/db_root_password.txt** *database root password*.  
> **secrets/credentials.txt** *WordPress administrator password*.  

---

## Check that the services are running correctly

### Check the container status

```bash
docker compose -f srcs/docker-compose.yml ps
```

### Check logs of a specific service

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

It shows you exactly what is happening in each container.

### Check the website is accessible

Open https://mnjie-me.42.fr in your browser. You should see the WordPress site, not an error page.

---

## Check the the database is not empty

Write on the terminal:

```bash
docker exec -it mariadb mariadb -u wpuser -p
```

It executes a MariaDB session using the user in interactive mode. 

It will prompt:
```bash
Enter password:
```
Write the MYSQL_PASSWORD you set up earlier in the .env file.

Then you will see:
```sql
MariaDB [(none)]>
```
Run:
```sql
SHOW DATABASES;
USE wordpress;
SHOW TABLES;
```

You should see a table such as:
```sql
wp_posts
wp_users
wp_options
wp_comments
```
If you see this everything is working correctly.