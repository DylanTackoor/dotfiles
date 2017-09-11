#!/bin/bash

adduser dylan
usermod -aG sudo dylan
su - dylan

sudo apt update
sudo apt upgrade -y

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash 

sudo apt install -y nginx mysql-servernodejs
sudo ufw allow 'Nginx Full'

sudo npm i -g ghost-cli
sudo mkdir -p /var/www/ghost
sudo chown dylan:dylan /var/www/ghost
cd /var/www/ghost
ghost install