#!/bin/bash

clear

echo ""
echo "===================="
echo " macOS SETUP SCRIPT "
echo "===================="
echo ""

sudo -v

# Keep sudo alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Keeping Mac awake for one hour
caffeniate -d 3600 &

if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
   test -d "${xpath}" && test -x "${xpath}" ; then
   echo "Found Xcode command-line tools"
else
   echo "Installing command-line tools..."
   xcode-select --install
   read -n 1 -s -p "Once installed, press any key to continue"
fi

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

echo "Enabling Safari developer options..."
defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
defaults write -g WebKitDeveloperExtras -bool true

# TODO
# echo "Forcing Airdrop to always be on..."

echo "Dimming hidden Dock icons..."
defaults write com.apple.Dock showhidden -bool YES && killall Dock

echo "Disabling Gatekeeper..."
sudo spctl --master-disable
spctl --status

echo "Disabling Gatekeeper..."
defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool false

echo "Setting lockscreen message..."
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "This Mac belongs to The Idea Center @ MDC. Contact us at ideacenter@mdc.edu."

echo "Enabling tap to click for this user & login screen..."
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Upping bluetooth audio quality..."
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool Min (editable)" 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool" 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Max" 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Min" 80
sudo killall coreaudiod

echo "Expanding save panel by default..."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Disabling automatically rearranging spaces..."
defaults write com.apple.dock mru-spaces -bool false

echo "Require password immediately after sleep..."
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "Enabling Ctrl + scroll to zoom screen..."
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

echo "Disabling Dashboard..."
defaults write com.apple.dashboard mcx-disabled -bool true
defaults write com.apple.dock dashboard-in-overlay -bool true

echo "Column view by default..."
defaults write com.apple.Finder FXPreferredViewStyle clmv

echo "Enabling copy emails as plaintext from Mail.app..."
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

echo "Searching current dir by default..."
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Avoiding creation of .DS_Store files on network or USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# TODO: 4 finger dragging
# TODO: Enable all trackpad gestures

# TODO: Enable play feedback when volume is changed

echo "Starting iCal on Monday..."
defaults write com.apple.iCal "first day of week" -int 1

echo "Enabling \"Do Not Track\" on Safari..."
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

echo "Disabling parental controls on guest user..."
sudo dscl . -mcxdelete /Users/guest
sudo rm -rf /Library/Managed\ Preferences/guest

echo "Disabling opening application prompt..."
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "Setting up folders..."
mkdir ~/Developer/
mkdir ~/Pictures/Wallpapers/

echo "Setting wallpaper..."
cd ~/Pictures/Wallpapers/ || exit
wget https://pbs.twimg.com/profile_images/512339511234138112/e8kahiP9.jpeg
mv e8kahiP9.jpeg tic.jpeg
sudo osascript -e '
  tell application "System Events"
      set theDesktops to a reference to every desktop
      repeat with x from 1 to (count theDesktops)
          set picture of item x of the theDesktops to "~/Pictures/Wallpapers/tic.jpeg"
      end repeat
  end tell
'

echo "Enabling daily autoupdates..."
defaults write com.apple.commerce AutoUpdate -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo "Updating system..."
softwareupdate -l && sudo softwareupdate -i

echo "Installing Brew and command-line applications..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" #fixes permission error w/nodejs
brew install cask
brew install cowsay
brew install dockutil
brew install ffmpeg #Allows mp3 ripping for youtube-dl
brew install htop
brew install neofetch
brew install python
brew install python3
brew install shellcheck
brew install speedtest_cli
brew install tidy-html5 # Atom html Linter
brew install tree
brew install unrar
brew install wget
brew install youtube-dl
brew install mas
#Brew update checker with notification center support
curl -s https://raw.githubusercontent.com/stephennancekivell/brew-update-notifier/master/install.sh | sh

echo "Signing into Mac App Store..."
mas signin ideacenter@mdc.edu #"passwordInQuotes"

echo "Updating Mac App Store apps..."
mas upgrade

echo "Installing Mac App Store apps..."
mas install 803453959 #Slack
mas install 436203431 #XnConvert
mas install 747633105 #Minify
mas install 768053424 #Gapplin
mas install 408981434 #iMovie

