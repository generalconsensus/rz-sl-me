

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

