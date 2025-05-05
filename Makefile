APP_NAME=my-laravel-app
DOCKER_REPO=https://github.com/fglend/laravel-docker-boilerplate.git

init:
        @echo "🎯 Creating new Laravel project in '$(APP_NAME)'..."
        docker run --rm -v $(PWD):/app composer create-project laravel/laravel $(APP_NAME)

        @echo "🔐 Fixing permissions..."
        sudo chown -R $$(id -u):$$(id -g) $(APP_NAME)

        @echo "📦 Cloning Docker boilerplate into temporary folder..."
        git clone $(DOCKER_REPO) tmp-docker

        @echo "📂 Copying Docker files into Laravel project..."
        mv tmp-docker/.docker $(APP_NAME)/
        mv tmp-docker/docker-compose.yml $(APP_NAME)/
        [ -f tmp-docker/Makefile ] && mv tmp-docker/Makefile $(APP_NAME)/ || true

        @echo "🧹 Cleaning up..."
        rm -rf tmp-docker

        @echo "🚀 Laravel project with Docker is ready in '$(APP_NAME)'"
        @echo "👉 cd $(APP_NAME) && docker compose up -d"
