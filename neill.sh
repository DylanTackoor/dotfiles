#!/bin/bash

clear

echo "===================="
echo " macOS SETUP SCRIPT "
echo "===================="
echo ""

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
defaults write com.apple.PowerChime ChimeOnAllHardware -bool true
open /System/Library/CoreServices/PowerChime.app &

echo "Syncing time..."
sudo ntpdate -u time.apple.com

echo "Enabling keyrepeat globally..."
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "Enabling Safari developer options..."
defaults write com.apple.Safari IncludeDevelopMenu -bool true &&
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true &&
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true &&
  defaults write -g WebKitDeveloperExtras -bool true

echo "Dimming hidden Dock icons..."
defaults write com.apple.Dock showhidden -bool YES && killall Dock

echo "Disabling Gatekeeper..."
sudo spctl --master-disable
spctl --status

# TODO: update name
echo "Setting lockscreen message..."
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "This Mac belongs to Dylan Tackoor. Contact at 786-471-5379 or mynameisdylantackoor@gmail.com"

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
defaults write -g KeyRepeat -int 2

echo "Searching current dir by default..."
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Avoiding creation of .DS_Store files on network or USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "Starting iCal on Monday..."
defaults write com.apple.iCal "first day of week" -int 1

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

echo "Changing screenshot location..."
defaults write com.apple.screencapture location ~/Pictures/Screenshots/ && killall SystemUIServer

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

# TODO: update this url
echo "Cloning..."
git clone https://github.com/DylanTackoor/dotfiles.git ~/.dotfiles

echo "Linking config files..."
ln -s ~/.dotfiles/photos/wallpapers ~/Pictures/Wallpapers
ln -s ~/.dotfiles/config/.zshrc ~/.zshrc
ln -s ~/.dotfiles/config/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/config/.gitignore_global ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
git config --list

echo "Installing command-line applications..."
brew install htop          # Terminal activity monitor
brew install neofetch      # Displays system info
brew install shellcheck    # Bash file linting
brew install speedtest_cli # Speedtest.net cli
brew install tldr          # man pages for humans
brew install tree          # Prints filetree
brew install unrar         # rar archive cli
brew install wget
brew install youtube-dl    # YouTube Downloader
brew install wifi-password #CLI to pull up currently connected wifi's password
brew install cowsay

echo "Installing casks..."
brew cask install bartender # Hides menu bar icons
brew cask install dash      # Offline documentation downloader/indexer w/IDE plugins
brew cask install firefox
brew cask install gfxcardstatus          # Notifications when graphics card changes
brew cask install google-backup-and-sync # New Google Drive client
brew cask install google-chrome
brew cask install iterm2 # Alternative Terminal app
brew cask install microsoft-office
brew cask install postman          # Great API endpoint testing tool
brew cask install sequel-pro       # SQL GUI
brew cask install signal           # Encrypted chat
brew cask install telegram-desktop # Chat service
brew cask install the-unarchiver
brew cask install typora             # Markdown Editor
brew cask install virtualbox         # Virtualization
brew cask install vlc                # Plays almost any video/audio filetype
brew cask install visual-studio-code # text editor
brew cask install flycut             # clipboard history
brew cask install spectacle
brew cask install qladdict    # Subtitle srt files
brew cask install qlcolorcode # Syntax highlighted sourcecode
brew cask install qlvideo
brew cask install quicklook-csv
brew cask install quicklook-json
brew cask install qlstephen # Plain text files without or with unknown file extension. Example: README, CHANGELOG, index.styl, etc.
brew cask install qlmarkdown
brew cask install qlimagesize # Displays image size in preview
brew cask install betterzipql
brew cask install webpquicklook # Google's Webp image format
brew cask install provisionql
brew cask install quicklookapk

echo "Setting up Visual Studio Code..."
mkdir -p ~/.config/Code/User/
ln -s ~/.dotfiles/config/vscode/keybindings-ubuntu.json ~/.config/Code/User/keybindings.json
ln -s ~/.dotfiles/config/vscode/settings.json ~/.config/Code/User/settings.json
ln -s ~/.dotfiles/config/vscode/snippets ~/.config/Code/User/snippets

echo "Adding VSCode extensions..."
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension dbaeumer.vscode-eslint
code --install-extension deerawan.vscode-dash
code --install-extension eamodio.gitlens
code --install-extension eg2.vscode-npm-script
code --install-extension esbenp.prettier-vscode
code --install-extension fabiospampinato.vscode-todo-plus
code --install-extension felipe.nasc-touchbar
code --install-extension foxundermoon.shell-format
code --install-extension jpoissonnier.vscode-styled-components
code --install-extension kisstkondoros.vscode-codemetrics
code --install-extension kumar-harsh.graphql-for-vscode
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension pflannery.vscode-versionlens
code --install-extension ryu1kn.partial-diff
code --install-extension Shan.code-settings-sync
code --install-extension shardulm94.trailing-spaces
code --install-extension stevencl.addDocComments
code --install-extension stubailo.ignore-gitignore
code --install-extension Tyriar.sort-lines
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension vscode-icons-team.vscode-icons
code --install-extension vscodevim.vim
code --install-extension WakaTime.vscode-wakatime
code --install-extension wix.vscode-import-cost

echo "Swapping Chrome print dialogue to expanded native dialogue..."
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

echo "Cleaning up Brew..."
brew update
brew upgrade
brew prune
brew cleanup

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

echo "Cleaning up Office..."
sudo rm -rf /Applications/Microsoft\ Outlook.app

echo "Alphabetizing Launchpad..."
defaults write com.apple.dock ResetLaunchPad -bool true
killall Dock

echo "Defaulting to Google Chrome..."
open -a "Google Chrome" --args --make-default-browser

echo "Installing Oh-My-ZSH..."

echo "ZSH Plugins"
git clone https://github.com/lukechilds/zsh-nvm "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-nvm"
git clone https://github.com/iam4x/zsh-iterm-touchbar.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-iterm-touchbar"

echo ""
echo "===================="
echo " THAT'S ALL, FOLKS! "
echo "===================="
echo ""

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
  exit 1
fi