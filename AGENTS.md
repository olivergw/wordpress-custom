# Repository Guidelines

## Project Structure & Module Organization

This repository builds a single custom WordPress container image.

- `Dockerfile` defines the WordPress/PHP base image and installs igbinary and PhpRedis.
- `.github/workflows/docker-publish.yml` builds `linux/amd64` and `linux/arm64` images, derives tags from the `FROM` line, and publishes main-branch builds.
- `.github/dependabot.yml` checks the Docker base and workflow actions weekly.
- `README.md` documents image tags, local usage, Redis configuration, and release steps.

Keep runtime changes in the `Dockerfile`; do not add application themes, plugins, or WordPress source unless the project scope explicitly changes.

## Build, Test, and Development Commands

Build the image locally before submitting changes:

```bash
docker build -t wordpress-custom:dev .
```

Confirm the required PHP extensions are enabled:

```bash
docker run --rm wordpress-custom:dev php -m | grep -E '^(igbinary|redis)$'
```

Inspect the base versions after changing the `FROM` line:

```bash
docker run --rm wordpress-custom:dev php --version
docker run --rm wordpress-custom:dev php -r 'require "/usr/src/wordpress/wp-includes/version.php"; echo $wp_version, PHP_EOL;'
```

GitHub Actions runs the production-equivalent multi-platform build on pull requests and pushes to `main`. Dependabot opens weekly update pull requests from GitHub-hosted infrastructure.

## Coding Style & Naming Conventions

Use uppercase Dockerfile instructions and group related package operations into one `RUN` layer. Indent continued package lists by four spaces, keep one package per line, and preserve cleanup commands so build dependencies and APT metadata do not remain in the image. Use two-space indentation in YAML and descriptive, sentence-style workflow step names. Pin the full WordPress base tag, for example `wordpress:7.1.0-php8.5-fpm`.

## Testing Guidelines

There is no standalone automated test framework or coverage target. A valid change must build successfully and load both `igbinary` and `redis`. For dependency or architecture changes, rely on the pull-request workflow to confirm both supported platforms. Update README examples whenever tags, PHP versions, extensions, or configuration behavior change.

## Commit & Pull Request Guidelines

Recent commits use short, imperative subjects such as `Fix Redis compilation issues` and `Align tag strategy...`. Follow that pattern: state the outcome, keep the subject focused, and avoid conventional-commit prefixes unless adopted repository-wide.

Pull requests should explain the motivation, summarize image or tagging changes, and list local verification performed. Link relevant issues. Include logs or concise command output for build-related fixes; screenshots are only useful for documentation rendering changes.

## Security & Configuration

Never commit Docker Hub credentials, WordPress secrets, database passwords, or Redis credentials. CI expects `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` as GitHub Actions secrets. Use placeholder values in documentation and local examples.
