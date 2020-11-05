FROM php:fpm

ENV PHP_INI_DIR=/usr/local/etc/php
ENV LD_LIBRARY_PATH /usr/local/instantclient/
ENV ORACLE_HOME /usr/local/instantclient/
ENV ORACLE_BASE /usr/local/instantclient/
ENV TNS_ADMIN /usr/local/instantclient/

RUN apt-get update && apt-get install -y zip unzip git libpng-dev libzip-dev libpq-dev libaio-dev libc-client-dev libkrb5-dev ${PHPIZE_DEPS} && rm -r /var/lib/apt/lists/* && pecl install -o -f redis && rm -rf /tmp/pear && docker-php-ext-configure mysqli && docker-php-ext-configure pdo_mysql && docker-php-ext-configure imap --with-kerberos --with-imap-ssl && ln -s /usr/lib/libnsl.so.2.0.0  /usr/lib/libnsl.so.1 && docker-php-ext-install pdo pdo_mysql mysqli imap gd zip && docker-php-ext-enable redis && rm -rf /tmp/* /var/lib/apt/lists/* && apt-get remove -y zip ${PHPIZE_DEPS} && docker-php-source delete

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 900M/g' "$PHP_INI_DIR/php.ini"
RUN sed -i 's/post_max_size = 8M/post_max_size = 900M/g' "$PHP_INI_DIR/php.ini"

WORKDIR /code
EXPOSE 9000
CMD php-fpm