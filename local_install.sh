#!/bin/bash

CURRENT_PATH=`pwd`
RAILS_ROOT="$CURRENT_PATH/testapp"

rm -rf /tmp/d-rails
cp -Rf ../d-rails /tmp

rm -Rf testapp/vendor
rm -Rf testapp/public/javascripts/dojo
mkdir -p testapp/vendor/plugins
cp -Rf /tmp/d-rails testapp/vendor/plugins

cd testapp/vendor/plugins/d-rails
chmod 755 install.rb
RAILS_ROOT=$RAILS_ROOT ./install.rb
rm -Rf generators
ln -s "$CURRENT_PATH/generators" generators
cd $CURRENT_PATH