echo "Installing cask apps..."
brew tap caskroom/cask
brew cask install java
brew cask install android-file-transfer
brew cask install arduino
brew cask install atom
brew cask install caffeine
brew cask install cyberduck
brew cask install dash
brew cask install etcher
brew cask install firefox
brew cask install google-chrome
brew cask install handbrake
brew cask install imageoptim
brew cask install install-disk-creator
brew cask install mamp
brew cask install minecraft
brew cask install monolingual
brew cask install obs
brew cask install onyx
brew cask install robomongo
brew cask install sequel-pro
brew cask install skype
brew cask install sitesucker
brew cask install teamviewer
brew cask install the-unarchiver
brew cask install vlc
brew cask install virtualbox
brew cask install virtualbox-extension-pack
brew cask install adobe-creative-cloud
brew cask install adobe-illustrator-cc
brew cask install adobe-indesign-cc
brew cask install adobe-photoshop-cc
brew cask install adobe-photoshop-lightroom
brew cask install adobe-premiere-pro-cc
brew cask install adobe-reader
brew cask install brackets
brew cask install macvim
brew cask install sublime-text
brew cask install visual-studio
brew cask install visual-studio-code
brew cask install xamarin
brew cask install xamarin-android
brew cask install xamarin-android-player
brew cask install xamarin-ios
brew cask install xamarin-jdk
brew cask install xamarin-mdk
brew cask install xamarin-studio
brew cask install github-desktop
brew cask install mysqlworkbench
brew cask install unity
brew cask install unity-android-support-for-editor
brew cask install unity-download-assistant
brew cask install unity-ios-support-for-editor
brew cask install unity-linux-support-for-editor
brew cask install unity-standard-assets
brew cask install unity-web-player
brew cask install unity-webgl-support-for-editor
brew cask install unity-windows-support-for-editor

echo "Installing quicklook plugins..."
brew cask install qlcolorcode
brew cask install qlvideo
brew cask install quicklook-csv
brew cask install quicklook-json
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install qlprettypatch
brew cask install qlimagesize
brew cask install betterzipql
brew cask install webpquicklook
brew cask install suspicious-package
brew cask install provisionql
brew cask install quicklookapk
brew cask install quicklookase

echo "Installing Node.js global packages..."
sudo npm install typescript gulp npm-check node-sass mocha unibeautify-cli reload changelog nave @angular/cli -g

echo "Installing Node.js"
curl "https://nodejs.org/dist/latest/node-${VERSION:-$(wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')}.pkg" > "$HOME/Downloads/node-latest.pkg" && sudo installer -store -pkg "$HOME/Downloads/node-latest.pkg" -target "/"

echo "Installing multiple Node.js versions..."
nave install latest
nave install lts
nave install 6.9.0 #for Ghost blog

echo "Installing Atom plugins..."
apm install file-icons pigments less-than-slash highlight-selected autocomplete-modules atom-beautify auto-update-packages color-picker todo-show git-time-machine
apm install language-babel atom-typescript sass-autocompile language-ejs language-htaccess
apm install linter linter-tidy linter-csslint linter-php linter-scss-lint linter-clang linter-tslint linter-jsonlint linter-pylint linter-shellcheck linter-handlebars
apm install minimap minimap-highlight-selected minimap-find-and-replace minimap-pigments minimap-linter
#Check the Hide Ignored Names from your file tree so that .DS_Store and .git don't appear needlessly.

echo "Swapping Chrome print dialogue to expanded native dialogue..."
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

echo "Cleaning up..."
brew cask cleanup
brew update; brew upgrade; brew prune; brew cleanup; brew doctor

echo "Alphabetizing Launchpad..."
defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock

# TODO
echo "Reorganizing dock..."
sudo dockutil --remove 'Mail' --allhomes
sudo dockutil --remove 'Contacts' --allhomes
sudo dockutil --remove 'Calendar' --allhomes
sudo dockutil --remove 'Notes' --allhomes
sudo dockutil --remove 'FaceTime' --allhomes
sudo dockutil --remove 'Photo Booth' --allhomes
sudo dockutil --remove 'iPhoto' --allhomes
sudo dockutil --remove 'iBooks' --allhomes

sudo dockutil --add /Applications/Chrome.app --after 'Safari' --allhomes

echo "Installing Oh-My-ZSH..."
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
