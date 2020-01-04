#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     script=ubuntu.sh;;
    Darwin*)    script=mac.sh;;
    *)          script="UNKNOWN:${unameOut}"
esac

echo ${script}

# TODO: if machine includes UNKNOWN, log error and exit 1

# if ~/.dotfiles exists
	# run local script
# else
	# curl script and pipe to bash
