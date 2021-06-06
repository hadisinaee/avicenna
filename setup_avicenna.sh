#!/bin/sh

SITE_FOLDER=$1
# creates the site folder
hugo new site $SITE_FOLDER

# install the latest avicenna theme
cd $SITE_FOLDER
git clone -b master git@github.com:hadisinaee/avicenna.git ./themes/avicenna

# copy the template site
cp -R themes/avicenna/exampleSite/* ./