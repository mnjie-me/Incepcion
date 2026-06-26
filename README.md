*This project has been created as part of the 42 curriculum by mnjie-me.*

# Inception

## Description

This project consists of setting up a small web infrastructure using Docker and
Docker Compose inside a virtual machine. The goal is to understand how to
containerize services, manage their communication and ensure data persistence.

The infrastructure is composed of three services, each running in its own
dedicated container built from a custom Dockerfile:

- **NGINX** — the only entry point to the infrastructure, serving HTTPS on port 443
  using TLSv1.2 or TLSv1.3.
- **WordPress + php-fpm** — the web application, communicating with NGINX via
  FastCGI on port 9000.
- **MariaDB** — the database, storing all WordPress data.

### Virtual Machines vs Docker

A virtual machine emulates a complete computer including its own kernel and
hardware. It is heavy, takes minutes to start and consumes several GB of disk.
Docker containers share the host kernel and only contain what the application
needs. They are lightweight, start in seconds and consume far less resources.
The trade-off is that containers provide less isolation than VMs.

### Secrets vs Environment Variables

Environment variables are convenient but can be exposed through `docker inspect`
or application logs. Docker secrets are mounted as files inside the container
and are not visible in the environment, making them a safer option for storing
sensitive information like passwords and API keys.

### Docker Network vs Host Network

With a Docker bridge network, containers communicate with each other using their
service name as hostname (e.g. `wordpress` can reach `mariadb` directly).
They are isolated from the host network and from the outside world unless a port
is explicitly exposed. With `network: host` the container shares the host network
interface directly, removing isolation. This project uses a bridge network and
forbids `network: host`.

### Docker Volumes vs Bind Mounts

A bind mount maps a specific directory from the host into the container. It is
simple but tightly coupled to the host filesystem structure. A Docker named
volume is managed by Docker itself, is more portable and is the recommended
approach for persistent data. This project uses named volumes to store WordPress
files and the MariaDB database, as bind mounts are explicitly forbidden by the
subject.

---

## Instructions

### Requirements

- A virtual machine running Debian 11 or Debian 12
- Docker and Docker Compose plugin installed
- Git

### Setup

Clone the repository:

```bash
git clone <your-repo-url>
cd inception
```

Create the `srcs/.env` file and the `secrets/` files with your credentials.
See `DEV_DOC.md` for the full setup instructions.

Add your domain to `/etc/hosts`:

127.0.0.1   mnjie-me.42.fr

### Run

```bash
make
```

Open `https://mnjie-me.42.fr` in your browser.

### Stop

```bash
make down
```

---

## Resources

### Documentation

- [Docker official documentation](https://docs.docker.com)
- [Docker Compose documentation](https://docs.docker.com/compose)
- [NGINX documentation](https://nginx.org/en/docs)
- [WordPress CLI (WP-CLI)](https://wp-cli.org)
- [MariaDB documentation](https://mariadb.com/kb/en)
- [OpenSSL documentation](https://www.openssl.org/docs)
- [PHP-FPM documentation](https://www.php.net/manual/en/install.fpm.php)

### AI Usage

AI was used during this project for the following tasks:

- Generating the structure and content of the documentation files
  (README.md, USER_DOC.md, DEV_DOC.md)
- Helping debug configuration issues in the Dockerfile scripts
- Explaining concepts such as PID 1, FastCGI and Docker networking
- Reviewing shell scripts for correctness

All AI-generated content was reviewed, tested and adapted to fit the
specific requirements of this project.