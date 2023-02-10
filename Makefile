start: stop start_cosi start_dipas

start_cosi: stop
	docker-compose up proxy postgis geoserver masterportal

start_dipas: stop
	docker-compose up proxy postgis geoserver dipas

stop:
	docker-compose down

restart: stop start

install: install_cosi install_dipas

install_cosi:
	docker-compose run --rm cosi npm install

install_dipas:
	docker-compose run --rm dipas_vue npm install

setup:
	bash scripts/build-portal.sh cosi

setup_cosi:
	rm -rf services/cosi/code services/masterportal/code/addons
	git clone git@github.com:citysciencelab/cosi.git services/cosi/code
	docker-compose run --rm cosi npm install
	cp -r services/cosi/code/. services/masterportal/code/addons

setup_dipas:
	rm -rf services/dipas/code
	git clone git@github.com:ubilabs/hcu-unitac-dipas.git services/dipas/code
