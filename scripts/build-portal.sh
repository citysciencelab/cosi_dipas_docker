#!/usr/bin/env bash

# Usage:
#        make setup -> scripts/build-portal.sh <PORTAL>
#
#        Chage <Portal> in Makefile accordingly!

# By default, CoSI is used for the build
PORTAL="${1:-cosi}"

# Clone fresh version of masterportal
rm -rf services/masterportal/code
git clone git@github.com:citysciencelab/masterportal.git services/masterportal/code
docker-compose run --rm masterportal npm install

# Clone fresh version of CoSI and link it as addons into masterportal
rm -rf services/cosi/code services/masterportal/code/addons
git clone git@github.com:citysciencelab/cosi.git services/cosi/code
docker-compose run --rm cosi npm install # npm run postinstall
cp -r services/cosi/code/. services/masterportal/code/addons

# Clone fresh version of mpportalconfigs
rm -rf services/masterportal/code/portal services/masterportal/code/portal.tmp
git clone git@github.com:citysciencelab/mpportalconfigs.git services/masterportal/code/portal

 Build Portals and use defined Portal
docker-compose run --rm masterportal npm run buildPortal
mv "services/masterportal/code/portal/$PORTAL" services/masterportal/code/portal.tmp
mv services/masterportal/code/portal.tmp services/masterportal/code/portal

cp -r services/masterportal/code/dist/build/. services/masterportal/code/dist/temp
cp -r services/masterportal/code/dist/mastercode services/masterportal/code/dist/temp
cp -r services/masterportal/code/dist/cosi/. services/masterportal/code/dist/temp
