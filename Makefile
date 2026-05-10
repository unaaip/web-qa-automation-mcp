.PHONY: install run dev test lint docker-up docker-build clean

install:
	python -m pip install -r requirements.txt
	python -m pip install -e .
	playwright install --with-deps chromium

run:
	python -m web_qa_mcp_agent.server

dev:
	FAST_MCP_LOG_LEVEL=DEBUG python -m web_qa_mcp_agent.server

test:
	pytest -v

lint:
	ruff check src tests

docker-build:
	docker compose build --no-cache

docker-up:
	docker compose up --build

clean:
	rm -rf .pytest_cache .ruff_cache reports/*.html reports/*.json reports/*.md reports/*.png
