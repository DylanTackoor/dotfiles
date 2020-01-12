# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"

# TODO: setup zsh-wakatime
plugins=(
	autoupdate
	# bgnotify
	docker
	docker-compose
	gcloud
	git
	git-auto-fetch
	# golang
	node
	zsh-autosuggestions
	zsh-nvm
)

source $ZSH/oh-my-zsh.sh

export SSH_KEY_PATH="~/.ssh/rsa_id"
export PATH="/usr/local/sbin:$PATH"

[[ -s "/home/dylan/.gvm/scripts/gvm" ]] && source "/home/dylan/.gvm/scripts/gvm"
