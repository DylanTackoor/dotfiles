#!/bin/bash

clear

echo "===================="
echo " macOS SETUP SCRIPT "
echo "===================="
echo ""

sudo -v

# Keep sudo alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Keeping Mac awake for one hour
caffeinate -d 3600 &

# echo "Joining Wifi..."
# networksetup -setairportnetwork en0 WIFI_SSID WIFI_PASSWORD

echo "Installing Brew & Xcode's Command Line Tools"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew analytics off

echo "Closing System Preferences if open..."
osascript -e 'tell application "System Preferences" to quit'

# TODO: Research valid computer names
# echo "Setting computer name (as done via System Preferences → Sharing)"
# sudo scutil --set ComputerName "0x6D746873"
# sudo scutil --set HostName "0x6D746873"
# sudo scutil --set LocalHostName "0x6D746873"
# sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"

echo "Enabling charging toggle sound..."
defaults write com.apple.PowerChime ChimeOnAllHardware -bool true; open /System/Library/CoreServices/PowerChime.app &

echo "Syncing time..."
sudo ntpdate -u time.apple.com

echo "Enabling keyrepeat globally..."
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "Enabling Safari developer options..."
defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
defaults write -g WebKitDeveloperExtras -bool true

echo "Dimming hidden Dock icons..."
defaults write com.apple.Dock showhidden -bool YES && killall Dock

echo "Disabling Gatekeeper..."
sudo spctl --master-disable
spctl --status

echo "Setting lockscreen message..."
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "This Mac belongs to World Media Interactive. Contact at techteam@worldmedia.net"

echo "Enabling tap to click for this user & login screen..."
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Enabling dark mode..."
defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true

