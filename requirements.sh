#!/usr/bin/env bash

# Use --no-ri --no-rdoc params if Ruby doc generation takes forever
echo ">>> Installing Ruby Gems"

sudo apt-get install rubygems -y

echo ">>> Installing Sinatra gem"
sudo gem install sinatra

echo ">>> Installing Data Mapper gem"
sudo gem install data_mapper

echo ">>> Install Data Mapper SQLite adapter"
sudo gem install dm-sqlite-adapter

echo ">>> Installing JSON gem"
sudo gem install json

echo ">>> Installing Rerun gem"
# Rerun gem requires Ruby version 1.9.2 or greater for one of its dependencies
sudo gem install rerun