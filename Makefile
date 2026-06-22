LOGIN = mnjie-me

all:
	@mkdir -p /home/$(LOGIN)/data/wordpress
	@mkdir -p /home/$(LOGIN)/data/mariadb
	@docker compose -f srcs/docker-compose.yml up -d --build

down:
	@docker compose -f srcs/docker-compose.yml down

re: down all

clean: down
	@docker system prune -f
	@sudo rm -rf /home/$(LOGIN)/data/wordpress/*
	@sudo rm -rf /home/$(LOGIN)/data/mariadb/*

fclean: clean
	@docker system prune -af
	@docker volume prune -f

.PHONY: all down re clean fclean