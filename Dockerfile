# Custom WordPress image with PhpRedis + igbinary
FROM wordpress:7.1.3-php8.5-fpm

# Require the Debian Trixie fix for CVE-2026-111497.
RUN . /etc/os-release \
    && test "$ID" = debian \
    && test "$VERSION_CODENAME" = trixie \
    && apt-get update \
    && apt-get install -y --only-upgrade libbrotli1 \
    && dpkg --compare-versions "$(dpkg-query -W -f='${Version}' libbrotli1)" ge '1.1.0-2+deb13u1' \
    && rm -rf /var/lib/apt/lists/*

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
    && pecl install --configureoptions 'enable-redis-igbinary="yes"' redis \
    && docker-php-ext-enable redis \
    && apt-get remove -y build-essential libssl-dev pkg-config autoconf g++ make libc6-dev zlib1g-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
