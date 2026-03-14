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
Tags are derived automatically from the `FROM wordpress:<tag>` line in the Dockerfile. For the current base image `wordpress:php8.5-fpm`:

- `latest` - Latest stable release (main branch)
- `php8.5-fpm` - Full base image tag
- `php8-fpm` - Minor version with variant
- `8.5` - PHP version only
- `8` - PHP major version only

To release a new version, update the `FROM` line in the Dockerfile and push to `main` — tags are generated automatically.

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

Update the `FROM` line in the `Dockerfile` to the desired WordPress base image tag:

```dockerfile
FROM wordpress:php8.5-fpm
```

Then push to `main`. The workflow automatically extracts the tag from the `FROM` line and publishes to Docker Hub with all relevant tags (`php8.5-fpm`, `php8-fpm`, `8.5`, `8`, `latest`). No manual tagging required.

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
