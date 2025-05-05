APP_NAME=laravel-app

init:
	@echo "🔧 Creating Laravel project inside '$(APP_NAME)'..."
	docker run --rm -v $(PWD):/app composer create-project laravel/laravel $(APP_NAME)

	@echo "🔐 Fixing file ownership..."
	sudo chown -R $$(id -u):$$(id -g) $(APP_NAME)

	@echo "📂 Moving Laravel project to root..."
	mv $(APP_NAME)/* $(APP_NAME)/.env.example . 2>/dev/null || true
	mv $(APP_NAME)/.* . 2>/dev/null || true
	rm -rf $(APP_NAME)

	@echo "🐳 Building Docker containers..."
	docker compose build

	@echo "🚀 Starting Docker containers..."
	docker compose up -d

	@echo "📦 Installing composer dependencies..."
	docker compose exec php composer install

	@echo "🔑 Generating Laravel application key..."
	docker compose exec php php artisan key:generate

	@echo "✅ Laravel is ready at: http://localhost"

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
