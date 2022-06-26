FROM php:8.1-fpm

LABEL maintainer="Bilal Khalid"

RUN apt-get update && apt-get install -y \
   build-essential apt-utils libfreetype6-dev libjpeg62-turbo-dev \
   libmemcached-dev libmcrypt-dev libpng-dev libxml2-dev libzip-dev \
   libz-dev locales jpegoptim optipng pngquant gifsicle zip unzip \
   git curl \
   && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pecl install memcached && \
   docker-php-source extract && \
   docker-php-ext-enable memcached && \
   docker-php-ext-install pdo_mysql zip exif pcntl bcmath && \
   docker-php-ext-configure gd && \
   docker-php-ext-install -j$(nproc) gd && \
   docker-php-source delete

COPY www.conf /usr/local/etc/php-fpm.d/zz-www.conf

RUN chmod 644 /usr/local/etc/php-fpm.d/zz-www.conf

WORKDIR /var/www/html

EXPOSE 9000

CMD ["php-fpm"]