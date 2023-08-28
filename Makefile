start: stop cosi_start dipas_start

stop:
	docker-compose down

restart: start

setup:
	bash scripts/build-portal.sh cosi

install: cosi_install dipas_install

pgadmin:
	docker-compose up pgadmin

cosi_install:
	docker-compose run --rm  cosi npm install
	docker-compose run --rm  cosi npx browserslist --update-db
	docker-compose run --rm --workdir /home/node/workspace/addons cosi npm install

cosi_build:
	docker-compose run --rm cosi bash -c 'rm -rf dist/temp && mkdir -p dist/temp'
	docker-compose run --rm cosi npm run buildPortal
	docker-compose run --rm cosi cp -r dist/cosi/. dist/temp
	docker-compose run --rm cosi cp -r dist/build/. dist/temp
	docker-compose run --rm cosi cp -r dist/mastercode dist/temp

cosi_start:
	docker-compose up -d proxy postgis geoserver
	docker-compose run --rm --service-ports cosi npx serve --listen tcp://0.0.0.0:3000 ./dist/temp

dipas_install:
	docker-compose build --pull dipas_backend
	docker-compose run --rm  dipas_backend composer update
	docker-compose run --rm  dipas_backend composer install
	docker-compose run --rm  dipas_frontend npm install

dipas_init:
	docker-compose up -d proxy postgis geoserver
	docker-compose run --rm dipas_backend bash /root/init-drupal.sh 1
	docker-compose run --rm dipas_backend
	docker-compose run --rm dipas_backend bash /root/init-drupal.sh 0

dipas_start:
	docker-compose up -d proxy postgis geoserver
	docker-compose up dipas_frontend dipas_backend
