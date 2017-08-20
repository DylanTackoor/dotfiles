#!/bin/bash

clear

echo "==========================="
echo " elementaryOS SETUP SCRIPT "
echo "==========================="
echo ""

echo "Updating..."
sudo apt update
sudo apt upgrade -y

echo "Installing apps..."
# TODO: Install the latest git Version
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt dist-upgrade
sudo apt install git

# TODO: Install the latest Version of VirtualBox
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian precise contrib" >> /etc/apt/sources.list.d/virtualbox.list'
sudo apt update
sudo apt install virtualbox-4.3

# TODO: Install Steam
wget http://repo.steampowered.com/steam/signature.gpg && sudo apt-key add signature.gpg
sudo sh -c 'echo "deb http://repo.steampowered.com/steam/ precise steam" >> /etc/apt/sources.list.d/steam.list'
sudo apt update
sudo apt install steam

#Install the latest git Version
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install git

echo "Cleaning up..."
sudo apt autoremove -y