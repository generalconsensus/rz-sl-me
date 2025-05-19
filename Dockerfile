# -----------------------------------------------------------------------------
# Dockerfile for Slack-Me Laravel CLI Application
# Author: Dan McDermott
#
# Multi-stage build with:
#   1. base:      Shared code and dependency staging
#   2. test:      Includes dev dependencies for testing (phpunit)
#   3. release:   Optimized for production with no dev dependencies
#   4. final:     Slim runtime container (php:8.2-cli)
#
# Notes:
#   - Secrets such as SLACK_SECRET and APP_KEY are NOT baked in.
#   - All environment-specific values are passed at runtime.
#   - This ensures portability and avoids leaking secrets in image layers.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Stage 1: Base composer setup
# Installs project files for downstream test + release stages
# -----------------------------------------------------------------------------
FROM composer:2 AS base

WORKDIR /app
COPY . .

# -----------------------------------------------------------------------------
# Stage 2: Dev/test build
# Installs *with dev dependencies* for use in tests (phpunit, etc)
# .env.example is copied only to satisfy Laravel's bootstrapping logic.
# APP_KEY is NOT generated or baked in — it is injected at runtime.
# -----------------------------------------------------------------------------
FROM base AS test

RUN composer install --no-interaction --prefer-dist \
 && cp .env.example .env

# -----------------------------------------------------------------------------
# Stage 3: Production build
# Installs *without* dev dependencies; optimized for runtime
# Again, APP_KEY is NOT generated — it must be passed in at runtime.
# -----------------------------------------------------------------------------
FROM base AS release

RUN composer install --no-dev --optimize-autoloader \
 && cp .env.example .env

# -----------------------------------------------------------------------------
# Final Runtime Image
# Based on official PHP 8.2 CLI image
# Contains only the optimized, production-ready app
# -----------------------------------------------------------------------------
FROM php:8.2-cli as final

WORKDIR /app

# Copy built app from release stage
COPY --from=release /app /app

# Entrypoint: runs Laravel CLI (artisan)
CMD ["php", "artisan", "slack-me"]
