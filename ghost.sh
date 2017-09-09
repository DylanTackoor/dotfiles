#!/bin/bash

sudo apt update
sudo apt upgrade -y

sudo apt install nginx -y
sudo ufw allow 'Nginx Full'

sudo apt install mysql-server

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash 
sudo apt-get install -y nodejs

sudo npm i -g ghost-cli
sudo mkdir -p /var/www/ghost
sudo chown dylan:dylan /var/www/ghost
cd /var/www/ghost
ghost install