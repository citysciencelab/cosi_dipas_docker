#!/usr/bin/env bash

# Usage:
#        make setup -> scripts/build-portal.sh <PORTAL>
#
#        Chage <Portal> in Makefile accordingly!

# By default, CoSI is used for the build
PORTAL="${1:-cosi}"

# Clone fresh version of masterportal
rm -r services/masterportal/code
git clone git@github.com:citysciencelab/masterportal.git services/masterportal/code
docker-compose run --rm masterportal npm install

# Clone fresh version of CoSI and link it as addons into masterportal
rm -r services/cosi/code
git clone git@github.com:citysciencelab/cosi.git services/cosi/code
docker-compose run --rm cosi npm install # npm run postinstall
ln -s services/cosi/code services/masterportal/addons

# Clone fresh version of mpportalconfigs
rm -r services/masterportal/portal services/masterportal/portal.tmp
git clone git@github.com:citysciencelab/mpportalconfigs.git services/masterportal/portal

# Build Portals and use defined Portal
docker-compose run --rm masterportal npm run buildPortal
mv "services/masterportal/portals/$PORTAL" services/masterportal/portal.tmp
mv services/masterportal/portal.tmp services/masterportal/portal

#docker-compose run --rm masterportal python -m http.server 3000

# # mv files to webspace
# # or reference by symlink
# # uncomment and edit if you want to move the files
# sudo mv ./dist/build /var/www/cosi-qs/
# sudo mv ./dist/mastercode /var/www/cosi-qs/
# sudo mv ./dist/cosi /var/www/cosi-qs/

# Nginx config vhost links to /var/www/cosi-qs/index.html

# echo "successfully deployed"
