FROM php:8.2-fpm-alpine

RUN apk add --no-cache \
    bash curl git unzip nginx openssl nodejs npm \
    libzip-dev oniguruma-dev icu-dev autoconf gcc g++ make \
    mariadb-dev \
    msmtp


# Create msmtp config directly at the correct path
RUN apk add --no-cache \
    bash curl git unzip openssl nodejs npm msmtp && \
    ln -sf /usr/bin/msmtp /usr/sbin/sendmail && \
    cat <<EOF > /etc/msmtprc
defaults
account default
host mailhog
port 1025
from wordpress@localhost
logfile /tmp/msmtp.log
tls off
auth off
EOF
RUN chmod 644 /etc/msmtprc && chown root:root /etc/msmtprc

# Install PHP extensions using Docker’s built-in script
RUN docker-php-ext-install pdo_mysql mysqli intl zip opcache

# Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/vhosts

USER www-data
