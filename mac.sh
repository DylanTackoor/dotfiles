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

# TODO: listen for -dev and -dylan flags


# TODO: only ask if not -dylan
# Capturing info for later
echo "Full name:"
read fullName
echo "Phone Number (XXX-XXX-XXX):"
read phoneNumber
echo "Contact Email:"
read contactEmail
echo "Apple ID Email:"
read appleIDemail
echo "Apple ID Password:"
read appleIDpassword
echo "Git email:"
read GitEmail

# TODO: if -dylan use these values
# read fullName
# read phoneNumber
# read contactEmail
# read appleIDemail
# read appleIDpassword
# read GitEmail

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
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "This Mac belongs to $fullName. Contact at $phoneNumber or $contactEmail"

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

echo "Setting up folders..."
mkdir ~/Pictures/Screenshots/
mkdir ~/Pictures/Wallpapers/

mkdir ~/Developer/

echo "Changing screenshot location..."
defaults write com.apple.screencapture location ~/Pictures/Screenshots/ && killall SystemUIServer

echo "Setting wallpaper..."
cd ~/Pictures/Wallpapers/ || exit
wget http://i.imgur.com/YdfjXbv.jpg
mv YdfjXbv.jpg Triforce.jpg
sudo osascript -e '
  tell application "System Events"
      set theDesktops to a reference to every desktop
      repeat with x from 1 to (count theDesktops)
          set picture of item x of the theDesktops to "~/Pictures/Wallpapers/Triforce.jpg"
      end repeat
  end tell
'

# echo "Setting User profile picture if no Apple account..."
# mkdir cd ~/Pictures/Profile/
# cd ~/Pictures/Profile/ || exit
# wget http://graph.facebook.com/100000998230153/picture?type=large&w‌​idth=720&height=720
# dscl . delete /Users/admin jpegphoto
# dscl . delete /Users/admin Picture
# dscl . create /Users/admin Picture "/Library/User Pictures/wunderman.tif"

# TODO: 4 finger dragging
# TODO: Enable all trackpad gestures

# TODO: Enable play feedback when volume is changed

# TODO:
# echo "Forcing Airdrop to always be on..."

echo "Enabling daily autoupdates..."
defaults write com.apple.commerce AutoUpdate -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo "Updating system..."
softwareupdate -l && sudo softwareupdate -i

echo "Installing command-line applications..."
# TODO: Clean this
brew tap d12frosted/emacs-plus
brew install emacs-plus --HEAD --with-natural-title-bars
brew linkapps emacs-plus

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
    ruby
    python
    python3
    shellcheck # Bash file linting
    speedtest_cli # Speedtest.net cli
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
curl -s https://raw.githubusercontent.com/stephennancekivell/brew-update-notifier/master/install.sh | sh

echo "Signing into Mac App Store..."
mas signin $appleIDemail "$appleIDpassword"

echo "Updating Mac App Store apps..."
mas upgrade

echo "Installing Mac App Store apps..."
# mas install 497799835 #Xcode
mas install 803453959  #Slack
mas install 436203431  #XnConvert
mas install 784801555  #OneNote
mas install 747633105  #Minify = HTML/CSS/JS minifier
mas install 768053424  #Gapplin = SVG Viewer
mas install 1163798887 #Savage = SVG optimizer

