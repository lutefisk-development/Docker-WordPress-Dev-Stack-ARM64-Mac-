#!/bin/bash

DOMAIN=$1
VHOST_DIR="./vhosts/$DOMAIN"
CERTS_DIR="./certs"

if [ -z "$DOMAIN" ]; then
  echo "Usage: $0 domain.local"
  exit 1
fi

mkdir -p "$VHOST_DIR"
mkdir -p "$CERTS_DIR"

# Generate SSL cert
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout "$CERTS_DIR/$DOMAIN.key" \
  -out "$CERTS_DIR/$DOMAIN.crt" \
  -subj "/CN=$DOMAIN"

# Add to /etc/hosts if missing
grep -qxF "127.0.0.1 $DOMAIN" /etc/hosts || echo "127.0.0.1 $DOMAIN" | sudo tee -a /etc/hosts

# Generate nginx vhost config
cat > "./nginx/conf.d/$DOMAIN.conf" <<EOF
server {
    listen 443 ssl;
    server_name $DOMAIN;

    ssl_certificate /etc/nginx/certs/$DOMAIN.crt;
    ssl_certificate_key /etc/nginx/certs/$DOMAIN.key;

    root /var/www/vhosts/$DOMAIN;
    index index.php index.html;

    location ~ \.php\$ {
        include fastcgi_params;
        fastcgi_pass php:9000;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }
}
EOF

echo "✅ Vhost for $DOMAIN created."
