# To download the docker-compose and .env
install:
	curl https://gitlab.com/mayan-edms/mayan-edms/-/raw/master/docker/docker-compose.yml -O
	curl https://gitlab.com/mayan-edms/mayan-edms/-/raw/master/docker/.env -O

# To check the config
config:
	docker compose --file docker-compose.yml --project-name mayan config

# To start the containers
up:
	docker compose --file docker-compose.yml --project-name mayan up --detach

# To view the logs
logs:
	docker compose --file docker-compose.yml --project-name mayan logs

# To list the containers
ps:
	docker compose --file docker-compose.yml --project-name mayan ps --all