echo "Installing casks..."
brew tap caskroom/cask
installCasks="brew cask install "
casks=(
    1password # Best password manager
    appcleaner # More throughrouly deletes apps
    # android-file-transfer # TODO: Replace this as it's pretty broken
    bartender # Hides menu bar icons
    caffeine # Menubar icon toggling computer sleep
    cyberduck # FTP/SFTP client
    dropbox
    flux # Better dimming that night shift
    front # Share email inbox app
    firefox
    get-lyrical # Adds lyrics to music selected in iTunes
    gfxcardstatus # Notifications when graphics card changes
    google-chrome
    google-backup-and-sync # New Google Drive client
    handbrake # Converts video formats
    microsoft-office
    monolingual # removes unneeded languages
    plex-media-player
    skype
    # simple-comic
    steam
    teamviewer # Cross platform remote desktop
    telegram-desktop # Chat service
    the-unarchiver # 
    toggldesktop # Time tracker
    transmission # Best Mac/Linux client
    vlc # Plays almost any video/audio filetype
    whatsapp
    daisydisk # Disk Cleaner
    # yacreader
    atom # GitHub text editor
    arduino # Arduino controller IDE
    calibre # eBook manager
    dash # Offline documentation downloader/indexer w/IDE plugins
    docker-toolbox
    etcher # Linux live USB creator
    imageoptim # Optimizes images to arbitray degrees
    install-disk-creator # Used to create macOS install USBs
    iterm2 # Alternative Terminal app
    # jetbrains-toolbox
    onyx # Computer diagnostic tool
    postman # Great API endpoint testing tool
    # robomongo # MongoDB GUI
    sequel-pro # SQL GUI
    typora # Markdown Editor
    # sitesucker #TODO: cask not found
    unity # 3D application engine
    visual-studio-code # Microsoft's lightweight text editor
    virtualbox # Virtualization
    
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
sudo pip install pylint

echo "Setting up git identity..."
git config --global user.name "$fullName"
git config --global user.email $GitEmail

# TODO: 
# echo "Generating new ssh key and uploading to GitHub..."
# echo "Enter Github token to add ssh key: "
# read github_token
# echo "Enter title for ssh key: "
# read github_title
# export github_key=`cat $HOME/.ssh/id_rsa.pub`
# curl -d "login=geetarista&token=${github_token}&title=`scutil --get ComputerName`&key=${github_key}" http://github.com/api/v2/yaml/user/key/add

echo "Cloning repositories..."
cd ~/Developer
git clone git@github.com:DylanTackoor/dotfiles.git
git clone git@github.com:DylanTackoor/dylantackoor.com.git

# TODO: run this if Xcode.app exists
# echo "Adding iOS/watchOS simulators to Launchpad..."
# sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
# sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

# TODO: Make this universal
echo "Installing NPM packages..."
npm install -g typescript gulp node-sass reload nave csvtojson js-beautify create-react-app

echo "Installing Atom plugins..."
installpackages="apm install "
packages=(
    file-icons
    pigments
    less-than-slash
    highlight-selected
    autocomplete-modules
    atom-beautify
    color-picker
    todo-show
    tokamak-terminal
    language-babel
    atom-typescript
    sass-autocompile
    language-htaccess
    linter
    linter-tidy
    linter-csslint
    linter-php
    linter-scss-lint
    linter-clang
    linter-tslint
    linter-jsonlint
    linter-pylint
    linter-shellcheck
    linter-handlebars
    minimap
    minimap-highlight-selected
    minimap-find-and-replace
    minimap-pigments
    minimap-linter
)

for package in ${packages[@]}
do
    installpackages="$installpackages $package"
done

eval $installpackages
#Check the Hide Ignored Names from your file tree so that .DS_Store and .git don't appear needlessly.
#atom-beautify HTML > indent inner html
#atom-beautify Obj-C > clang-format

echo "Installing Spacemacs..."
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
ln -s ~/Developer/dotfiles/.spacemacs ~/.spacemacs

echo "Swapping Chrome print dialogue to expanded native dialogue..."
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

echo "Configuring transmission..."
mkdir ~/Downloads/Torrenting
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true # Use `~/Downloads/Torrenting` to store incomplete downloads
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Torrenting"
defaults write org.m0k.transmission DownloadAsk -bool false # Don’t prompt for confirmation before downloading
defaults write org.m0k.transmission MagnetOpenAsk -bool false
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true # Trash original torrent files
defaults write org.m0k.transmission WarningDonate -bool false # Hide donate message
defaults write org.m0k.transmission WarningLegal -bool false # Hide legal disclaimer
# Blocks bad IPs & updates list automatically
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

echo "Cleaning up Brew..."
brew cask cleanup
brew update; brew upgrade; brew prune; brew cleanup; brew doctor

# TODO: confirm this is useful
echo "Cleaning up Garage Band..."
sudo rm -rf /Applications/GarageBand
sudo rm -rf /Library/Application Support/GarageBand
sudo rm -rf /Library/Audio/Apple Loops/Apple/Apple\ Loops\ for\ GarageBand
sudo rm -rf /Library/Receipts/com.apple.pkg.GarageBand_AppStore.bom
sudo rm -rf /Library/Receipts/com.apple.pkg.GarageBand_AppStore.plist
sudo rm -rf /System/Library/Receipts/com.apple.pkg.MAContent10_AssetPack_0325_AppleLoopsGarageBand1.bom
sudo rm -rf /System/Library/Receipts/com.apple.pkg.MAContent10_AssetPack_0325_AppleLoopsGarageBand1.plist
sudo rm -rf ~/Library/Application Scripts/com.apple.STMExtension.GarageBand
sudo rm -rf ~/library/Containers/com.apple.STMExtension.GarageBand

echo "Cleaning up Office..."
sudo rm -rf /Applications/Microsoft\ Outlook.app

echo "Alphabetizing Launchpad..."
defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock

# TODO:
# echo "Reorganizing dock..."
# sudo dockutil --remove 'Siri' --allhomes
# sudo dockutil --remove 'Mail' --allhomes
# sudo dockutil --remove 'Contacts' --allhomes
# sudo dockutil --remove 'Calendar' --allhomes
# sudo dockutil --remove 'Notes' --allhomes
# sudo dockutil --remove 'Maps' --allhomes
# sudo dockutil --remove 'FaceTime' --allhomes
# sudo dockutil --remove 'Photo Booth' --allhomes
# sudo dockutil --remove 'iPhoto' --allhomes
# sudo dockutil --remove 'Pages' --allhomes
# sudo dockutil --remove 'Numbers' --allhomes
# sudo dockutil --remove 'Keynote' --allhomes
# sudo dockutil --remove 'iBooks' --allhomes

# sudo dockutil --add /Applications/Chrome.app --after 'LaunchPad' --allhomes
# sudo dockutil --add /Applications/OneNote.app --after 'Calendar' --allhomes
# sudo dockutil --add /Applications/iTunes.app --after 'OneNote' --allhomes
# sudo dockutil --add /Applications/Slack.app --after 'iTunes' --allhomes
# sudo dockutil --add /Applications/Telegram.app --after 'Slack' --allhomes
# sudo dockutil --add /Applications/Dash.app --after 'Telegram' --allhomes
# sudo dockutil --add /Applications/Webstorm.app --after 'Dash' --allhomes
# sudo dockutil --add /Applications/Atom.app --after 'Webstorm' --allhomes
# sudo dockutil --add /Applications/iTerm.app --after 'Atom' --allhomes

echo "Defaulting to Google Chrome..."
open -a "Google Chrome" --args --make-default-browser

# TODO: Chrome open PDFs with Preview

# echo "Installing printer drivers..."
# cd ~/Downloads/ || exit
# wget http://business.toshiba.com/downloads/KB/f1Ulds/12966/TOSHIBA_ColorMFP_X7.dmg.gz
# gunzip TOSHIBA_ColorMFP_X7.dmg.gz
# sudo hdiutil attach TOSHIBA_ColorMFP_X7.dmg
# cd /Volumes/TOSHIBA\ ColorMFP || exit
# sudo installer -package /Volumes/TOSHIBA\ ColorMFP/TOSHIBA\ ColorMFP\ X7.pkg.pkg -target /
# sudo hdiutil detach /Volumes/TOSHIBA\ ColorMFP
# rm ~/Downloads/TOSHIBA_ColorMFP_X7.dmg
# # TODO: Install Printer: 147.70.69.252 - http://macstuff.beachdogs.org/blog/?p=26

# # Download/compile cs50.h
# cd ~/Downloads/ || exit
# git clone https://github.com/cs50/libcs50.git
# cd libcs50 || exit
# sudo make install
# cd ..
# rm -rf libcs50

# # Setup custom make50 command
# # TODO: make this OS/shell dependent
# echo "alias make50='make CC=clang CFLAGS=\"-ggdb3 -O0 -std=c99 -Wall -Werror\" LDLIBS=\"-lcs50 -lm\"'" >> ~/.bash_profile
# echo "alias make50='make CC=clang CFLAGS=\"-ggdb3 -O0 -std=c99 -Wall -Werror\" LDLIBS=\"-lcs50 -lm\"'" >> ~/.zshrc

echo "Setting up Powerline for ..."
cd ~ || exit
git clone https://github.com/powerline/fonts.git
cd fonts || exit
./install.sh
cd ..
rm -rf fonts

echo "Installing Oh-My-ZSH..."
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.zshrc ~/.zshrc.orig
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s /bin/zsh
# TODO: swap to agnoster theme
# TODO: remove $User@%m from theme

# Post Install
# make gfxcardstatus hidden by bartender
# remove gfxcardstatus from notification center

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
docker -v
echo "Typescript:"
tsc -v
# mongod --version

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