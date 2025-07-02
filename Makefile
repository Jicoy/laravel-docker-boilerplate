APP_CONTAINER=app-php
NGINX_CONTAINER=app-nginx
DB_CONTAINER=app-db

bootstrap:
	@read -p "📦 Enter project name: " PROJECT_NAME; \
	make create PROJECT_NAME=$$PROJECT_NAME && \
	make prepare PROJECT_NAME=$$PROJECT_NAME && \
	make up PROJECT_NAME=$$PROJECT_NAME && \
	make wait && \
	make composer-install && \
	make npm-install && \
	make setup && \
	make migrate

create:
	docker run --rm \
	  -v $(PWD)/..:/var/www \
	  -w /var/www \
	  composer create-project laravel/laravel $(PROJECT_NAME) "^12.0"

prepare:
	cp -r .docker ../$(PROJECT_NAME)/
	cp docker-compose.yml ../$(PROJECT_NAME)/
	cp Makefile ../$(PROJECT_NAME)/Makefile

up:
	cd ../$(PROJECT_NAME) && docker-compose up -d --build

down:
	cd ../$(PROJECT_NAME) && docker-compose down

wait:
	@echo "⏳ Waiting for containers to be ready..."
	@sleep 10

composer-install:
	docker exec -it $(APP_CONTAINER) composer install

npm-install:
	docker exec -it $(APP_CONTAINER) npm install
	docker exec -it $(APP_CONTAINER) npm run build

setup:
	docker exec -it $(APP_CONTAINER) cp .env.example .env
	docker exec -it $(APP_CONTAINER) php artisan key:generate
	docker exec -it $(APP_CONTAINER) chmod -R 775 storage bootstrap/cache

migrate:
	docker exec -it $(APP_CONTAINER) php artisan migrate

vite:
	docker exec -it $(APP_CONTAINER) npm run dev

test:
	docker exec -it $(APP_CONTAINER) php artisan test

clear:
	docker exec -it $(APP_CONTAINER) php artisan optimize:clear

art:
	docker exec -it $(APP_CONTAINER) php artisan $(cmd)

bash:
	docker exec -it $(APP_CONTAINER) bash

.PHONY: bootstrap create prepare up down wait composer-install npm-install setup migrate vite test clear art bash
