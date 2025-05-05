APP_NAME=laravel-app

init:
	@echo "🔧 Creating Laravel project in current directory..."
	docker run --rm -v $(PWD):/app composer create-project laravel/laravel $(APP_NAME)
	mv $(APP_NAME)/* $(APP_NAME)/.env.example . && rm -rf $(APP_NAME)
	@echo "📦 Building Docker containers..."
	docker compose build
	@echo "🚀 Starting containers..."
	docker compose up -d
	@echo "🎹 Installing composer dependencies..."
	docker compose exec php composer install
	@echo "🔐 Generating app key..."
	docker compose exec php php artisan key:generate
	@echo "✅ Laravel is ready at http://localhost"

bash:
	docker compose exec php bash

npm-install:
	docker compose exec php npm install

npm-build:
	docker compose exec php npm run build

down:
	docker compose down

rebuild:
	docker compose down -v
	docker compose up -d --build

logs:
	docker compose logs -f
