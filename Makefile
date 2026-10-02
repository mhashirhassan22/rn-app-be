.DEFAULT_GOAL := help
IMAGE ?= rn-app-be
VENV  ?= .venv
BIN   := $(VENV)/bin

.PHONY: help install run test lint format docker-build docker-run up down logs clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

$(BIN)/activate: requirements-dev.txt
	python3 -m venv $(VENV)
	$(BIN)/pip install -r requirements-dev.txt
	@touch $(BIN)/activate

install: $(BIN)/activate ## Create venv and install dependencies

run: install ## Run the API locally with reload (http://localhost:8000/docs)
	$(BIN)/uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

test: install ## Run tests
	$(BIN)/pytest

lint: install ## Lint and check formatting
	$(BIN)/ruff check .
	$(BIN)/ruff format --check .

format: install ## Auto-format and fix lint issues
	$(BIN)/ruff check --fix .
	$(BIN)/ruff format .

docker-build: ## Build the production Docker image
	docker build -t $(IMAGE) .

docker-run: docker-build ## Run the production image on port 8000
	docker run --rm -p 8000:8000 --env-file .env $(IMAGE)

up: ## Start the dev stack with docker compose (hot reload)
	docker compose up --build

down: ## Stop the docker compose stack
	docker compose down

logs: ## Tail docker compose logs
	docker compose logs -f

clean: ## Remove venv and caches
	rm -rf $(VENV) .pytest_cache .ruff_cache
	find . -name __pycache__ -type d -prune -exec rm -rf {} +
