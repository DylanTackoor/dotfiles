#First you update your system
sudo apt update && sudo apt dist-upgrade

#Install Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt update
sudo apt install google-chrome-stable

#Clean-up System
sudo apt purge midori-granite
sudo apt purge software-center
sudo apt autoremove
sudo apt autoclean

#Remove some Switchboard Plug's
# sudo rm -rf /usr/lib/plugs/GnomeCC/gnomecc-bluetooth.plug
# sudo rm -rf /usr/lib/plugs/GnomeCC/gnomecc-wacom.plug

#Install File Compression Libs
sudo apt install unace unrar zip unzip xz-utils p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller

#Install Guake Terminal
sudo apt install guake

#Install screenfetch (my elementary-OS special Version)
mkdir screenfetch
cd screenfetch
wget https://raw.github.com/memoryleakx/screenFetch/master/screenfetch-dev
sudo mv screenfetch-dev /usr/bin/screenfetch
cd ..
rm -rf screenfetch

#make it readable and executable
sudo chmod +rx /usr/bin/screenfetch

##setup .bashrc for auto screenfetch
gedit ~/.bashrc
###put this on the last line
screenfetch -D "Elementary"

#Install Ubuntu Restricted Extras
sudo apt install ubuntu-restricted-extras

#Enable all Startup Applications
cd /etc/xdg/autostart
sudo sed --in-place 's/NoDisplay=true/NoDisplay=false/g' *.desktop

#Enable Movie DVD Support
sudo apt install libdvdread4
sudo /usr/share/doc/libdvdread4/install-css.sh

#Install a Firewall Application
sudo apt install gufw

#Install Gimp
sudo add-apt-repository ppa:otto-kesselgulasch/gimp
sudo apt update
sudo apt install gimp gimp-data gimp-plugin-registry gimp-data-extras

#Install Elementary OS extras
sudo apt-add-repository ppa:versable/elementary-update
sudo apt update

sudo apt install elementary-desktop elementary-tweaks
sudo apt install elementary-dark-theme elementary-plastico-theme elementary-whit-e-theme elementary-harvey-theme
sudo apt install elementary-elfaenza-icons elementary-nitrux-icons
sudo apt install elementary-plank-themes
sudo apt install wingpanel-slim indicator-synapse

#if not installed
#Install the Dynamic Kernel Module Support Framework
sudo apt install dkms

mkdir kernel
cd kernel

#Install Kernel 3.12.2 on 64 Bit
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12.2-trusty/linux-headers-3.12.2-031202-generic_3.12.2-031202.201311291538_amd64.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12.2-trusty/linux-headers-3.12.2-031202_3.12.2-031202.201311291538_all.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12.2-trusty/linux-image-3.12.2-031202-generic_3.12.2-031202.201311291538_amd64.deb

#Install Kernel 3.12.2 on 32 Bit
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12.2-trusty/linux-headers-3.12.2-031202-generic_3.12.2-031202.201311291538_i386.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12.2-trusty/linux-headers-3.12.2-031202_3.12.2-031202.201311291538_all.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12.2-trusty/linux-image-3.12.2-031202-generic_3.12.2-031202.201311291538_i386.deb

sudo dpkg -i *.deb

cd ..
rm -rf kernel
#Reboot!

#Install fresh firmware
mkdir firmware
cd firmware

wget https://launchpad.net/ubuntu/+archive/primary/+files/linux-firmware_1.117_all.deb
wget https://launchpad.net/ubuntu/+archive/primary/+files/nic-firmware_1.117_all.udeb

sudo dpkg -i *.deb

cd ..
rm -rf firmware

#update initramfs
sudo update-initramfs -k all -u
#Reboot!

#Install Broadcom STA Driver (if you need)
mkdir wlan
cd wlan
wget https://launchpad.net/ubuntu/+archive/primary/+files/broadcom-sta-dkms_6.30.223.141-1_all.deb

sudo dpkg -i *.deb
cd ..
rm -rf wlan
#Reboot!

#Install Apparmor 2.8
sudo add-apt-repository ppa:apparmor-upload/apparmor-2.8
sudo apt update && sudo apt dist-upgrade


#Install Java 7
sudo add-apt-repository ppa:webupd8team/java
sudo apt update
sudo apt install oracle-java7-installer

#Install Steam
wget http://repo.steampowered.com/steam/signature.gpg && sudo apt-key add signature.gpg
sudo sh -c 'echo "deb http://repo.steampowered.com/steam/ precise steam" >> /etc/apt/sources.list.d/steam.list'
sudo apt update
sudo apt install steam

#Install the latest git Version
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt dist-upgrade
sudo apt install git

#Install the latest Version of VirtualBox
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian precise contrib" >> /etc/apt/sources.list.d/virtualbox.list'
sudo apt update
sudo apt install virtualbox-4.3

#Install Thunderbird
#if you want install Thunderbird instead of Geary Mail
#first remove Geary Mail
sudo apt purge geary

sudo add-apt-repository ppa:ubuntu-mozilla-security/ppa
sudo apt update
sudo apt install thunderbird
