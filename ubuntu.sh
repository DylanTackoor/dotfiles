#!/bin/bash

clear

echo "==========================="
echo " Ubuntu 19.10 SETUP SCRIPT "
echo "==========================="
echo ""

echo "Adding repos..."
repos=(
    zeal-developers/ppa # Code documentation index
    git-core/ppa # Git
    linrunner/tlp # Battery optimizations
    openrazer/stable # Razer Hardware Drivers
)
for repo in ${repos[@]}
do
    eval "sudo apt-add-repository -y ppa:$repo"
done

echo "Adding Google Chrome repository..."
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

echo "Adding Steam repository..."
wget http://repo.steampowered.com/steam/signature.gpg && sudo apt-key add signature.gpg
sudo sh -c 'echo "deb http://repo.steampowered.com/steam/ precise steam" >> /etc/apt/sources.list.d/steam.list'

echo "Adding Visual Studio Code repository..."
wget https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

echo "Adding Spotify repository..."
wget -q -O - https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

echo "Adding Docker repository..."
wget -q -O - https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu disco stable"

echo "Adding Minecraft Bedrock Edition repository..."
sudo dpkg --add-architecture i386
wget -q -O - https://mcpelauncher.mrarm.io/apt/conf/public.gpg.key | sudo apt-key add -
sudo add-apt-repository 'deb http://mcpelauncher.mrarm.io/apt/ubuntu/ disco main'

echo "Updating..."
sudo apt update
sudo apt upgrade -y

echo "Installing apps..."
apps=(
    git
    htop
    zsh
    cowsay
    steam
    calibre
    transmission
    httpie
    gnome-tweaks
    neofetch
    spotify-client
    google-chrome-stable
    gimp
    tlp tlp-rdw
    zeal
    code
    rar unrar zip unzip

    # OLED Brightness Fix
    liblcms2-dev

    # Razer
    openrazer-meta polychromatic

    # Docker
    software-properties-common gnupg-agent curl ca-certificates apt-transport-https
    docker-ce docker-ce-cli docker-compose

    # Go Version Manager
    mercurial make binutils bison gcc build-essential

    # Minecraft
    mcpelauncher-client mcpelauncher-ui-qt libegl1-mesa-dev:i386 msa-daemon msa-ui-qt
)
for app in ${apps[@]}
do
    installApps="sudo apt install -y $app"
done
eval $installApps

echo "Adding $USERNAME to open-razer group..."
sudo gpasswd -a $USERNAME plugdev

echo "Cloning..."
git clone https://github.com/DylanTackoor/dotfiles.git ~/.dotfiles

echo "Setting up folders..."
chmod -R +x ./commands/*
mkdir ~/Developer/
ln -s ~/.dotfiles/wallpapers ~/Pictures/Wallpapers
ln -s ~/.dotfiles/config/.zshrc ~/.zshrc
ln -s ~/.dotfiles/config/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/config/.gitignore_global ~/.gitignore_global

echo "Configuring Gnome..."
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.interface clock-format 12h
gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark # TODO: wrap in quotes?
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
gsettings set org.gnome.settings-daemon.plugins.power power-button-action suspend
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 20
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.desktop.background picture-uri "$(pwd)/wallpapers/Harvard.jpg"

echo "Installing snaps..."
sudo snap install rocketchat-desktop discord postman
sudo snap install --classic slack

echo "OLED Brightness Fix..."
sudo git clone https://github.com/udifuchs/icc-brightness.git /opt/icc-brightness/
cd /opt/icc-brightness/ || exit
sudo make install

echo "Enabling Power Management"
sudo systemctl enable tlp

# TODO: Trackpad gestures

echo "Installing ctop"
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.2/ctop-0.7.2-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop

echo "Installing Visual Studio Code sync extension..."
code --install-extension shan.code-settings-sync

echo "Installing NPM packages..."
npm i -g typescript servor gatsby-cli tldr

echo "Updating tldr pages..."
tldr --update

echo "Installing Oh-My-ZSH..."
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate
git clone https://github.com/lukechilds/zsh-nvm ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-nvm
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/dgnest/zsh-gvm-plugin ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-gvm-plugin
chsh -s /bin/zsh $USERNAME
usermod -s /bin/zsh $USERNAME

echo "Installing Go and Go Version Manager..."
zsh < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source /home/dylan/.gvm/scripts/gvm
gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.13.5
gvm use go1.13.5 --default
gvm uninstall go1.4

echo "Cleaning up..."
rm -rf ~/Templates ~/Public
sudo apt update
sudo apt autoremove -y

echo "Fixing Razer suspend..."
sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT="quiet splash button.lid_init_state=open"' /etc/default/grub
sudo update-grub

echo "Underclockingn CPU..."
sudo ln ~/.dotfiles/commands/set-max-cpu-frequency /usr/local/bin
sudo set-max-cpu-frequency 2.2

echo "Setting Brightness"
sudo ln ~/.dotfiles/commands/set-lum /usr/local/bin
set-lum 0.7

echo ""
echo "===================="
echo " THAT'S ALL, FOLKS! "
echo "===================="
echo ""
git --version
code -v
node -v
npm -v
tsc -v

# # TODO: wait for Enter
# sudo reboot
