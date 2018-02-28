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
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "This Mac belongs to Gerg Oterrab. Contact at 786-471-5379 or mynameisdylantackoor@gmail.com"

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
git clone git@github.com:DylanTackoor/dotfiles.git
# git clone git@github.com:DylanTackoor/dylantackoor.com.git

echo "Linking config files..."
ln -s ~/Developer/dotfiles/config/.zshrc ~/.zshrc
# TODO: verify this works before vscode install
ln -s ~/Developer/dotfiles/config/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s ~/Developer/dotfiles/config/.gitignore_config ~/.gitignore_config
ln -s ~/Developer/dotfiles/config/.gitignore_global ~/.gitignore_global
ln -s ~/Developer/dotfiles/config/.gitconfig ~/.gitconfig
ln -s ~/Developer/dotfiles/config/.eslintrc.js ~/.eslintrc.js # Provides syntax rules for js without local eslintrc.js

# echo "Installing Spacemacs prereqs..."
# # TODO: Refactor if possible
# brew tap d12frosted/emacs-plus
# brew tap caskroom/fonts
# brew cask install font-source-code-pro
# brew install emacs-plus --HEAD --with-natural-title-bars
# brew linkapps emacs-plus

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
    wifi-password #CLI to pull up currently connected wifi's password\
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
mas upgrade

echo "Installing Mac App Store apps..."
mas install 497799835  #Xcode
mas install 436203431  #XnConvert
mas install 747633105  #Minify = HTML/CSS/JS minifier
mas install 768053424  #Gapplin = SVG Viewer
mas install 568494494  #Pocket
mas install 1163798887 #Savage = SVG optimizer

