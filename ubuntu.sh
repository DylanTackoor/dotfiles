#!/bin/bash

clear

echo "==========================="
echo " Ubuntu 19.10 SETUP SCRIPT "
echo "==========================="
echo ""

echo "Adding repos..."
repos=(
    zeal-developers/ppa # Code documentation index
    git-core/ppa        # Git
    linrunner/tlp       # Battery optimizations
    openrazer/stable    # Razer Hardware Drivers
    # ppa:boltgolt/howdy # Face Unlock
)
for repo in "${repos[@]}"; do
    eval "sudo apt-add-repository -y ppa:$repo"
done

# TODO: clean this up somehow
echo "Adding Repos..."

if ! grep -q "^deb .*http://dl.google.com/linux/chrome/deb/" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding Google Chrome repository..."
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
fi

if ! grep -q "^deb .*http://repo.steampowered.com/steam/" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding Steam repository..."
    wget http://repo.steampowered.com/steam/signature.gpg && sudo apt-key add signature.gpg
    sudo sh -c 'echo "deb http://repo.steampowered.com/steam/ precise steam" >> /etc/apt/sources.list.d/steam.list'
fi

if ! grep -q "^deb .*https://packages.microsoft.com/repos/vscode" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding Visual Studio Code repository..."
    wget https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
fi

if ! grep -q "^deb .*http://repository.spotify.com" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding Spotify repository..."
    wget -q -O - https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
fi

if ! grep -q "^deb .*https://download.docker.com/linux/ubuntu" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding Docker repository..."
    wget -q -O - https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu disco stable"
fi

if ! grep -q "^deb .*http://mcpelauncher.mrarm.io/apt/ubuntu/" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding Minecraft Bedrock Edition repository..."
    sudo dpkg --add-architecture i386
    wget -q -O - https://mcpelauncher.mrarm.io/apt/conf/public.gpg.key | sudo apt-key add -
    sudo add-apt-repository 'deb http://mcpelauncher.mrarm.io/apt/ubuntu/ disco main'
fi

# TODO: decide on gcloud apt repo vs snap
# echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
# curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
# sudo apt-get update && sudo apt-get install google-cloud-sdk

echo "Updating..."
sudo apt update
sudo apt upgrade -y

