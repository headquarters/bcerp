#!/usr/bin/env bash

# Install curl...
echo ">>> Install curl"
sudo apt-get install curl -y

# ...to install RVM and latest Ruby + Rubygems
echo ">>> Install RVM, latest Ruby, and Rubygems"
curl -sSL https://get.rvm.io | bash -s stable --ruby

echo ">>> Installing Sinatra (documentation will take a while...)"
gem install sinatra

echo ">>> Installing adapter for SQLite 3"
sudo apt-get install libsqlite3-dev

echo ">>> Installing Data Mapper SQLite adapter gem"
gem install dm-sqlite-adapter

echo ">>> Installing Data Mapper gem"
gem install data_mapper

echo ">>> Installing Thin gem"
gem install thin

# Install rerun gem to allow easy reloading of the app on file changes
# Do NOT use rerun: it fails to detect changes in files in a shared directory inside a VM.
# echo ">>> Installing Rerun gem"
# gem install rerun

# gem install shotgun

# install Heroku toolbelt for Debian/Ubuntu
# wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh -y | sh
# had problem with the above line...had to use
# wget https://toolbelt.heroku.com/install-ubuntu.sh
# and then `bash install-ubuntu.sh` manually

# echo ">>> Installing Heroku toolbelt"
# wget https://toolbelt.heroku.com/install-ubuntu.sh -y
# bash install-ubuntu.sh

