PROJECT_NAME=laravel12app
APP_CONTAINER=app-php
NGINX_CONTAINER=app-nginx
DB_CONTAINER=app-db

create:
	docker run --rm \
	  -v $(PWD)/..:/var/www \
	  -w /var/www \
	  composer create-project laravel/laravel $(PROJECT_NAME) "^12.0"

# Build and start Docker containers
up:
	docker-compose up -d --build

# Stop all containers
down:
	docker-compose down

# Run Composer install inside PHP container
composer-install:
	docker exec -it $(APP_CONTAINER) composer install

# Run npm install & build via PHP container (assumes Node installed in image)
npm-install:
	docker exec -it $(APP_CONTAINER) npm install
	docker exec -it $(APP_CONTAINER) npm run build

# Laravel setup: .env, key generation, storage permissions
setup:
	docker exec -it $(APP_CONTAINER) cp .env.example .env
	docker exec -it $(APP_CONTAINER) php artisan key:generate
	docker exec -it $(APP_CONTAINER) chmod -R 775 storage bootstrap/cache

# Run Laravel server (via Nginx)
serve:
	open http://localhost

# Run migrations
migrate:
	docker exec -it $(APP_CONTAINER) php artisan migrate

# Fresh DB + seed
fresh:
	docker exec -it $(APP_CONTAINER) php artisan migrate:fresh --seed

# Run tests
test:
	docker exec -it $(APP_CONTAINER) php artisan test

# Clear all caches
clear:
	docker exec -it $(APP_CONTAINER) php artisan optimize:clear

# Start Vite dev server
vite:
	docker exec -it $(APP_CONTAINER) npm run dev

# Artisan CLI passthrough (e.g. `make art cmd="tinker"`)
art:
	docker exec -it $(APP_CONTAINER) php artisan $(cmd)

# Run Bash shell in container
bash:
	docker exec -it $(APP_CONTAINER) bash

.PHONY: up down composer-install npm-install setup serve migrate fresh test clear vite art bash
