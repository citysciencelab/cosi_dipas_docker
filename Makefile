start:
	docker-compose up

stop:
	docker-compose down

restart: stop start

install: install_cosi

install_cosi:
	docker-compose run --rm cosi npm install
