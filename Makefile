start:
	#docker-compose up -d proxy
	docker-compose up proxy masterportal geoserver

stop:
	docker-compose down

restart: stop start

install: install_cosi

install_cosi:
	docker-compose run --rm cosi npm install

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
