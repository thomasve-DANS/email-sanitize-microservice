# Django and Docker commands
include .env

.PHONY = help
.DEFAULT:
	@echo "Usage: "
	@make help

help: ## Show this help.
	# From https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
build: ## Build and start project.
	@docker-compose up --build
start: ## Start project running in a non-detached mode.
	@docker-compose up
startbg: ## Start project running in detached mode - background.
	@docker-compose up -d
stop: ## Stop the running project.
	@docker-compose stop
test:
	@docker exec -it ${CONTAINER_NAME} pytest
copy-poetry-files: ## Copies poetry files inside container
	@docker cp ./pyproject.toml ${PROJECT_CONTAINER_NAME}:/pyproject.toml
	@docker exec -it ${CONTAINER_NAME} poetry update
export-poetry-files: ## Exports poetry files from inside container
	@docker cp ${CONTAINER_NAME}:/pyproject.toml ./backend/pyproject.toml
	@docker cp ${CONTAINER_NAME}:/poetry.lock ./backend/poetry.lock
update-requirements: copy-poetry-files
	@docker exec -it ${CONTAINER_NAME} poetry update ${package_name}
	make export-poetry-files ## Export requirements and lock file
add-poetry-package: copy-poetry-files ## Adds a poetry package, using backend container to resolve. Expects: package_name arg. Ex: make add-poetry-package package_name="foo"
	@docker exec -it ${CONTAINER_NAME} poetry add ${package_name}
	make export-poetry-files
remove-poetry-package: copy-poetry-files ## Removes a poetry package. Similar to adding.
	@docker exec -it ${CONTAINER_NAME} poetry remove ${package_name}
	make export-poetry-files
shell-be: ## Enter system shell in backend container
	@docker-compose exec ${CONTAINER_NAME} sh
python-shell-be: ## Enter into IPython shell in backend container
	@docker-compose exec ${CONTAINER_NAME} python -m IPython
