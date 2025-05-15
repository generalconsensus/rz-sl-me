# --- Stage 1: Base composer setup ---
FROM composer:2 AS base

WORKDIR /app
COPY . .

# --- Stage 2: Development/test build with dev dependencies ---
FROM base AS test

RUN composer install --no-interaction --prefer-dist
RUN cp .env.example .env && \
    php artisan key:generate

# --- Stage 3: Production build with no dev dependencies ---
FROM base AS release

RUN composer install --no-dev --optimize-autoloader


# --- Final runtime image ---
FROM php:8.2-cli

WORKDIR /app

COPY --from=release /app /app

CMD ["php", "artisan"]
