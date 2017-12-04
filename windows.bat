REM Install Chocolatey package manager
Set-ExecutionPolicy unrestricted
Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

REM CLI tools
choco install -y openssh
choco install -y python3
choco install -y youtube-dl
choco install -y git.install
choco install -y neovim
choco install -y php
choco install -y curl
choco install -y wget
choco install -y mysql
choco install -y sqlite
choco install -y nodejs.install
choco install -y yarn

REM Browsers
choco install -y googlechrome
choco install -y firefox

REM Archive Utilities
choco install -y winrar
choco install -y 7zip.install

REM Messaging
choco install -y telegram
choco install -y whatsapp
choco install -y slack

REM Cloud Storage
choco install -y dropbox
choco install -y resilio-sync-home
choco install -y google-backup-and-sync

REM Personal Library
choco install -y itunes
choco install -y calibre
choco install -y plexmediaserver

REM Games
choco install -y steam
choco install -y uplay
choco install -y origin
choco install -y minecraft

REM Text Editors/IDEs
choco install -y visualstudiocode
choco install -y atom
choco install -y unity
choco install -y arduino

REM Other Dev Tools
choco install -y velocity
choco install -y toggl
choco install -y cyberduck.install
choco install -y putty.install

REM Database Tools
choco install -y postman
choco install -y mysql.workbench

REM Software Setup
choco install -y virtualbox
choco install -y virtualbox.extensionpack
choco install -y docker-toolbox
choco install -y etcher

REM Image editing
choco install -y inkscape
choco install -y gimp

REM Monitoring
choco install -y cpu-z
choco install -y hwmonitor
choco install -y msiafterburner
choco install -y aida64-extreme

REM PC Maintenance
choco install -y ccleaner
choco install -y defraggler
choco install -y windirstat

REM Utilities
choco install -y malwarebytes
choco install -y transmission
choco install -y teamviewer
choco install -y f.lux
choco install -y obs-studio
choco install -y handbrake

REM Node.js global packages
yarn global add typescript gulp node-sass reload eslint csvtojson
npm install -g typescript gulp node-sass reload nave @angular/cli express-generator csvtojson js-beautify create-react-app

REM Visual Studio Code Extensions
code --install-extension eg2.tslint

REM Enables Windows Linux Subsystem (Bash)
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -NoRestart

REM Disables Internet Explorer (I hope)
dism /online /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64

REM Show file extensions
reg add HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced /v HideFileExt /t REG_DWORD /d 0 /f

REM Disable UAC Prompt
C:\Windows\System32\cmd.exe /k %windir%\System32\reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f

REM TODO: Disable Sticky Keys shortcut

REM Run Windows Update
wuauclt.exe /updatenow
