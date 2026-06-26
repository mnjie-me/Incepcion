# DEVELOPER DOCUMENTATION - INCEPTION

## Prerequisites

Before starting you need:

- A virtual machine running Debian 12 (Bookworm)
- Docker
- Docker Compose plugin
- Git

You can check with these commands:

```bash
cat /etc/os-release
docker --version
docker compose version
```

---

## Configuration Files

The following files are not stored in git for security reasons.
You must create them manually before building the project.

### 1. srcs/.env

Create the files `srcs/.env` and fill in the following variables:

```bash
#Domain
DOMAIN_NAME=mnjie-me.42.fr

#Database
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=wppassword
MYSQL_ROOT_PASSWORD=rootpassword

#WordPress
WP_TITLE=Inception
WP_ADMIN_USER=wpmaster
WP_ADMIN_PASSWORD=masterpass123
WP_ADMIN_EMAIL=admin@login.42.fr
WP_USER=wpeditor
WP_USER_PASSWORD=editorpass123
WP_USER_EMAIL=editor@login.42.fr
```
This will create the environment inside the container.

### 2. secrets/

Create the following files inside the `secrets/` folder:

```bash
echo "wppassword"            > secrets/db_password.txt
echo "rootpassword"          > secrets/db_root_password.txt
echo "wpmaster:adminpass123" > secrets/credentials.txt
```

This will store sensitive data.

### 3. Local domain

We are going to make sure the domain can resolve locally.

Open the file:

```bash
nano /etc/hosts
```

Add the following:

```bash
127.0.0.1   mnjie-me.42.fr
```

This IP address is a loopback address. It always points to the local machine, meaning any request sent to it never leaves your computer. We use it to simulate a real domain and access services running inside our system.


### 4. Data directories

Create the directories where Dockers will store persistent data:

```bash
mkdir -p /home/mnjie-me/data/wordpress
mkdir -p /home/mnjie-me/data/mariadb
```

---

## Running the project

This will :
- Create the data directories if they do not exist
- Build the Docker images for all three services
- Start the containers in the background

```bash
make
```

To verify all containers are running:

```bash
docker compose -f srcs/docker-compose.yml ps
```

---

## Stopping the project

To stop and remove the containers. All data is preserved in the
volumes and will be available when you run `make` again.

```bash
make down
```

---

## Rebuilding the project

To stop all containers and rebuild everything from scratch.
Use this after making changes to any Dockerfile or configuration file.

```bash
re make
```

---

## Cleaning the project

To stop the containers and deletes all data from the volumes. Including persistent data.

```bash
make clean
```

To fully clean up. Removes containers, volumes and all Docker images built by this project.

```bash
make fclean
```

To perform the full Docker cleanup required before evaluation:

```bash
docker stop $(docker ps -qa)
docker rm $(docker ps -qa)
docker rmi -f $(docker images -qa)
docker volume rm $(docker volume ls -q)
docker network rm $(docker network ls -q) 2>/dev/null
```

---

## Managing containers

### View logs of a specific service

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

## Enter inside a container

```bash
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
```

---

## Data Persistence

The project uses two Docker named volumes:

- **wordpress**: stores all WordPress files (themes, plugins, uploads)
- **mariadb**: stores all database data

Both volumes persist on the host machine at:

/home/mnjie-me/data/wordpress

/home/mnjie-me/data/mariadb

Data survives container stops and restarts. To verify the volumes
exist and point to the correct path:

```bash
docker volume inspect srcs_wordpress
docker volume inspect srcs_mariadb
```