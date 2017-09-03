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
sudo apt install -y software-properties-common ubuntu-restricted-extras # TODO: research restricted extras being necessary. believe it's just for mp3

echo "Adding repos..."
sudo apt-add-repository -y ppa:nathandyer/vocal-stable #Vocal Podcast
sudo add-apt-repository -y ppa:webupd8team/atom # Atom text editor
sudo add-apt-repository -y ppa:ondrej/php # PHP
sudo add-apt-repository -y ppa:zeal-developers/ppa # Zeal code documentation index
sudo add-apt-repository -y ppa:git-core/ppa # Git
sudo add-apt-repository -y ppa:philip.scott/elementary-tweaks # elementaryOS system tweaks UI
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-add-repository -y ppa:nathandyer/vocal-stable # elementaryOS Podcast organizer
sudo apt-add-repository -y ppa:tomato-team/tomato-daily # elementaryOS time tracker
sudo apt-add-repository -y ppa:voldyman/markmywords # elementaryOS markdown editor
sudo apt-add-repository -y ppa:bablu-boy/nutty.0.1 # elementaryOS network monitor
# sudo add-apt-repository -y ppa:neovim-ppa/stable # Neovim # TODO: Figure out security problem here

# Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# Steam
wget http://repo.steampowered.com/steam/signature.gpg && sudo apt-key add signature.gpg
sudo sh -c 'echo "deb http://repo.steampowered.com/steam/ precise steam" >> /etc/apt/sources.list.d/steam.list'

# Visual Studio Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# Node.js
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

echo "Installing apps..."
sudo apt update
sudo apt upgrade -y
sudo apt install -y git htop tmux zsh #CLIs speedtest_cli 
sudo apt install -y clang-format shellcheck #linters tidy-html5
sudo apt install -y steam calibre transmission google-chrome-stable vlc gimp inkscape gparted gnome-system-monitor #GUI Apps
sudo apt install -y virtualbox docker # container stuff
sudo apt install -y tlp tlp-rdw # Laptop power stuff
sudo apt install -y zeal code atom arduino #neovim
sudo apt install -y nodejs php mongodb python3-pip python-dev python-pip python3-dev oracle-java8-installer # Programming languages
sudo apt install -y elementary-tweaks vocal tomato mark-my-words nutty #Elementary OS specific
sudo apt install -y valac libgranite-dev libpackagekit-glib2-dev libunity-dev #for eddy package installer
sudo apt install -y unace unrar zip unzip xz-utils p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller #unarchivers
# TODO: figure out how to install Slack, Etcher, Docker, Telegram, Robo 3T

# echo "Installling Teamviewer..."
# sudo dpkg --add-architecture i386
# sudo apt-get update
# sudo apt-get install gdebi
# wget http://download.teamviewer.com/download/version_12x/teamviewer_i386.deb
# sudo gdebi teamviewer_linux.deb
# sudo dpkg --remove-architecture i386

echo "Updating pip..."
pip3 install --upgrade pip

# echo "Installing up Neovim providers..."
# # sudo gem install neovim # TODO: fix this
# pip install --user --upgrade neovim
# pip3 install --user --upgrade neovim

# echo "Configuring fuck command... (lol)"
# sudo pip3 install thefuck
# fuck
# fuck

echo "Fixing NPM permission issues...."
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
source ~/.profile

# TODO: Make this universal
echo "Installing NPM packages..."
npm install -g typescript gulp node-sass reload @angular/cli express-generator csvtojson js-beautify create-react-app

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

# echo "Installing up Neovim providers..."
# sudo gem install neovim
# pip install --upgrade pip
# pip2 install --user --upgrade neovim
# pip3 install --user --upgrade neovim
# #TODO: Install copy util

# echo "Installing Dropbox + elementaryOS tweaks..."
# git clone https://github.com/zant95/elementary-dropbox /tmp/elementary-dropbox
# bash /tmp/elementary-dropbox/install.sh -y

echo "Installing Atom plugins..."
apm install file-icons pigments less-than-slash highlight-selected autocomplete-modules atom-beautify color-picker todo-show tokamak-terminal
apm install language-babel atom-typescript sass-autocompile language-ejs language-htaccess
apm install linter linter-tidy linter-csslint linter-php linter-scss-lint linter-clang linter-tslint linter-jsonlint linter-pylint linter-shellcheck linter-handlebars
apm install minimap minimap-highlight-selected minimap-find-and-replace minimap-pigments minimap-linter

echo "Setting up folders..."
mkdir ~/Developer/

echo "Cleaning up..."
sudo apt purge -y epiphany-browser
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
atom -v
echo "Visual Studio Code:"
code -v
node -v
npm -v
python3 --version
php -v
echo "Typescript:"
tsc -v
mongod --version
# docker -v

function reboot() {
  read -p "Some changes will not take effect until the computer is rebooted. Reboot now? (y/N)" choice
  case "$choice" in
    y | Yes | yes ) echo "Yes"; exit;; # If y | yes, reboot
    n | N | No | no) echo "No"; exit;; # If n | no, exit
    * ) echo "Invalid answer. Enter \"y/yes\" or \"N/no\"" && return;;
  esac
}

# Call on the function
if [[ "Yes" == $(reboot) ]]
then
  echo "Rebooting."
  sudo reboot
  exit 0
else
  exit 1
fi
