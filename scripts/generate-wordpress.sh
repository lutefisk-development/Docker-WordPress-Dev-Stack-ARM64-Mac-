#!/bin/bash

DOMAIN=$1
VHOST_DIR="./vhosts/$DOMAIN"

if [ -z "$DOMAIN" ]; then
  echo "Usage: $0 domain.local"
  exit 1
fi

if [ ! -d "$VHOST_DIR" ]; then
  echo "Error: vhost $DOMAIN not found. Run generate-vhost.sh first."
  exit 1
fi

# Download and extract WordPress
curl -o latest.tar.gz https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz -C "$VHOST_DIR" --strip-components=1
rm latest.tar.gz

# Install WordPress via WP-CLI
docker exec php wp core config --path="/var/www/vhosts/$DOMAIN" --dbname=wordpress --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=db
docker exec php wp core install --url="https://$DOMAIN" --title="$DOMAIN Dev Site" --admin_user=admin --admin_password=admin --admin_email=$ADMIN_EMAIL --path="/var/www/vhosts/$DOMAIN"

echo "✅ WordPress installed and configured at $VHOST_DIR"