echo "Installing apps..."
apps=(
    git
    nvidia-prime nvidia-settings xserver-xorg-video-nvidia-435
    htop
    zsh
    gnome-calendar gnome-photos gnome-maps geary
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
    shellcheck
    plank
    rar unrar zip unzip
    # howdy

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
for app in "${apps[@]}"; do
    installApps="sudo apt install -y $app"
done
eval "$installApps"

echo "Cloning..."
git clone https://github.com/DylanTackoor/dotfiles.git ~/.dotfiles

echo "Setting up folders..."
chmod -R +x ./commands/*
mkdir ~/Developer/
ln -s ~/.dotfiles/photos/wallpapers ~/Pictures/Wallpapers
ln -s ~/.dotfiles/config/.zshrc ~/.zshrc
ln -s ~/.dotfiles/config/.p10k.zsh ~/.p10k.zsh
ln -s ~/.dotfiles/config/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/config/.gitignore_global ~/.gitignore_global
ln -s ~/.dotfiles/config/libinput-gestures.conf ~/.config/libinput-gestures.conf

echo "Installing snaps..."
sudo snap install rocketchat-desktop discord postman
sudo snap install --classic slack google-cloud-sdk

echo "OLED Brightness Fix..."
sudo git clone https://github.com/udifuchs/icc-brightness.git /opt/icc-brightness/
cd /opt/icc-brightness/ && sudo make install

echo "Enabling Trackpad gestures..."
sudo gpasswd -a "$USER" input
sudo apt install -y python3 python3-setuptools xdotool python3-gi libinput-tools python-gobject xdotool wmctrl
sudo git clone https://github.com/bulletmark/libinput-gestures.git /opt/libinput-gestures/
cd /opt/libinput-gestures/ && sudo make install
libinput-gestures-setup autostart
libinput-gestures-setup start
sudo git clone https://gitlab.com/cunidev/gestures /opt/gestures
cd /opt/gestures && sudo python3 setup.py install

echo "Installing ctop"
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.2/ctop-0.7.2-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop

echo "Installing NPM packages..."
npm i -g typescript servor gatsby-cli tldr

echo "Updating tldr pages..."
tldr --update

echo "Enabling Power Management"
sudo systemctl enable tlp

echo "Adding \"$USERNAME\" to open-razer group..."
sudo gpasswd -a "$USERNAME" plugdev

# TODO: Install Apple Emoji font
# echo "Adding Apple Emoji..."
# sudo gem install bundler
# sudo git clone git@github.com:samuelngs/apple-emoji-linux.git /opt/apple-emoji-linux
# bundle install

echo "Fixing Razer suspend..."
sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT="quiet splash button.lid_init_state=open"' /etc/default/grub
sudo update-grub

# TODO: recursively symlink all files in commands folder
echo "Symlinking Commands"
sudo ln ~/.dotfiles/commands/set-lum /usr/local/bin
sudo ln ~/.dotfiles/commands/set-max-cpu-frequency /usr/local/bin
sudo ln ~/.dotfiles/commands/update50 /usr/local/bin

echo "Testing commands..."
sudo set-max-cpu-frequency 2.2
set-lum 0.7

echo "Downloading Gnome extensions..."
# TODO: add workspace matrix plugin
# sudo git clone https://github.com/mpdeimos/gnome-shell-remove-dropdown-arrows.git /usr/share/gnome-shell/extensions/remove-dropdown-arrows@mpdeimos.com
sudo git clone https://github.com/richard-fisher/hide-activities.git /usr/share/gnome-shell/extensions/hide-activities-button@gnome-shell-extensions.bookmarkd.xyz
sudo git clone https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git /usr/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com
sudo git clone https://github.com/kgshank/gse-sound-output-device-chooser.git /opt/gse-sound-output-device-chooser
sudo ln -s /opt/gse-sound-output-device-chooser/sound-output-device-chooser@kgshank.net /usr/share/gnome-shell/extensions/sound-output-device-chooser@kgshank.net
sudo git clone https://github.com/maoschanz/emoji-selector-for-gnome.git /opt/emoji-selector-for-gnome/
sudo ln -s /opt/emoji-selector-for-gnome/emoji-selector@maestroschan.fr /usr/share/gnome-shell/extensions/emoji-selector@maestroschan.fr
sudo git clone git://github.com/eonpatapon/gnome-shell-extension-caffeine.git /opt/gnome-shell-extension-caffeine
cd /usr/share/gnome-shell/extensions && sudo wget https://github.com/andyholmes/gnome-shell-extension-gsconnect/releases/download/v31-rc1/gsconnect@andyholmes.github.io.zip
sudo unzip gsconnect@andyholmes.github.io.zip -d gsconnect@andyholmes.github.io && sudo rm -rf gsconnect@andyholmes.github.io.zip

# TODO: test out caffeine
# cd /opt/gnome-shell-extension-caffeine
# ./update-locale.sh
# glib-compile-schemas --strict --targetdir=caffeine@patapon.info/schemas/ caffeine@patapon.info/schemas
# sudo ln -s /opt/gnome-shell-extension-caffeine/caffeine@patapon.info /usr/share/gnome-shell/extensions/caffeine@patapon.info

echo "Configuring Gnome..."
# gsettings set org.gnome.desktop.background picture-uri "$HOME/.dotfiles/photos/wallpapers/Flower.jpg"
# gsettings set org.gnome.desktop.screensaver picture-options 'stretched'
# gsettings set org.gnome.desktop.screensaver picture-uri "file:/$HOME/.dotfiles/photos/wallpapers/Flower.png"
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.interface clock-format 12h
gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark # TODO: wrap in quotes?
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
gsettings set org.gnome.documents night-mode true
gsettings set org.gnome.Geary startup-notifications true
gsettings set org.gnome.gedit.preferences.editor bracket-matching true
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
gsettings set org.gnome.settings-daemon.plugins.power power-button-action suspend
gsettings set org.gnome.shell.extensions.dash-to-dock autohide false
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 20
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false
gsettings set org.gnome.shell.extensions.wsmatrix num-columns 4
gsettings set org.gnome.shell.extensions.wsmatrix num-rows 1

echo "Installing Oh-My-ZSH..."
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate"
git clone https://github.com/lukechilds/zsh-nvm "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-nvm"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/dgnest/zsh-gvm-plugin "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-gvm-plugin"
chsh -s /bin/zsh "$USERNAME"
usermod -s /bin/zsh "$USERNAME"
# TODO: test that this changes shell & install plugins correctly

echo "Installing Go and Go Version Manager..."
zsh < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source /home/dylan/.gvm/scripts/gvm
gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.13.5
gvm use go1.13.5 --default
gvm uninstall go1.4

echo "Setting up Visual Studio Code..."
ln -s ~/.dotfiles/config/vscode/keybindings-ubuntu.json ~/.config/Code/User/keybindings.json
ln -s ~/.dotfiles/config/vscode/settings.json ~/.config/Code/User/settings.json
ln -s ~/.dotfiles/config/vscode/snippets ~/.config/Code/User/snippets

code --install-extension DavidAnson.vscode-markdownlint
code --install-extension dbaeumer.vscode-eslint
code --install-extension deerawan.vscode-dash
code --install-extension eamodio.gitlens
code --install-extension eg2.vscode-npm-script
code --install-extension esbenp.prettier-vscode
code --install-extension fabiospampinato.vscode-todo-plus
code --install-extension foxundermoon.shell-format
code --install-extension jpoissonnier.vscode-styled-components
code --install-extension kisstkondoros.vscode-codemetrics
code --install-extension kumar-harsh.graphql-for-vscode
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-vscode.atom-keybindings
code --install-extension ms-vscode.Go
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension orta.vscode-jest
code --install-extension pflannery.vscode-versionlens
code --install-extension ryu1kn.partial-diff
code --install-extension Shan.code-settings-sync
code --install-extension shardulm94.trailing-spaces
code --install-extension stevencl.addDocComments
code --install-extension stubailo.ignore-gitignore
code --install-extension Tyriar.sort-lines
code --install-extension viktorqvarfordt.vscode-pitch-black-theme
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension vscode-icons-team.vscode-icons
code --install-extension vscodevim.vim
code --install-extension WakaTime.vscode-wakatime
code --install-extension wix.vscode-import-cost

echo "Cleaning up..."
rm -rf ~/Templates ~/Public
sudo apt autoremove -y

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
gvm version
go version

# Prompt for reboot
function reboot() {
    read -p "Do you want to reboot your computer now? (y/N)" choice
    case "$choice" in
    y | Yes | yes)
        echo "Yes"
        exit
        ;; # If y | yes, reboot
    n | N | No | no)
        echo "No"
        exit
        ;; # If n | no, exit
    *) echo "Invalid answer. Enter \"y/yes\" or \"N/no\"" && return ;;
    esac
}

# Call on the function
if [[ "Yes" == $(reboot) ]]; then
    echo "Rebooting."
    sudo reboot
    exit 0
else
    exit 0
fi
