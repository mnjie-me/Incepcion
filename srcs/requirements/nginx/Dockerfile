FROM debian:bullseye

RUN apt-get update -y && apt-get install -y nginx openssl

COPY ./tools/setup.sh /setup.sh
RUN chmod +x /setup.sh && /setup.sh

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]