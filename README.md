# Docker WordPress Dev Stack (ARM64 Mac)

## Includes
- Nginx + SSL (OpenSSL)
- PHP 8.2 + Composer + npm
- WordPress CLI
- phpMyAdmin
- MailHog

## Usage
1. Copy `.env.example` to `.env`
2. Make scripts run:
   
   ```bash
   cd scripts
   chmod +x generate-vhost.sh
   chmod +x generate-wordpress.sh
   chmod +x remove-site.sh

3. Generate a vhost:

   ```bash
   ./scripts/generate-vhost.sh site.local

4. Generate wordpress:

   ```bash
   ./scripts/generate-wordpress.sh site.local

5. Remove vhost:

   ```bash
   ./scripts/remove-site.sh site.local
