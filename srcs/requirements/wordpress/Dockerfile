FROM debian:bullseye

RUN apt-get update -y && apt-get install -y \
    curl \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    mariadb-client

COPY ./tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 9000

ENTRYPOINT ["/setup.sh"]