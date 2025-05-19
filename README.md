

## About this project
This project runs a php script that slacks me a reminder to walk my dog

## How to build
- Composer 2 is required to build
- From the root code directory, run

```
composer install --no-interaction --prefer-dist
cp .env.example .env
php artisan key:generate
```

## Running Tests
Once built, run `php artisan test --testdox` to test the application

## IMPORTANT
You must have the environment variable
SLACK_SECRET=

## Running the application
Simply execute `php artisan slack-me`

## Deploying the application
This application can be deployed to any environment that has PHP 8.2 CLI

## IMPORTANT
Please do not include any dev dependencies in the final build

To do this you must run composer install again with these parameters

`composer install --no-dev --optimize-autoloader`


---

## CI/CD and GitHub Actions

This project uses GitHub Actions for automated testing, Docker image creation, and deployment.

### Making Changes to the GitHub CI/CD Pipeline

To make changes to how this application is built or deployed, update the following workflows:

- `.github/workflows/build-test-deploy.yml` – reusable workflow that handles testing and Docker deployment
- `.github/workflows/tag.yml` – workflow that bumps the version and triggers the deploy pipeline

### Environment Variables / Secrets Required

To use GitHub Actions successfully, make sure the following secrets are configured in your GitHub repository under **Settings → Secrets → Actions**:

- `SLACK_SECRET` – The Slack webhook secret used by the app
- `APP_KEY` – Laravel app key (generated via `php artisan key:generate`)
- `DOCKER_USERNAME` – DockerHub username (used for pushing images)
- `DOCKER_PASSWORD` – DockerHub access token or password

> Note: These secrets must also be scoped to the correct GitHub **Environment** (e.g., `prod`, `dev`, `stg`).

### Tag-Based Deployment

When a push to `main` occurs, the `tag.yml` workflow automatically bumps the version (e.g., `v1.2.3`) and triggers the deployment workflow. This deploys a new Docker image tagged with that version and also pushes a `:latest` tag.

To deploy manually:
- Run the `Create new tag` workflow manually under the **Actions** tab, selecting the appropriate environment (e.g., `prod`).

