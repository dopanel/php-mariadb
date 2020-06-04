FROM php:fpm

ENV PHP_INI_DIR=/usr/local/etc/php

RUN apt-get update
RUN apt-get install -y zip unzip git libpq-dev libaio-dev libc-client-dev libkrb5-dev ${PHPIZE_DEPS}
RUN docker-php-ext-configure mysqli
RUN docker-php-ext-configure pdo_mysql
#RUN docker-php-ext-configure pdo
RUN docker-php-ext-configure mysqli
RUN docker-php-ext-configure pdo_mysql
#RUN docker-php-ext-configure pdo
RUN docker-php-ext-install pdo pdo_mysql mysqli
#docker-php-ext-enable redis
RUN rm -rf /tmp/* /var/lib/apt/lists/*
RUN apt-get remove -y zip ${PHPIZE_DEPS}

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 900M/g' "$PHP_INI_DIR/php.ini"
RUN sed -i 's/post_max_size = 8M/post_max_size = 900M/g' "$PHP_INI_DIR/php.ini"

WORKDIR /code
EXPOSE 9000
CMD php-fpm

# check: php -m | grep 'oci8'
