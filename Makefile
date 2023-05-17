start: stop cosi_start dipas_start

stop:
	docker-compose down

restart: start

install: cosi_install dipas_install

install_dipas:
	docker-compose run --rm dipas_vue npm install

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

cosi_start: stop
	docker-compose up -d proxy postgis geoserver
	docker-compose run --rm --service-ports masterportal npx serve --listen http://0.0.0.0:3000 ./dist/temp

dipas_install:
	#docker-compose run --rm  masterportal npm install
	#docker-compose run --rm --workdir /home/node/workspace/addons masterportal npm install

dipas_build:
	#docker-compose run --rm masterportal bash -c 'rm -r dist/temp && mkdir dist/temp'
	#docker-compose run --rm masterportal npm run buildPortal
	#docker-compose run --rm masterportal cp -r dist/cosi/. dist/temp
	#docker-compose run --rm masterportal cp -r dist/build/. dist/temp
	#docker-compose run --rm masterportal cp -r dist/mastercode dist/temp

dipas_start: stop
	docker-compose up -d proxy postgis geoserver
	docker-compose run --rm masterportal npx serve ./dist/temp
