SHELL := /bin/bash
COMPOSE_DIR := single-node
CERTS_COMPOSE := generate-indexer-certs.yml
COMPOSE := docker compose

.PHONY: help sysctl certs up down restart logs ps clean status

help:
	@echo "Available targets:"
	@echo "  make sysctl   - Set vm.max_map_count=262144 (required by OpenSearch)"
	@echo "  make certs    - Generate indexer certificates"
	@echo "  make up       - Start the Wazuh stack in detached mode"
	@echo "  make down     - Stop and remove the Wazuh stack"
	@echo "  make restart  - Restart the Wazuh stack"
	@echo "  make logs     - Tail logs from all containers"
	@echo "  make ps       - Show running containers"
	@echo "  make status   - Run sysctl + certs + up in sequence (full bring-up)"
	@echo "  make clean    - Stop stack and remove volumes (DESTRUCTIVE)"

sysctl:
	sudo sysctl -w vm.max_map_count=262144

certs:
	@if [ ! -f $(COMPOSE_DIR)/config/wazuh_indexer_ssl_certs/admin.pem ]; then \
		echo "Removing dummy directories if they exist..."; \
		cd $(COMPOSE_DIR) && $(COMPOSE) -f $(CERTS_COMPOSE) run --rm --entrypoint "sh -c 'rm -rf /certificates/*.pem'" generator; \
		echo "Generating indexer certificates..."; \
		cd $(COMPOSE_DIR) && $(COMPOSE) -f $(CERTS_COMPOSE) run --rm generator; \
	else \
		echo "Indexer certificates already exist. Skipping generation."; \
	fi

up:
	cd $(COMPOSE_DIR) && $(COMPOSE) up -d

down:
	cd $(COMPOSE_DIR) && $(COMPOSE) down

restart: down up

logs:
	cd $(COMPOSE_DIR) && $(COMPOSE) logs -f

ps:
	cd $(COMPOSE_DIR) && $(COMPOSE) ps

clean:
	cd $(COMPOSE_DIR) && $(COMPOSE) down -v

# Full first-time bring-up: sysctl -> certs -> up
status: sysctl certs up
