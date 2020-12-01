FROM php:8.0-fpm

RUN apt-get update && apt-get install -y && rm -r /var/lib/apt/lists/*
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache
RUN pecl install xdebug && docker-php-ext-enable xdebug

ENV PHP_XDEBUG_REMOTE_AUTOSTART="1"
ENV PHP_XDEBUG_REMOTE_ENABLE="1"
ENV PHP_XDEBUG_PROFILER_ENABLE="1"
ENV PHP_XDEBUG_REMOTE_HANDLER="dbgp"
ENV PHP_XDEBUG_REMOTE_HOST="host.docker.internal"
ENV PHP_XDEBUG_REMOTE_PORT="9100"
ENV PHP_XDEBUG_REMOTE_CONNECT_BACK="0"
ENV PHP_XDEBUG_IDE_KEY="phpstorm"

ADD xdebug.ini "$PHP_INI_DIR/conf.d/xdebug.ini"

ENV PHP_IDE_CONFIG="serverName=xdebug-server"

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="1"
ENV PHP_OPCACHE_ENABLE="1"
ADD opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"