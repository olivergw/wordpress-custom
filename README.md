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
docker pull olivergw/wordpress-custom:php8.5-fpm
```

### Tags

For the current base image `wordpress:7.0.0-php8.5-fpm`:

| Tag | Example | Triggered when |
|-----|---------|----------------|
| Version from Dockerfile | `7.0.0-php8.5` (from `wordpress:7.0.0-php8.5-fpm`) | Every push to `main` |
| `latest` | `olivergw/wordpress-custom:latest` | Push to `main` |
| Commit SHA | Short + long SHA | Every push |

Just update the `FROM` line in the Dockerfile and push to `main`.

## 🔧 Usage

### Basic Setup
Replace your WordPress image in `docker-compose.yml`:

```yaml
services:
  wordpress:
    image: olivergw/wordpress-custom:php8.5-fpm
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

To update the base image, change the `FROM` line in the Dockerfile and push to `main`. The workflow extracts the WordPress version (e.g. `7.0.0`) and PHP minor version (e.g. `php8.5`) automatically — producing tags like `7.0.0-php8.5`, `latest`, plus short + long SHA.

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

This project builds upon the official WordPress Docker image and follows the same licensing terms.

---

**Ready for production WordPress deployments with Redis caching! 🚀**
