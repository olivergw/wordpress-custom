# Custom WordPress image with PhpRedis (pinned) + igbinary
FROM wordpress:php8.5-fpm

# Install build dependencies, then igbinary + PhpRedis
RUN apt-get update && apt-get install -y \
        build-essential \
        libssl-dev \
        pkg-config \
        autoconf \
        g++ \
        make \
        libc6-dev \
        zlib1g-dev \
    && pecl install igbinary \
    && docker-php-ext-enable igbinary \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apt-get remove -y build-essential libssl-dev pkg-config autoconf g++ make libc6-dev zlib1g-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*