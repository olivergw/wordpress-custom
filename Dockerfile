# Custom WordPress image with PhpRedis (pinned) + igbinary
FROM wordpress:php8.4-fpm

# Install build dependencies, then igbinary + PhpRedis 6.0.2
RUN apt-get update && apt-get install -y \
        build-essential \
        libssl-dev \
        pkg-config \
        autoconf \
        g++ \
        make \
    && pecl install igbinary \
    && docker-php-ext-enable igbinary \
    && pecl install redis-6.0.2 \
    && docker-php-ext-enable redis \
    && apt-get remove -y build-essential libssl-dev pkg-config autoconf g++ make \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*