echo "Installing casks..."
brew tap caskroom/cask
installCasks="brew cask install "
casks=(
    4k-slideshow-maker
    4k-stogram
    4k-video-downloader
    4k-video-to-mp3
    4k-youtube-to-mp3
    4peaks
    ableton-live-suite
    acousticbrainz-gui
    adobe-creative-cloud
    android-file-transfer
    atom
    caffeine
    dash
    djay-pro
    dropbox
    firefox
    flash-player
    flux
    font-3270
    font-3270-nerd-font
    font-3270-nerd-font-mono
    font-abeezee
    font-abel
    font-aboriginal-sans
    font-aboriginal-serif
    font-abril-fatface
    font-accordance
    font-aclonica
    font-acme
    font-actor
    font-adamina
    font-adinatha-tamil-brahmi
    font-advent-pro
    font-african-sans
    font-african-serif
    font-aguafina-script
    font-ahuramzda
    font-aileron
    font-akronim
    font-aladin
    font-aldrich
    font-alef
    font-alegreya
    font-alegreya-sans
    font-aleo
    font-alex-brush
    font-alfa-slab-one
    font-alice
    font-alike
    font-alike-angular
    font-allan
    font-allerta
    font-allerta-stencil
    font-allura
    font-almendra
    font-almendra-display
    font-almendra-sc
    font-amarante
    font-amaranth
    font-amatic-sc
    font-amethysta
    font-amiri
    font-anaheim
    font-andada
    font-andada-sc
    font-andagii
    font-andale-mono
    font-andika
    font-angkor
    font-anka-coder
    font-annie-use-your-telescope
    font-anonymice-powerline
    font-anonymous-pro
    font-anonymouspro-nerd-font
    font-anonymouspro-nerd-font-mono
    font-antic
    font-antic-didone
    font-antic-slab
    font-antinoou
    font-anton
    font-arapey
    font-arbutus
    font-arbutus-slab
    font-architects-daughter
    font-archivo-black
    font-archivo-narrow
    font-arial
    font-arial-black
    font-arimo
    font-arimo-nerd-font
    font-arimo-nerd-font-mono
    font-arizonia
    font-armata
    font-artifika
    font-arvo
    font-asap
    font-asset
    font-astloch
    font-asul
    font-atomic-age
    font-aubrey
    font-audiowide
    font-aurulentsansmono-nerd-font
    font-aurulentsansmono-nerd-font-mono
    font-autour-one
    font-average
    font-average-mono
    font-average-sans
    font-averia-gruesa-libre
    font-averia-libre
    font-averia-sans-libre
    font-averia-serif-libre
    font-awesome-terminal-fonts
    font-babelstone-han
    font-bad-script
    font-baloo
    font-balthazar
    font-bangers
    font-barlow
    font-baron
    font-basic
    font-battambang
    font-baumans
    font-bayon
    font-bebas-neue
    font-belgrano
    font-belleza
    font-benchnine
    font-bentham
    font-berkshire-swash
    font-bevan
    font-bf-tiny-hand
    font-bigelow-rules
    font-bigshot-one
    font-bilbo
    font-bilbo-swash-caps
    font-bitstream-vera
    font-bitstreamverasansmono-nerd-font
    font-bitstreamverasansmono-nerd-font-mono
    font-bitter
    font-black-ops-one
    font-blockzone
    font-blokk-neue
    font-bokor
    font-bonbon
    font-boogaloo
    font-bowlby-one
    font-bowlby-one-sc
    font-bravura
    font-brawler
    font-bree-serif
    font-bubblegum-sans
    font-bubbler-one
    font-buda
    font-buenard
    font-bukyvede-bold
    font-bukyvede-italic
    font-bukyvede-regular
    font-bungee
    font-butcherman
    font-butler
    font-butterfly-kids
    font-cabin
    font-cabin-condensed
    font-cabin-sketch
    font-caesar-dressing
    font-cagliostro
    font-calligraffitti
    font-cambo
    font-camingocode
    font-candal
    font-cantarell
    font-cantata-one
    font-canter
    font-cantora-one
    font-capriola
    font-cardo
    font-carme
    font-carrois-gothic
    font-carrois-gothic-sc
    font-carter-one
    font-caudex
    font-cedarville-cursive
    font-ceviche-one
    font-changa-one
    font-chango
    font-chapbook
    font-charis-sil
    font-charter
    font-chau-philomene-one
    font-chela-one
    font-chelsea-market
    font-chenla
    font-cherry-cream-soda
    font-cherry-swash
    font-chewy
    font-chicle
    font-chivo
    font-cica
    font-cinzel
    font-cinzel-decorative
    font-clear-sans
    font-clicker-script
    font-coda
    font-coda-caption
    font-code
    font-code2000
    font-code2001
    font-code2002
    font-codenewroman-nerd-font
    font-codenewroman-nerd-font-mono
    font-codystar
    font-combo
    font-comfortaa
    font-comic-neue
    font-comic-sans-ms
    font-coming-soon
    font-computer-modern
    font-conakry
    font-concert-one
    font-condiment
    font-consolas-for-powerline
    font-constructium
    font-content
    font-contrail-one
    font-convergence
    font-cookie
    font-cooper-hewitt
    font-copse
    font-corben
    font-cormorant
    font-courgette
    font-courier-new
    font-courier-prime
    font-courier-prime-code
    font-courier-prime-medium-and-semi-bold
    font-courier-prime-sans
    font-cousine
    font-cousine-nerd-font
    font-cousine-nerd-font-mono
    font-coustard
    font-covered-by-your-grace
    font-crafty-girls
    font-creepster
    font-crete-round
    font-crimson-text
    font-croissant-one
    font-crushed
    font-cuprum
    font-cutive
    font-cutive-mono
    font-cwtex-q
    font-d2coding
    font-damion
    font-dana-yad
    font-dancing-script
    font-dangrek
    font-dashicons
    font-dawning-of-a-new-day
    font-days-one
    font-dejavu-sans
    font-dejavu-sans-mono-for-powerline
    font-dejavusansmono-nerd-font
    font-dejavusansmono-nerd-font-mono
    font-delius
    font-delius-swash-caps
    font-delius-unicase
    font-della-respira
    font-denk-one
    font-devicons
    font-devonshire
    font-dhyana
    font-didact-gothic
    font-digohweli
    font-digohweli-old-do
    font-diplomata
    font-diplomata-sc
    font-disclaimer
    font-domine
    font-donegal-one
    font-doppio-one
    font-dorsa
    font-dosis
    font-doulos-sil
    font-dr-sugiyama
    font-droid-sans-mono-for-powerline
    font-droidsansmono-nerd-font
    font-droidsansmono-nerd-font-mono
    font-dukor
    font-duru-sans
    font-dynalight
    font-eagle-lake
    font-eater
    font-eb-garamond
    font-economica
    font-edlo
    font-eeyek-unicode
    font-electrolize
    font-elsie
    font-elsie-swash-caps
    font-emblema-one
    font-emilys-candy
    font-engagement
    font-englebert
    font-enriqueta
    font-envy-code-r
    font-erica-one
    font-esteban
    font-et-book
    font-euphoria-script
    font-everson-mono
    font-ewert
    font-exo
    font-exo2
    font-expletus-sans
    font-ezra-sil
    font-fairfax
    font-fantasque-sans-mono
    font-fantasquesansmono-nerd-font
    font-fantasquesansmono-nerd-font-mono
    font-fanwood-text
    font-fascinate
    font-fascinate-inline
    font-faster-one
    font-fasthand
    font-fauna-one
    font-federant
    font-federo
    font-felipa
    font-fenix
    font-finger-paint
    font-fira-code
    font-fira-mono
    font-fira-mono-for-powerline
    font-fira-sans
    font-firacode-nerd-font
    font-firacode-nerd-font-mono
    font-firamono-nerd-font
    font-firamono-nerd-font-mono
    font-fjalla-one
    font-fjord-one
    font-flamenco
    font-flavors
    font-fondamento
    font-fontawesome
    font-fontdiner-swanky
    font-forum
    font-foundation-icons
    font-francois-one
    font-freckle-face
    font-fredericka-the-great
    font-fredoka-one
    font-free-hk-kai
    font-freehand
    font-freesans
    font-fresca
    font-frijole
    font-fruktur
    font-fugaz-one
    font-gabriela
    font-gafata
    font-galdeano
    font-galindo
    font-gandom
    font-genjyuugothic
    font-genjyuugothic-l
    font-genjyuugothic-x
    font-genshingothic
    font-gentium-basic
    font-gentium-book-basic
    font-gentium-plus
    font-geo
    font-georgia
    font-geostar
    font-geostar-fill
    font-germania-one
    font-gfs-didot
    font-gfs-neohellenic
    font-gidole
    font-gilda-display
    font-give-you-glory
    font-glass-antiqua
    font-glegoo
    font-glober
    font-gloria-hallelujah
    font-gnu-unifont
    font-go
    font-go-medium
    font-go-mono
    font-go-mono-nerd-font
    font-go-mono-nerd-font-mono
    font-goblin-one
    font-gochi-hand
    font-gohu-nerd-font
    font-gohu-nerd-font-mono
    font-gorditas
    font-goudy-bookletter1911
    font-graduate
    font-grand-hotel
    font-gravitas-one
    font-great-vibes
    font-griffy
    font-gruppo
    font-gudea
    font-gveret-levin
    font-habibi
    font-hack
    font-hack-nerd-font
    font-hack-nerd-font-mono
    font-halant
    font-hammersmith-one
    font-han-nom-a
    font-hanalei
    font-hanalei-fill
    font-hanamina
    font-handlee
    font-hanuman
    font-happy-monkey
    font-hasklig
    font-hasklig-nerd-font
    font-hasklig-nerd-font-mono
    font-headland-one
    font-heavydata-nerd-font
    font-heavydata-nerd-font-mono
    font-henny-penny
    font-hermeneus-one
    font-hermit
    font-hermit-nerd-font
    font-hermit-nerd-font-mono
    font-herr-von-muellerhoff
    font-hind
    font-holtwood-one-sc
    font-homemade-apple
    font-homenaje
    font-humor-sans
    font-hyppolit
    font-ia-writer-duospace
    font-ibm-plex
    font-iceberg
    font-iceland
    font-icomoon
    font-idealist-sans
    font-im-fell-double-pica
    font-im-fell-double-pica-sc
    font-im-fell-dw-pica
    font-im-fell-dw-pica-sc
    font-im-fell-english
    font-im-fell-english-sc
    font-im-fell-french-canon
    font-im-fell-french-canon-sc
    font-im-fell-great-primer
    font-im-fell-great-primer-sc
    font-impact
    font-imprima
    font-inconsolata
    font-inconsolata-dz
    font-inconsolata-dz-for-powerline
    font-inconsolata-for-powerline
    font-inconsolata-g-for-powerline
    font-inconsolata-lgc
    font-inconsolata-nerd-font
    font-inconsolata-nerd-font-mono
    font-inconsolatago-nerd-font
    font-inconsolatago-nerd-font-mono
    font-inconsolatalgc-nerd-font
    font-inconsolatalgc-nerd-font-mono
    font-inder
    font-indie-flower
    font-inika
    font-input
    font-inria
    font-inter-ui
    font-ionicons
    font-iosevka
    font-iosevka-nerd-font
    font-iosevka-nerd-font-mono
    font-iranian-sans
    font-iranian-serif
    font-irish-grover
    font-istok-web
    font-italiana
    font-italianno
    font-jaapokki
    font-jacques-francois
    font-jacques-francois-shadow
    font-jim-nightshade
    font-jockey-one
    font-jolly-lodger
    font-josefin-sans
    font-josefin-slab
    font-joti-one
    font-jsmath-cmbx10
    font-judson
    font-julee
    font-julius-sans-one
    font-junction
    font-junge
    font-junicode
    font-jura
    font-just-another-hand
    font-just-me-again-down-here
    font-kacstone
    font-kalam
    font-kameron
    font-kantumruy
    font-karla
    font-karla-tamil-inclined
    font-karla-tamil-upright
    font-karma
    font-kaushan-script
    font-kavoon
    font-kawkab-mono
    font-kayases
    font-kdam-thmor
    font-keania-one
    font-keep-calm
    font-kelly-slab
    font-kenia
    font-khand
    font-khmer
    font-kisiska
    font-kite-one
    font-knewave
    font-koruri
    font-kotta-one
    font-koulen
    font-kranky
    font-kreon
    font-kristi
    font-krona-one
    font-la-belle-aurore
    font-laila
    font-lalezar
    font-lancelot
    font-langdon
    font-lateef
    font-latin-modern
    font-latin-modern-math
    font-lato
    font-league-gothic
    font-league-script
    font-league-spartan
    font-leckerli-one
    font-ledger
    font-lekton
    font-lekton-nerd-font
    font-lekton-nerd-font-mono
    font-lemon
    font-liberation-mono-for-powerline
    font-liberation-sans
    font-liberationmono-nerd-font
    font-liberationmono-nerd-font-mono
    font-libertinus
    font-libre-baskerville
    font-libre-caslon-display
    font-libre-caslon-text
    font-libre-franklin
    font-life-savers
    font-ligature-symbols
    font-lilita-one
    font-lily-script-one
    font-limelight
    font-linden-hill
    font-linux-biolinum
    font-linux-libertine
    font-lisutzimu
    font-lobster
    font-lobster-two
    font-londrina-outline
    font-londrina-shadow
    font-londrina-sketch
    font-londrina-solid
    font-lora
    font-love-ya-like-a-sister
    font-loved-by-the-king
    font-lovers-quarrel
    font-luckiest-guy
    font-luculent
    font-lusitana
    font-lustria
    font-m-plus
    font-macondo
    font-macondo-swash-caps
    font-magra
    font-maiden-orange
    font-mako
    font-marcellus
    font-marcellus-sc
    font-marck-script
    font-margarine
    font-marko-one
    font-marmelad
    font-marta
    font-marvel
    font-masinahikan
    font-masinahikan-dene
    font-mate
    font-mate-sc
    font-material-icons
    font-materialdesignicons-webfont
    font-maven-pro
    font-mclaren
    font-meddon
    font-medievalsharp
    font-medula-one
    font-megrim
    font-meie-script
    font-menlo-for-powerline
    font-merienda
    font-merienda-one
    font-merriweather
    font-merriweather-sans
    font-meslo-for-powerline
    font-meslo-lg
    font-meslo-nerd-font
    font-meslo-nerd-font-mono
    font-metal
    font-metal-mania
    font-metamorphous
    font-metrophobic
    font-metropolis
    font-mfizz
    font-miao-unicode
    font-michroma
    font-migmix-1m
    font-migmix-1p
    font-migmix-2m
    font-migmix-2p
    font-migu-1c
    font-migu-1m
    font-migu-1p
    font-migu-2m
    font-milonga
    font-miltonian
    font-miltonian-tattoo
    font-miniver
    font-miss-fajardose
    font-modern-antiqua
    font-molengo
    font-molle
    font-monda
    font-monofett
    font-monofur
    font-monofur-for-powerline
    font-monofur-nerd-font
    font-monofur-nerd-font-mono
    font-monoid
    font-monoid-nerd-font
    font-monoid-nerd-font-mono
    font-monoisome
    font-mononoki
    font-mononoki-nerd-font
    font-mononoki-nerd-font-mono
    font-monoton
    font-monsieur-la-doulaise
    font-montaga
    font-montez
    font-montserrat
    font-montserrat-subrayada
    font-moul
    font-moulpali
    font-mountains-of-christmas
    font-mouse-memoirs
    font-mplus-nerd-font
    font-mplus-nerd-font-mono
    font-mr-bedfort
    font-mr-dafoe
    font-mr-de-haviland
    font-mrs-saint-delafield
    font-mrs-sheppards
    font-mukti-narrow
    font-muli
    font-myrica
    font-myricam
    font-mystery-quest
    font-n-gage
    font-namdhinggo-sil
    font-nanumgothic
    font-nanumgothiccoding
    font-nanummyeongjo
    font-neucha
    font-neuton
    font-new-athena-unicode
    font-new-rocker
    font-news-cycle
    font-nexa
    font-nexa-rust
    font-niconne
    font-nika
    font-nixie-one
    font-nobile
    font-nokora
    font-norican
    font-norwester
    font-nosifer
    font-nothing-you-could-do
    font-noticia-text
    font-noto-color-emoji
    font-noto-emoji
    font-noto-kufi-arabic
    font-noto-mono
    font-noto-mono-for-powerline
    font-noto-naskh-arabic
    font-noto-nastaliq-urdu
    font-noto-sans
    font-noto-sans-adlam
    font-noto-sans-adlam-unjoined
    font-noto-sans-anatolian-hieroglyphs
    font-noto-sans-arabic
    font-noto-sans-armenian
    font-noto-sans-avestan
    font-noto-sans-balinese
    font-noto-sans-bamum
    font-noto-sans-batak
    font-noto-sans-bengali
    font-noto-sans-brahmi
    font-noto-sans-buginese
    font-noto-sans-buhid
    font-noto-sans-canadian-aboriginal
    font-noto-sans-carian
    font-noto-sans-chakma
    font-noto-sans-cham
    font-noto-sans-cherokee
    font-noto-sans-cjk
    font-noto-sans-cjk-jp
    font-noto-sans-cjk-kr
    font-noto-sans-cjk-sc
    font-noto-sans-cjk-tc
    font-noto-sans-coptic
    font-noto-sans-cuneiform
    font-noto-sans-cypriot
    font-noto-sans-deseret
    font-noto-sans-devanagari
    font-noto-sans-display
    font-noto-sans-egyptian-hieroglyphs
    font-noto-sans-ethiopic
    font-noto-sans-georgian
    font-noto-sans-glagolitic
    font-noto-sans-gothic
    font-noto-sans-gujarati
    font-noto-sans-gurmukhi
    font-noto-sans-hanunoo
    font-noto-sans-hebrew
    font-noto-sans-imperial-aramaic
    font-noto-sans-inscriptional-pahlavi
    font-noto-sans-inscriptional-parthian
    font-noto-sans-javanese
    font-noto-sans-kaithi
    font-noto-sans-kannada
    font-noto-sans-kayah-li
    font-noto-sans-kharoshthi
    font-noto-sans-khmer
    font-noto-sans-lao
    font-noto-sans-lepcha
    font-noto-sans-limbu
    font-noto-sans-linear-b
    font-noto-sans-lisu
    font-noto-sans-lycian
    font-noto-sans-lydian
    font-noto-sans-malayalam
    font-noto-sans-mandaic
    font-noto-sans-meetei-mayek
    font-noto-sans-mongolian
    font-noto-sans-mono
    font-noto-sans-myanmar
    font-noto-sans-n-ko
    font-noto-sans-new-tai-lue
    font-noto-sans-ogham
    font-noto-sans-ol-chiki
    font-noto-sans-old-italic
    font-noto-sans-old-persian
    font-noto-sans-old-south-arabian
    font-noto-sans-old-turkic
    font-noto-sans-oriya
    font-noto-sans-osage
    font-noto-sans-osmanya
    font-noto-sans-phags-pa
    font-noto-sans-phoenician
    font-noto-sans-rejang
    font-noto-sans-runic
    font-noto-sans-samaritan
    font-noto-sans-saurashtra
    font-noto-sans-shavian
    font-noto-sans-sinhala
    font-noto-sans-sundanese
    font-noto-sans-syloti-nagri
    font-noto-sans-symbols
    font-noto-sans-symbols2
    font-noto-sans-syriac-eastern
    font-noto-sans-syriac-estrangela
    font-noto-sans-syriac-western
    font-noto-sans-tagalog
    font-noto-sans-tagbanwa
    font-noto-sans-tai-le
    font-noto-sans-tai-tham
    font-noto-sans-tai-viet
    font-noto-sans-tamil
    font-noto-sans-telugu
    font-noto-sans-thaana
    font-noto-sans-thai
    font-noto-sans-tibetan
    font-noto-sans-tifinagh
    font-noto-sans-ugaritic
    font-noto-sans-vai
    font-noto-sans-yi
    font-noto-serif
    font-noto-serif-armenian
    font-noto-serif-bengali
    font-noto-serif-cjk
    font-noto-serif-cjk-jp
    font-noto-serif-cjk-kr
    font-noto-serif-cjk-sc
    font-noto-serif-cjk-tc
    font-noto-serif-devanagari
    font-noto-serif-display
    font-noto-serif-ethiopic
    font-noto-serif-georgian
    font-noto-serif-gujarati
    font-noto-serif-hebrew
    font-noto-serif-kannada
    font-noto-serif-khmer
    font-noto-serif-lao
    font-noto-serif-malayalam
    font-noto-serif-myanmar
    font-noto-serif-sinhala
    font-noto-serif-tamil
    font-noto-serif-telugu
    font-noto-serif-thai
    font-nova-cut
    font-nova-flat
    font-nova-mono
    font-nova-oval
    font-nova-round
    font-nova-script
    font-nova-slim
    font-nova-square
    font-numans
    font-nunito
    font-nyashi
    font-ocr
    font-odor-mean-chey
    font-office-code-pro
    font-offside
    font-old-standard-tt
    font-oldenburg
    font-oleo-script
    font-oleo-script-swash-caps
    font-open-iconic
    font-open-sans
    font-open-sans-condensed
    font-open-sans-hebrew
    font-open-sans-hebrew-condensed
    font-opendyslexic
    font-oranienbaum
    font-orbitron
    font-oregano
    font-orienta
    font-original-surfer
    font-oskiblackfoot
    font-oskidakelh
    font-oskidenea
    font-oskideneb
    font-oskidenec
    font-oskidenes
    font-oskieast
    font-oskiwest
    font-ostrich-sans
    font-oswald
    font-over-the-rainbow
    font-overlock
    font-overlock-sc
    font-overpass
    font-ovo
    font-oxygen
    font-oxygen-mono
    font-pacifico
    font-padauk
    font-palemonas
    font-paprika
    font-parastoo
    font-parisienne
    font-passero-one
    font-passion-one
    font-pathway-gothic-one
    font-patrick-hand
    font-patrick-hand-sc
    font-patua-one
    font-paytone-one
    font-penuturesu
    font-peralta
    font-permanent-marker
    font-petit-formal-script
    font-petrona
    font-phetsarath
    font-philosopher
    font-piedra
    font-pinyon-script
    font-pirata-one
    font-pitabek
    font-plaster
    font-play
    font-playball
    font-playfair-display
    font-playfair-display-sc
    font-podkova
    font-poetsenone
    font-poiret-one
    font-poller-one
    font-poly
    font-pompiere
    font-pontano-sans
    font-poppins
    font-port-lligat-sans
    font-port-lligat-slab
    font-prata
    font-preahvihear
    font-press-start2p
    font-prime
    font-prince-valiant
    font-princess-sofia
    font-prociono
    font-profont-nerd-font
    font-profont-nerd-font-mono
    font-profont-windows-tweaked
    font-profontx
    font-proggyclean-nerd-font
    font-proggyclean-nerd-font-mono
    font-prosto-one
    font-proza-libre
    font-pt-mono
    font-pt-sans
    font-pt-serif
    font-puritan
    font-purple-purse
    font-px437-pxplus
    font-qataban
    font-quando
    font-quantico
    font-quattrocento
    font-quattrocento-sans
    font-questrial
    font-quicksand
    font-quintessential
    font-quivira
    font-qwigley
    font-racing-sans-one
    font-radley
    font-rajdhani
    font-raleway
    font-raleway-dots
    font-rambla
    font-rammetto-one
    font-ranchers
    font-rancho
    font-rationale
    font-red-october
    font-redacted
    font-redressed
    font-reenie-beanie
    font-revalia
    font-ribeye
    font-ribeye-marrow
    font-ricty-diminished
    font-righteous
    font-risque
    font-roboto
    font-roboto-condensed
    font-roboto-mono
    font-roboto-mono-for-powerline
    font-roboto-slab
    font-robotomono-nerd-font
    font-robotomono-nerd-font-mono
    font-rochester
    font-rock-salt
    font-rokkitt
    font-romanesco
    font-ropa-sans
    font-rosario
    font-rosarivo
    font-rotinonhsonni-sans
    font-rotinonhsonni-serif
    font-rouge-script
    font-rounded-m-plus
    font-rozha-one
    font-rubik
    font-ruda
    font-rufina
    font-ruge-boogie
    font-ruluko
    font-rum-raisin
    font-rupakara
    font-ruslan-display
    font-russo-one
    font-ruthie
    font-rye
    font-sacramento
    font-sadagolthina
    font-sail
    font-salsa
    font-samim
    font-sanchez
    font-sancreek
    font-sansita-one
    font-sarina
    font-sarpanch
    font-satisfy
    font-scada
    font-scheherazade
    font-schoolbell
    font-seaweed-script
    font-seoulhangang
    font-seoulhangangcondensed
    font-sevillana
    font-seymour-one
    font-shabnam
    font-shadows-into-light
    font-shadows-into-light-two
    font-shanti
    font-share
    font-share-tech
    font-share-tech-mono
    font-sharetechmono-nerd-font
    font-sharetechmono-nerd-font-mono
    font-shojumaru
    font-short-stack
    font-siemreap
    font-sigmar-one
    font-signika
    font-signika-negative
    font-silent-lips
    font-simonetta
    font-sinkin-sans
    font-sintony
    font-sirin-stencil
    font-six-caps
    font-skola-sans
    font-skranji
    font-slackey
    font-smokum
    font-smythe
    font-sniglet
    font-snippet
    font-snowburst-one
    font-sofadi-one
    font-sofia
    font-sonsie-one
    font-sorts-mill-goudy
    font-source-code-pro
    font-source-code-pro-for-powerline
    font-source-han-code-jp
    font-source-han-noto-cjk
    font-source-han-sans
    font-source-han-serif-el-m
    font-source-han-serif-sb-h
    font-source-sans-pro
    font-source-serif-pro
    font-sourcecodepro-nerd-font
    font-sourcecodepro-nerd-font-mono
    font-space-mono
    font-spacemono-nerd-font
    font-spacemono-nerd-font-mono
    font-special-elite
    font-spectral
    font-spicy-rice
    font-spinnaker
    font-spirax
    font-squada-one
    font-stalemate
    font-stalinist-one
    font-stardos-stencil
    font-stint-ultra-condensed
    font-stint-ultra-expanded
    font-stix
    font-stoke
    font-strait
    font-stroke
    font-sue-ellen-francisco
    font-sunshiney
    font-supermercado-one
    font-swanky-and-moo-moo
    font-symbola
    font-syncopate
    font-tai-le-valentinium
    font-takaoex
    font-tangerine
    font-taprom
    font-tauri
    font-teko
    font-telex
    font-tenor-sans
    font-terminus
    font-terminus-nerd-font
    font-terminus-nerd-font-mono
    font-tex-gyre-adventor
    font-tex-gyre-bonum
    font-tex-gyre-chorus
    font-tex-gyre-cursor
    font-tex-gyre-heros
    font-tex-gyre-pagella
    font-tex-gyre-pagella-math
    font-tex-gyre-schola
    font-tex-gyre-termes
    font-text-me-one
    font-thabit
    font-the-girl-next-door
    font-tibetan-machine-uni
    font-tienne
    font-tillana
    font-times-new-roman
    font-tinos
    font-tinos-nerd-font
    font-tinos-nerd-font-mono
    font-titan-one
    font-titillium-web
    font-trade-winds
    font-trebuchet-ms
    font-trirong
    font-trocchi
    font-trochut
    font-trykker
    font-tuffy
    font-tulpen-one
    font-twitter-color-emoji
    font-ubuntu
    font-ubuntu-mono-derivative-powerline
    font-ubuntu-nerd-font
    font-ubuntu-nerd-font-mono
    font-ubuntumono-nerd-font
    font-ubuntumono-nerd-font-mono
    font-ultra
    font-uncial-antiqua
    font-underdog
    font-unica-one
    font-unifrakturcook
    font-unifrakturmaguntia
    font-unkempt
    font-unlock
    font-unna
    font-urw-base35
    font-vampiro-one
    font-varela
    font-varela-round
    font-vast-shadow
    font-vazir
    font-vazir-code
    font-verdana
    font-vibur
    font-vidaloka
    font-viga
    font-voces
    font-volkhov
    font-vollkorn
    font-voltaire
    font-vt323
    font-waiting-for-the-sunrise
    font-wakor
    font-wallpoet
    font-walter-turncoat
    font-waltograph
    font-warnes
    font-webdings
    font-wellfleet
    font-wendy-one
    font-wenquanyi-micro-hei
    font-wenquanyi-micro-hei-lite
    font-wenquanyi-zen-hei
    font-wire-one
    font-wonder-unit-sans
    font-work-sans
    font-xits
    font-xkcd
    font-yanone-kaffeesatz
    font-yellowtail
    font-yeseva-one
    font-yesteryear
    font-yiddishkeit
    font-zeyada
    github
    sonic-visualiser
    soundcloud-downloader
    soundtoys
    unity
    unity-android-support-for-editor
    unity-download-assistant
    unity-ios-support-for-editor
    unity-linux-support-for-editor
    unity-monodevelop
    unity-standard-assets
    unity-web-player
    unity-webgl-support-for-editor
    unity-windows-support-for-editor
    virtualbox
    vmware-fusion8

    qladdict # Subtitle srt files
    qlcolorcode # Syntax highlighted sourcecode
    qlvideo
    quicklook-csv
    quicklook-json
    qlstephen # Plain text files without or with unknown file extension. Example: README, CHANGELOG, index.styl, etc.
    qlmarkdown
    # qlprettypatch
    qlimagesize # Displays image size in preview
    # betterzipql
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

echo "Installing Visual Studio Code extensions..."
installExtension="code --install-extension"
extensions=(
    felipe.nasc-touchbar
    eamodio.gitlens # inline git blame
    eg2.tslint
    christian-kohler.npm-intellisense
    zhuangtongfa.material-theme
    deerawan.vscode-dash
    mkxml.vscode-filesize
    felixfbecker.php-intellisense
    stubailo.ignore-gitignore
    christian-kohler.npm-intellisense
    ms-python.python
    timonwong.shellcheck
    shinnn.stylelint
    wayou.vscode-todo-highlight
    eg2.vscode-npm-script
    joelday.docthis
    pmneo.tsimporter
    formulahendry.auto-rename-tag
    robertohuertasm.vscode-icons
    ms-vscode.cpptools
)

for extension in ${extensions[@]}
do
    eval "$installExtension $extension"
done

echo "Installing more Spacemacs stuff..."
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
ln -s ~/Developer/dotfiles/config/.spacemacs ~/.spacemacs
yarn global add tern

echo "Swapping Chrome print dialogue to expanded native dialogue..."
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

echo "Configuring iTerm 2"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false # Don’t display the annoying prompt when quitting iTerm
# Touchbar Plugin
cd ${ZSH_CUSTOM1:-$ZSH/custom}/plugins || exit
git clone https://github.com/iam4x/zsh-iterm-touchbar.git

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

echo "Cleaning up Office..."
sudo rm -rf /Applications/Microsoft\ Outlook.app

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
# TODO: swap to agnoster theme
# TODO: remove $User@%m from theme

# TODO: Chrome open PDFs with Preview

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

# TODO: run this if Xcode.app exists
# echo "Adding iOS/watchOS simulators to Launchpad..."
# sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
# sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

# TODO: 4 finger dragging
# TODO: Enable all trackpad gestures

# TODO: Enable play feedback when volume is changed

# TODO: Forcing Airdrop to always be on...

# echo "Setting User profile picture if no Apple account..."
# mkdir cd ~/Pictures/Profile/
# cd ~/Pictures/Profile/ || exit
# wget http://graph.facebook.com/100000998230153/picture?type=large&w‌​idth=720&height=720
# dscl . delete /Users/admin jpegphoto
# dscl . delete /Users/admin Picture
# dscl . create /Users/admin Picture "/Library/User Pictures/wunderman.tif"

# Post Install
# make gfxcardstatus hidden by bartender
# remove gfxcardstatus from notification center

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
mongod -version
# docker -v
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
