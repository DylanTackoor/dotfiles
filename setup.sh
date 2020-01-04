#!/bin/bash

system="$(uname -s)"
case "${system}" in
    Linux*)     script=ubuntu.sh;;
    Darwin*)    script=mac.sh;;
    *)          script="UNKNOWN:${system}"
esac

# TODO: if machine includes UNKNOWN, log error and exit 1

if [ -d ~/.dotfiles ]; then
    echo "Detected ${system}, using local ${script}"
    ./"${script}"
else
    echo "Detected ${system}, downloading remote ${script}"
    wget -q -O - "https://raw.githubusercontent.com/DylanTackoor/dotfiles/master/${script}" | bash
fi
