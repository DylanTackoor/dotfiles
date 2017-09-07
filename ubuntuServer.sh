#!/bin/bash

clear

# 4k scaling
gsettings set org.gnome.desktop.interface text-scaling-factor 1.35

echo "==========================="
echo " elementaryOS SETUP SCRIPT "
echo "==========================="
echo ""

echo "Updating..."
sudo apt update
sudo apt upgrade -y

# Allows for adding package repos
sudo apt install -y software-properties-common

echo "Adding repos..."
sudo add-apt-repository -y ppa:ondrej/php # PHP
sudo add-apt-repository -y ppa:git-core/ppa # Git
sudo add-apt-repository -y ppa:neovim-ppa/stable # Neovim # TODO: Figure out security problem here

# Yarn JS package manager
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Node.js
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

echo "Installing apps..." # Node.js updates prior
sudo apt upgrade -y
sudo apt install -y git htop tmux zsh neovim #CLIs speedtest_cli 
sudo apt install -y docker # container stuff
sudo apt install -y nodejs php mongodb python3-pip python-dev ruby python-pip python3-dev oracle-java8-installer # Programming languages
sudo apt install -y rar unrar zip unzip #unarchivers

echo "Updating pip..."
pip3 install --upgrade pip

echo "Installing up Neovim providers..."
sudo gem install neovim # TODO: fix this
pip install --user --upgrade neovim
pip3 install --user --upgrade neovim

echo "Fixing NPM permission issues...."
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
source ~/.profile

echo "Installing NPM packages..."
npm install -g typescript gulp node-sass

echo "Installing up Neovim providers..."
sudo gem install neovim
pip install --upgrade pip
pip2 install --user --upgrade neovim
pip3 install --user --upgrade neovim

echo "Installing Atom plugins..."

echo "Setting up folders..."
mkdir ~/Developer/

echo "Cleaning up..."
sudo apt purge -y epiphany-browser
sudo apt autoremove -y

echo ""
echo "===================="
echo " THAT'S ALL, FOLKS! "
echo "===================="
echo ""
git --version
node -v
npm -v
python3 --version
php -v
echo "Typescript:"
tsc -v
mongod --version
docker -v

# TODO: prompt to reboot
