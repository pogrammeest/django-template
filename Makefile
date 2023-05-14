DOMAIN ?= domain.com
FRONT_IP_HOST ?= front_ip_host
BACK_IP_HOST ?= back_ip_host
CONFIG = nginx/default.conf

.PHONY: first_deploy
first_deploy: replace_domain replace_front_proxy replace_back_proxy comment_config run_nginx uncomment_config run_docker

replace_domain:
	@echo "Замена домена на $(DOMAIN) в файле $(CONFIG)"
	@sed -i 's|domain\.com|$(DOMAIN)|g' $(CONFIG)

replace_front_proxy:
	@echo "Замена front_ip_host на $(FRONT_IP_HOST) в файле $(CONFIG)"
	@sed -i 's|front_ip_host|$(FRONT_IP_HOST)|g' $(CONFIG)

replace_back_proxy:
	@echo "Замена back_ip_host на $(BACK_IP_HOST) в файле $(CONFIG)"
	@sed -i 's|back_ip_host|$(BACK_IP_HOST)|g' $(CONFIG)

comment_config:
	@echo "Комментирование конфигурационного блока server в файле $(CONFIG)"
	@awk '/# START SECOND SERVER BLOCK/,/# END SECOND SERVER BLOCK/{ if ($$0 !~ /# START SECOND SERVER BLOCK/ && $$0 !~ /# END SECOND SERVER BLOCK/) print "#" $$0; else print $$0; next }1' $(CONFIG) > temp && mv temp $(CONFIG)

run_nginx:
	@echo "Запуск nginx"
	@docker-compose up --build nginx

run_certbot:
	@echo "Запуск certbot"
	@docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot --email mishpzr@yandex.ru --agree-tos -d $(DOMAIN)

uncomment_config:
	@echo "Раскомментирование конфигурационного блока server в файле $(CONFIG)"
	@awk '/# START SECOND SERVER BLOCK/,/# END SECOND SERVER BLOCK/{ gsub(/^#/,""); print; next }1' $(CONFIG) > temp && mv temp $(CONFIG)
	@docker-compose down

run_docker:
	@docker-compose up -d


# Другие команды

run_local:
	@docker-compose up db app

build_local:
	@docker-compose up --build db app rabbit celery


ifneq (,$(wildcard ./.env))
    include .env
    export
else
	ifneq (,$(wildcard ./.dev.env))
		include .dev.env
		export
	endif
endif


enter_shell:
	docker exec -it app_backend sh

py_shell:
	docker exec -it app_backend python3 manage.py shell

makemigrations:
	docker exec -it app_backend python3 manage.py makemigrations

migrate:
	docker exec -it app_backend python3 manage.py migrate

collecstatic:
	docker exec -it app_backend python3 manage.py collectstatic

build:
	docker-compose -f docker-compose.yml up --build

up:
	docker-compose -f docker-compose.yml up -d

down:
	docker-compose -f docker-compose.yml down

db-shell:
	docker exec -it sambooker_db psql ${POSTGRES_DB} -U ${POSTGRES_USER}