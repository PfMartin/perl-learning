CONTAINER_NAME ?= perl-dev-box

dev-box-start:
	docker compose up -d

dev-box-enter:
	docker exec -it $(CONTAINER_NAME) /bin/bash
