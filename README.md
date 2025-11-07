# WordPress Custom Docker Image

A high-performance WordPress Docker image built on PHP 8.4-FPM with Redis support for object caching.

[![Build and Push to Docker Hub](https://github.com/olivergw/wordpress-custom/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/olivergw/wordpress-custom/actions/workflows/docker-publish.yml)

## 🚀 Features

- **PHP 8.4-FPM** - Latest PHP version for optimal performance
- **PhpRedis 6.3.0+** - High-performance C extension for Redis connectivity
- **igbinary** - Efficient binary serialization for faster cache operations
- **Multi-platform** - Supports both `linux/amd64` and `linux/arm64` architectures
- **Production-ready** - Optimized build with minimal image size

## 📦 Available Images

Pull from Docker Hub:
```bash
docker pull olivergw/wordpress-custom:latest
docker pull olivergw/wordpress-custom:8.4.0
```

### Tags
- `latest` - Latest stable release
- `8.4.0`, `8.4`, `8` - Semantic versioning based on PHP version
- `main` - Latest development build

## 🔧 Usage

### Basic Setup
Replace your WordPress image in `docker-compose.yml`:

```yaml
services:
  wordpress:
    image: olivergw/wordpress-custom:8.4.0
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
```bash
git tag -a v8.5.0 -m "Release version 8.5.0"
git push origin v8.5.0
```

This automatically builds and publishes to Docker Hub with proper semantic versioning.

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
