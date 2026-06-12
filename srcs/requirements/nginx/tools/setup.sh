#!/bin/bash

# 1. Generates a self-signed SSL certificate
mkdir -p /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=ES/ST=Madrid/O=42/OU=42/CN=mnjie-me.42.fr"

# 2. Writes NGINX configuration
cat > /etc/nginx/sites-available/inception << 'EOF'
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name mnjie-me.42.fr;
    root /var/www/html;
    index index.php;

    ssl_certificate     /etc/nginx/ssl/inception.crt;
    ssl_certificate_key /etc/nginx/ssl/inception.key;
    ssl_protocols TLSv1.2 TLSv1.3;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass wordpress:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF

# 3. Activates configuration
ln -sf /etc/nginx/sites-available/inception /etc/nginx/sites-enabled/inception
rm -f /etc/nginx/sites-enabled/default