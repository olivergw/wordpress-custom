# wordpress-custom

Custom WordPress Docker image built on PHP 8.4-FPM with the PhpRedis extension enabled for high‑performance object caching.  
Optimized for reproducible container workflows and ready to integrate with Redis and MariaDB.

## Features
- Based on official `wordpress:php8.4-fpm`
- PhpRedis extension installed and enabled
- Optional igbinary serializer support
- Compatible with Redis Object Cache plugin

## Usage
Build and run with Docker Compose:

```bash
docker-compose build wordpress
docker-compose up -d
