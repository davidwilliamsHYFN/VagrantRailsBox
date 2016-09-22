#!/usr/bin/env bash

echo "Lets Get this party started..."
sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev -y

echo "Installing rbenv..."

git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

export RBENV_ROOT="${HOME}/.rbenv/"
export PATH="${RBENV_ROOT}/bin:${PATH}"
export PATH="${RBENV_ROOT}/shims:${PATH}"

rbenv install 2.3.1
rbenv global 2.3.1
echo "Installing bundler..."
sudo gem install bundler
rbenv rehash

echo "getting official passenger nginx distro..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
# Add Passenger APT repository
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update

echo "Installing passenger and nginx..."
sudo apt-get install -y nginx-extras passenger --force-yes

echo "Installing Node.js"
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Installing Memcached"
sudo apt-get install -y memcached

echo "Installing Redis"
sudo apt-get install -y redis-server

rm /etc/nginx/passenger.conf
ln -s /etc/nginx /vagrant/passenger.conf

rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-enabled /vagrant/default

sudo service nginx restart

echo "installing postgres.."
sudo apt-get install postgresql postgresql-contrib libpq-dev -y

echo "create reactapp_developement DB"

sudo -u postgres psql -1 -c "CREATE USER vagrant;"
sudo -u postgres psql -1 -c "ALTER USER vagrant WITH SUPERUSER;"
sudo -u postgres psql -1 -c "CREATE DATABASE reactapp_developement;"

echo "Running bundler...."
cd /vagrant/reactApp
bundle install
