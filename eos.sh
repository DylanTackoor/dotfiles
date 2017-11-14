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
addRepo="sudo apt-add-repository -y ppa:"

repos=(
    ondrej/php # PHP
    zeal-developers/ppa # Zeal code documentation index
    git-core/ppa # Git
    philip.scott/elementary-tweaks # elementaryOS system tweaks UI
    # nathandyer/vocal-stable # elementaryOS Podcast organizer # TODO: broken
    tomato-team/tomato-daily # elementaryOS time tracker
    bablu-boy/nutty.0.1 # elementaryOS network monitor
    # webupd8team/java
)

for repo in ${repos[@]}
do
    eval "$addRepo$repo"
done

# Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# Steam
wget http://repo.steampowered.com/steam/signature.gpg && sudo apt-key add signature.gpg
sudo sh -c 'echo "deb http://repo.steampowered.com/steam/ precise steam" >> /etc/apt/sources.list.d/steam.list'

# Yarn JS package manager
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Visual Studio Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# Typora markdown editor
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
sudo add-apt-repository 'deb http://typora.io linux/'

# # Etcher
# echo "deb https://dl.bintray.com/resin-io/debian stable etcher" | sudo tee /etc/apt/sources.list.d/etcher.list
# sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 379CE192D401AB61

# Node.js
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

echo "Installing apps..."
installApps="sudo apt install -y "
apps=(
    git
    htop
    tmux
    zsh
    clang-format shellcheck
    steam calibre
    transmission
    google-chrome-stable firefox
    typora
    gimp inkscape
    gparted
    gnome-system-monitor
    # etcher-electron
    virtualbox
    docker
    tlp tlp-rdw
    zeal
    code arduino
    nodejs ruby-dev php python3-pip python-dev python-pip python3-dev
    yarn hugo
    elementary-tweaks
    tomato
    nutty
    rar unrar zip unzip
    # TODO: figure out how to install Slack, Docker, Telegram, Robo 3T
)

for app in ${apps[@]}
do
    installApps="$installApps $app"
done

eval $installApps

# echo "Installling Teamviewer..."
# sudo dpkg --add-architecture i386
# sudo apt-get update
# sudo apt-get install gdebi
# wget http://download.teamviewer.com/download/version_12x/teamviewer_i386.deb
# sudo gdebi teamviewer_linux.deb
# sudo dpkg --remove-architecture i386

echo "Updating pip..."
pip install --upgrade pip
pip3 install --upgrade pip3

# echo "Fixing NPM permission issues...."
# mkdir ~/.npm-global
# npm config set prefix '~/.npm-global'
# export PATH=~/.npm-global/bin:$PATH
# source ~/.profile

# TODO: Make this universal
echo "Installing NPM packages..."
yarn global add typescript gulp node-sass reload eslint csvtojson

echo "Installing Spacemacs..."
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
ln -s ~/Developer/dotfiles/config/.spacemacs ~/.spacemacs
yarn global add tern

echo "Installing Postman API tester..."
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

# echo "Installing Dropbox + elementaryOS tweaks..."
# git clone https://github.com/zant95/elementary-dropbox /tmp/elementary-dropbox
# bash /tmp/elementary-dropbox/install.sh -y

echo "Setting up folders..."
mkdir ~/Developer/
mkdir ~/.config

echo "Cleaning up..."
sudo apt purge -y epiphany-browser
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

echo "Installing Oh-My-ZSH..."
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s /bin/zsh

echo ""
echo "===================="
echo " THAT'S ALL, FOLKS! "
echo "===================="
echo ""
notify-send -i utilities-terminal elementary-script "Setup completed!"
git --version
echo "Visual Studio Code:"
code -v
node -v
npm -v
python3 --version
php -v
echo "Typescript:"
tsc -v

# TODO: prompt to reboot
