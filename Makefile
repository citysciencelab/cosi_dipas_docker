start: stop start_cosi start_dipas

start_cosi: stop
	docker-compose up proxy postgis geoserver masterportal

start_dipas: stop
	docker-compose up proxy postgis geoserver dipas

stop:
	docker-compose down

restart: stop start

install: install_cosi

install_cosi:
	docker-compose run --rm cosi npm install

setup:
	bash scripts/build-portal.sh cosi

cosi_install:
	docker-compose run --rm  masterportal npm install
	docker-compose run --rm --workdir /home/node/workspace/addons masterportal npm install

cosi_build:
	docker-compose run --rm masterportal bash -c 'rm -r dist/temp && mkdir dist/temp'
	docker-compose run --rm masterportal npm run buildPortal
	docker-compose run --rm masterportal cp -r dist/cosi/. dist/temp
	docker-compose run --rm masterportal cp -r dist/build/. dist/temp
	docker-compose run --rm masterportal cp -r dist/mastercode dist/temp
