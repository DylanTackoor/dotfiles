#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

clear

echo ""
echo "====================="
echo " UBUNTU SETUP SCRIPT "
echo "====================="
echo ""

echo "Disabling guest session..."
sudo sh -c "echo 'allow-guest=false' >> /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf"

echo "Deleting garbage files/folders..."
rm -rf ~/Templates
rm -rf ~/.mozilla
rm examples.desktop

echo "Adding repositories..."
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo add-apt-repository ppa:zeal-developers/ppa -y
sudo add-apt-repository ppa:webupd8team/java -y

echo "Updating system..."
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

echo "Installing Node.js..."
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install nodejs -y

echo "Installing Node.js global packages..."
sudo npm install typescript gulp grunt node-sass mocha -g

echo "Installing programs..."
sudo apt install neovim zeal git zsh ruby gimp virtualbox handbrake transmission gparted unity-tweak-tool ubuntu-restricted-extras apache2 php oracle-java8-installer oracle-java8-set-default python3 python-dev python-pip python3-dev python3-pip -y
sudo snap install telegram-sergiusens

echo "Installing Atom plugins..."
apm install file-icons pigments highlight-selected autocomplete-modules atom-beautify auto-update-packages color-picker todo-show git-time-machine
apm install language-babel atom-typescript sass-autocompile
apm install linter linter-csslint linter-php linter-scss-lint linter-clang linter-jsonlint linter-pylint
apm install minimap minimap-highlight-selected minimap-find-and-replace minimap-pigments minimap-linter
#atom-touch-events
#Check the Hide Ignored Names from your file tree so that .DS_Store and .git don't appear needlessly.

echo "Cloning Neovim setup..."
mkdir ~/.config/
cd ~/.config/ || exit
git clone https://github.com/DylanTackoor/nvim.git

echo "Installing up Neovim providers..."
sudo gem install neovim
pip install --upgrade pip
pip2 install --user --upgrade neovim
pip3 install --user --upgrade neovim
#TODO: Install copy util

echo "Setting up Neovim aliases..."
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --config vi
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --config editor

echo "Installing vim-plug"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Removing bloat..."
#TODO: Remove all games
sudo apt-get remove --purge libreoffice firefox -y

echo "Downloading programs..."
mkdir ~/Downloads/setup/
cd ~/Downloads/setup/ || exit
#TODO: Find always up to date URLs
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget http://repo.steampowered.com/steam/archive/precise/steam_latest.deb
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-2.4.2-amd64.deb
wget https://github-cloud.s3.amazonaws.com/releases/54660683/8a52d5ec-74e5-11e6-8bb1-00550ae6514e.tgz?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAISTNZFOVBIJMK3TQ%2F20170218%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20170218T234735Z&X-Amz-Expires=300&X-Amz-Signature=bbf2c7a31c4b9d50c2b97cd3ea21cb55a2700dee5e7a1effb6e015c0f4333997&X-Amz-SignedHeaders=host&actor_id=5377356&response-content-disposition=attachment%3B%20filename%3DFranz-linux-x64-4.0.4.tgz&response-content-type=application%2Foctet-stream
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.1.2143.tar.gz
wget https://updates.tdesktop.com/tlinux/tsetup.1.0.5.tar.xz

echo "Installing programs + dependencies..."
sudo dpkg -i ~/Downloads/setup/*.deb
sudo apt-get -f install
rm ~/Downloads/setup/*.deb

echo "Double checking there aren't any remaining updates..."
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

echo "Installing Oh-My-ZSH..."
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# clear

# echo ""
# echo "===================="
# echo " TIME FOR A REBOOT! "
# echo "===================="
# echo ""
