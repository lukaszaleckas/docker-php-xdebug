FROM php:5.6-fpm
RUN apt-get update && apt-get install -y \
    libz-dev \
    libmemcached-dev \
    libmcrypt-dev \
    && pecl install redis-2.2.8 \
    && docker-php-ext-enable redis

RUN curl https://phar.phpunit.de/phpunit-5.7.phar -L -o phpunit.phar \
    && chmod +x phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit

RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++
RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo pdo_mysql mbstring bcmath mcrypt sockets calendar intl
RUN pecl install xdebug-2.5.5 && docker-php-ext-enable xdebug

# https://serversforhackers.com/c/getting-xdebug-working
# for macs remote_host must be host machine private ip
# use ipconfig getifaddr en1
# use ipconfig getifaddr en0

RUN echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.profiler_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9100" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=phpstorm" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

ENV PHP_IDE_CONFIG="serverName=xdebug-server"