echo "Upping bluetooth audio quality..."
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool Min (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool" 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Max" 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Min" 80
sudo killall coreaudiod

echo "Autohiding dock..."
defaults write com.apple.dock autohide -bool true && killall Dock

echo "Expanding save panel by default..."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Disabling automatically rearranging spaces..."
defaults write com.apple.dock mru-spaces -bool false

echo "Enabling Airdrop over ethernet..."
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

echo "Require password immediately after sleep..."
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "Enabling Ctrl + scroll to zoom screen..."
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

echo "Disabling Dashboard..."
defaults write com.apple.dashboard mcx-disabled -bool true
defaults write com.apple.dock dashboard-in-overlay -bool true

echo "Activity monitor showing stats in dock..."
defaults write com.apple.ActivityMonitor IconType -int 5

echo "Sorting Activity Monitor results by CPU usage..."
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

echo "Column view by default..."
defaults write com.apple.Finder FXPreferredViewStyle clmv

echo "Enabling copy emails as plaintext from Mail.app..."
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

echo "Allowing text-selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true

echo "Speeding up key repeat..."
defaults write -g KeyRepeat -int 0

echo "Disabling HDD motion sensor protection..."
sudo pmset -a sms 0

echo "Searching current dir by default..."
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Avoiding creation of .DS_Store files on network or USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "Starting iCal on Monday..."
defaults write com.apple.iCal "first day of week" -int 1

echo "Enabling \"Do Not Track\" on Safari..."
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

echo "Disabling parental controls on guest user..."
sudo dscl . -mcxdelete /Users/guest
sudo rm -rf /Library/Managed\ Preferences/guest

echo "Disabling opening application prompt..."
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "Disabling file extension editing warning..."
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "Keeping folders on top of file views..."
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo "Enabling autoupdates for Safari extensions..."
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

echo "Enabling SSH"
sudo systemsetup -setremotelogin on

echo "Changing screenshot location..."
defaults write com.apple.screencapture location ~/Pictures/Screenshots/ && killall SystemUIServer

# echo "Setting wallpaper..."
# cd ~/Pictures/Wallpapers/ || exit
# wget http://i.imgur.com/YdfjXbv.jpg
# mv YdfjXbv.jpg Triforce.jpg
# sudo osascript -e '
#   tell application "System Events"
#       set theDesktops to a reference to every desktop
#       repeat with x from 1 to (count theDesktops)
#           set picture of item x of the theDesktops to "~/Pictures/Wallpapers/Triforce.jpg"
#       end repeat
#   end tell
# '

echo "Enabling daily autoupdates..."
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
defaults write com.apple.commerce AutoUpdate -bool true

echo "Updating system..."
softwareupdate -l && sudo softwareupdate -i

echo "Setting up folders..."
mkdir ~/Pictures/Screenshots/
mkdir ~/Pictures/Wallpapers/
mkdir ~/Developer/

echo "Cloning repositories..."
cd ~/Developer || exit
git clone https://github.com/DylanTackoor/dotfiles.git

echo "Linking config files..."
ln -s ~/Developer/dotfiles/config/.zshrc ~/.zshrc
ln -s ~/Developer/dotfiles/config/.gitignore_global ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
git config --list
ln -s ~/Developer/dotfiles/config/.gitconfig ~/.gitconfig
ln -s ~/Developer/dotfiles/config/.eslintrc.js ~/.eslintrc.js # Provides syntax rules for js without local eslintrc.js

echo "Installing Spacemacs prereqs..."
# TODO: Refactor if possible
brew tap d12frosted/emacs-plus
brew tap caskroom/fonts
brew cask install font-source-code-pro
brew install emacs-plus --HEAD --with-natural-title-bars
brew linkapps emacs-plus

echo "Installing command-line applications..."
installBrews="brew install "
brews=(
    cask # Install GUI applications
    dockutil # Dock rearragment cli
    mas # Mac App Store CLI

    clang-format # C/C++/Obj-C linter
    ffmpeg # youtube-dl dependency
    htop # Terminal activity monitor
    neofetch # Displays system info
    node
    r
    ruby
    python
    python3
    shellcheck # Bash file linting
    speedtest_cli # Speedtest.net cli
    tldr # man pages for humans
    tidy-html5 # Atom html Linter
    tree # Prints filetree
    unrar # rar archive cli
    wget
    yarn
    youtube-dl # YouTube Downloader
    wifi-password #CLI to pull up currently connected wifi's password

    cowsay
    no-more-secrets
)

for brew in ${brews[@]}
do
    installBrews="$installBrews $brew"
done

eval $installBrews

# Brew update checker with notification center support
# curl -s https://raw.githubusercontent.com/stephennancekivell/brew-update-notifier/master/install.sh | sh

# echo "Signing into Mac App Store..."
# mas signin $appleIDemail "$appleIDpassword"

echo "Updating Mac App Store apps..."
# mas upgrade

echo "Installing Mac App Store apps..."
# mas install 497799835  #Xcode
# mas install 436203431  #XnConvert
# mas install 747633105  #Minify = HTML/CSS/JS minifier
# mas install 768053424  #Gapplin = SVG Viewer
# mas install 568494494  #Pocket
# mas install 1163798887 #Savage = SVG optimizer

echo "Installing casks..."
brew tap caskroom/cask
installCasks="brew cask install "
casks=(
    1password # Best password manager
    appcleaner # More throughrouly deletes apps
    android-studio
    basecamp
    cyberduck # FTP/SFTP client
    dash # Offline documentation downloader/indexer w/IDE plugins
    diffmerge
    flycut
    franz
    firefox
    flux # Better dimming that night shift
    google-backup-and-sync # New Google Drive client
    google-chrome
    google-chrome-canary
    harvest # Time tracker
    imageoptim # Optimizes images to arbitray degrees
    install-disk-creator # Used to create macOS install USBs
    iterm2 # Alternative Terminal app
    microsoft-office
    microsoft-teams
    onyx # Computer diagnostic tool
    postman # Great API endpoint testing tool
    robomongo # MongoDB GUI
    rescuetime
    resilio-sync # P2P folder sync tool
    rocket # Gitmoji insertion tool
    sequel-pro # SQL GUI
    skype-for-business
    studio-3t # Better Mongodb GUI
    the-unarchiver
    transmit # FTP tool
    typora # Markdown Editor
    virtualbox # Virtualization
    vlc # Plays almost any video/audio filetype

    qladdict # Subtitle srt files
    qlcolorcode # Syntax highlighted sourcecode
    qlvideo
    quicklook-csv
    quicklook-json
    qlstephen # Plain text files without or with unknown file extension. Example: README, CHANGELOG, index.styl, etc.
    qlmarkdown
    # qlprettypatch
    qlimagesize # Displays image size in preview
    betterzipql
    webpquicklook # Google's Webp image format
    suspicious-package
    provisionql
    quicklookapk
)

for cask in ${casks[@]}
do
    installCasks="$installCasks $cask"
done

eval $installCasks

echo "Installing pip packages..."
pip3 install pylint

# TODO: Make this universal
echo "Installing NPM packages..."
yarn global add typescript gulp node-sass reload eslint csvtojson

echo "Setting up Visual Studio Code..."
ln -s ~/Developer/dotfiles/config/settings.json ~/Library/Application\ Support/Code/User/settings.json
code --install-extension eg2.tslint
code --install-extension christian-kohler.npm-intellisense
code --install-extension zhuangtongfa.material-theme
code --install-extension deerawan.vscode-dash
code --install-extension mkxml.vscode-filesize
code --install-extension felixfbecker.php-intellisense
code --install-extension stubailo.ignore-gitignore
code --install-extension christian-kohler.npm-intellisense
code --install-extension ms-python.python
code --install-extension timonwong.shellcheck
code --install-extension shinnn.stylelint
code --install-extension wayou.vscode-todo-highlight
code --install-extension eg2.vscode-npm-script
code --install-extension joelday.docthis
code --install-extension pmneo.tsimporter
code --install-extension formulahendry.auto-rename-tag
code --install-extension robertohuertasm.vscode-icons
code --install-extension ms-vscode.cpptools

echo "Installing more Spacemacs stuff..."
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
ln -s ~/Developer/dotfiles/config/.spacemacs ~/.spacemacs
yarn global add tern

echo "Swapping Chrome print dialogue to expanded native dialogue..."
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

echo "Configuring iTerm 2"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false # Don’t display the annoying prompt when quitting iTerm

echo "Cleaning up Brew..."
brew cleanup
brew cask cleanup
brew update; brew upgrade; brew prune; brew cleanup; brew doctor

# TODO: confirm this is useful
echo "Cleaning up Garage Band..."
# TODO: only do this if actually installed
sudo rm -rf /Applications/GarageBand
sudo rm -rf /Library/Application Support/GarageBand
sudo rm -rf /Library/Audio/Apple Loops/Apple/Apple\ Loops\ for\ GarageBand
sudo rm -rf /Library/Receipts/com.apple.pkg.GarageBand_AppStore.bom
sudo rm -rf /Library/Receipts/com.apple.pkg.GarageBand_AppStore.plist
sudo rm -rf /System/Library/Receipts/com.apple.pkg.MAContent10_AssetPack_0325_AppleLoopsGarageBand1.bom
sudo rm -rf /System/Library/Receipts/com.apple.pkg.MAContent10_AssetPack_0325_AppleLoopsGarageBand1.plist
sudo rm -rf ~/Library/Application Scripts/com.apple.STMExtension.GarageBand
sudo rm -rf ~/library/Containers/com.apple.STMExtension.GarageBand

echo "Alphabetizing Launchpad..."
defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock

echo "Defaulting to Google Chrome..."
open -a "Google Chrome" --args --make-default-browser

echo "Setting up Powerline for ..."
cd ~ || exit
git clone https://github.com/powerline/fonts.git
cd fonts || exit
./install.sh
cd .. || exit
rm -rf fonts

echo "Installing Oh-My-ZSH..."
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
chsh -s /bin/zsh

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
docker -v
echo "Typescript:"
tsc -v

function reboot() {
  read -p "Do you want to reboot your computer now? (y/N)" choice
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
