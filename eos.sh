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

#Install Ubuntu Restricted Extras
sudo apt install -y ubuntu-restricted-extras

echo "Adding repos..."
# Install the latest git Version
sudo add-apt-repository ppa:git-core/ppa

# Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# Install Steam
wget http://repo.steampowered.com/steam/signature.gpg && sudo apt-key add signature.gpg
sudo sh -c 'echo "deb http://repo.steampowered.com/steam/ precise steam" >> /etc/apt/sources.list.d/steam.list'

# Zeal code documentation index
sudo add-apt-repository ppa:zeal-developers/ppa

# Visual Studio Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# PHP
sudo add-apt-repository ppa:ondrej/php

# Node.js
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

echo "Installing apps..."
sudo apt update
sudo apt upgrade -y
sudo apt install -y steam git google-chrome-stable nodejs php zeal code
sudo apt install -y calibre vlc mongodb transmission virtualbox arduino
sudo apt install unace unrar zip unzip xz-utils p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller
# TODO: figure out how to install Slack, Etcher, Docker, Telegram, Robo 3T

# TODO: fix npm permission
npm install -g typescript reload csvtojson js-beautify nave

# Postman API Tester
wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
sudo tar -xzf postman.tar.gz -C /opt
rm postman.tar.gz
sudo ln -s /opt/Postman/Postman /usr/bin/postman
cat > ~/.local/share/applications/postman.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=postman
Icon=/opt/Postman/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL

echo "Installing Node.js versions..."
nave install lts
nave use latest

echo "Cleaning up..."
sudo apt purge -y epiphany-browser
sudo apt autoremove -y

echo ""
echo "===================="
echo " THAT'S ALL, FOLKS! "
echo "===================="
echo ""
git --version
atom -v
echo "Visual Studio Code:"
code -v
node -v
npm -v
python3 --version
php -v
echo "Typescript:"
tsc -v
# docker -v
# mongod --version