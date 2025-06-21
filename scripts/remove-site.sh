#!/bin/bash

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
  echo "Usage: $0 domain.local"
  exit 1
fi

rm -rf "./vhosts/$DOMAIN"
rm -f "./certs/$DOMAIN.crt" "./certs/$DOMAIN.key"
rm -f "./nginx/conf.d/$DOMAIN.conf"

# Remove from /etc/hosts
sudo sed -i '' "/127.0.0.1 $DOMAIN/d" /etc/hosts

echo "🗑️ Removed site $DOMAIN"
