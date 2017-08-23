REM Install Chocolatey package manager
Set-ExecutionPolicy unrestricted
Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

REM Enables Windows Linux Subsystem (Bash)
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -NoRestart

REM Disables Internet Explorer (I hope)
dism /online /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64

REM Show file extensions
reg add HKCUSoftwareMicrosoftWindowsCurrentVersionExplorerAdvanced /v HideFileExt /t REG_DWORD /d 0 /f

REM GUI Programs
choco install -y googlechrome
choco install -y winrar
choco install -y firefox
choco install -y 7zip.install
choco install -y steam
choco install -y skype
choco install -y telegram
choco install -y ccleaner
choco install -y malwarebytes
choco install -y atom
choco install -y dropbox
choco install -y windirstat
choco install -y teamviewer
choco install -y itunes
choco install -y gimp
choco install -y calibre
choco install -y spotify
choco install -y whatsapp
choco install -y slack
choco install -y f.lux
choco install -y obs-studio
choco install -y handbrake
choco install -y google-backup-and-sync

REM Dev Tools
choco install -y docker-for-windows
choco install -y visualstudiocode
choco install -y virtualbox
choco install -y unity
choco install -y cyberduck.install
choco install -y postman
choco install -y robo3t.install
choco install -y etcher
choco install -y arduino
choco install -y velocity
choco install -y webstorm
choco install pycharm-community

REM CLI tools
choco install -y python3
choco install -y youtube-dl
choco install -y git.install
choco install -y neovim
choco install -y php
choco install -y curl
choco install -y wget
choco install -y mysql
choco install -y mongodb
choco install -y nodejs.install

REM Node.js global packages
npm install -g gulp csvtojson js-beautify typescript

REM Visual Studio Code Extensions
code --install-extension eg2.tslint

REM Disable UAC Prompt
C:\Windows\System32\cmd.exe /k %windir%\System32\reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f

REM Run Windows Update
wuauclt.exe /updatenow