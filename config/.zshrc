# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# zsh-wakatime
plugins=(npm git-auto-fetch git zsh-nvm node zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

export SSH_KEY_PATH="~/.ssh/rsa_id"
export PATH="/usr/local/sbin:$PATH"

# Aliases
alias update50="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && upgrade_oh_my_zsh && neofetch"
alias lzd='lazydocker'
