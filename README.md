# WordPress Custom Docker Image

A high-performance WordPress Docker image built on PHP 8.5-FPM with Redis support for object caching.

[![Build and Push to Docker Hub](https://github.com/olivergw/wordpress-custom/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/olivergw/wordpress-custom/actions/workflows/docker-publish.yml)

## 🚀 Features

- **PHP 8.5-FPM** - Latest PHP version for optimal performance
- **PhpRedis 6.3.0+** - High-performance C extension for Redis connectivity
- **igbinary** - Efficient binary serialization for faster cache operations
- **Multi-platform** - Supports both `linux/amd64` and `linux/arm64` architectures
- **Production-ready** - Optimized build with minimal image size

## 📦 Available Images

Pull from Docker Hub:
```bash
docker pull olivergw/wordpress-custom:latest
docker pull olivergw/wordpress-custom:7.1.0-php8.5-fpm
```

### Tags

For the current base image `wordpress:7.1.0-php8.5-fpm`:

| Tag | Example | Triggered when |
|-----|---------|----------------|
| Version from Dockerfile | `7.1.0-php8.5-fpm` (from `wordpress:7.1.0-php8.5-fpm`) | Every push to `main` |
| `latest` | `olivergw/wordpress-custom:latest` | Push to `main` |
| PHP and SAPI | `php8.5-fpm` | Every push to `main` |
| WordPress major | `7-php8.5-fpm` | Every push to `main` |
| WordPress minor | `7.1-php8.5-fpm` | Every push to `main` |

Just update the `FROM` line in the Dockerfile and push to `main`.

### Automated updates

Dependabot checks the official WordPress base image every Monday at 09:00
Europe/London and opens a pull request when a newer compatible tag is available.
It checks GitHub Actions shortly afterwards. Pull requests build both supported
architectures without publishing; merging a successful PR publishes the new
image and aliases from `main`. This process runs on GitHub and does not require
a local machine or Docker daemon.

## 🔧 Usage

### Deployment Configuration

This image supplies WordPress, PHP-FPM, PhpRedis, and igbinary. Site-specific PHP
configuration remains in the consuming deployment. Update its mounted PHP INI
files for upload, memory, execution-time, or OPcache changes.

### Basic Setup
Replace your WordPress image in `docker-compose.yml`:

```yaml
services:
  wordpress:
    image: olivergw/wordpress-custom:7.1.0-php8.5-fpm
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: your_password
      WORDPRESS_DB_NAME: wordpress
      # Redis configuration
      WORDPRESS_CONFIG_EXTRA: |
        define('WP_REDIS_HOST', 'redis');
        define('WP_REDIS_PORT', 6379);
        define('WP_REDIS_DATABASE', 0);
        define('WP_REDIS_IGBINARY', true);
    depends_on:
      - db
      - redis

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes

  db:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: your_password
      MYSQL_ROOT_PASSWORD: root_password
```

### WordPress Redis Object Caching

1. Install the [Redis Object Cache](https://en-gb.wordpress.org/plugins/redis-cache/) plugin
2. Navigate to **Settings → Redis** in WordPress admin
3. Click **Enable Object Cache**

Your WordPress will now use Redis for high-performance object caching!

## 📊 Performance Benefits

- **10-50x faster** cache operations compared to pure PHP Redis clients
- **~30% smaller** cache entries with igbinary serialization
- **Reduced database queries** and improved page load times
- **Better scalability** under high traffic loads

## 🛠 Development

### Building Locally
```bash
git clone https://github.com/olivergw/wordpress-custom.git
cd wordpress-custom
docker build -t wordpress-custom .
```

### Creating New Releases

Dependabot normally opens the base-image update pull request automatically. For
a manual release, change the `FROM` line in the Dockerfile and open a pull
request. The workflow publishes the complete WordPress base tag, `latest`, and
aliases for the PHP/SAPI and WordPress major and minor versions after merge. For
`wordpress:7.1.0-php8.5-fpm`, these are `php8.5-fpm`, `7-php8.5-fpm`, and
`7.1-php8.5-fpm`.

## 📋 What's Included

### Extensions
- **PhpRedis** - Fast C-based Redis client
- **igbinary** - Binary serialization for performance

### Build Dependencies (Removed After Build)
- build-essential
- autoconf, g++, make
- libssl-dev, pkg-config
- libc6-dev, zlib1g-dev

## 🔍 Verification

Check that extensions are loaded:
```bash
docker exec <container> php -m | grep -E "redis|igbinary"
docker exec <container> php -r 'exit(defined("Redis::SERIALIZER_IGBINARY") ? 0 : 1);'
```

Expected output:
```
igbinary
redis
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the build locally
5. Submit a pull request

## 📄 License

This repository's original Dockerfile, workflow, and documentation are licensed
under the [MIT License](LICENSE). WordPress and software included in the resulting
image retain their respective upstream licenses.

---

**Ready for production WordPress deployments with Redis caching! 🚀**
