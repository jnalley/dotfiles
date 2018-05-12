# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# bash completions path
source "${HOMEBREW_PREFIX}/etc/bash_completion" 2> /dev/null

# install iterm2 preferences
if [[ ! -s ~/.iterm2/com.googlecode.iterm2.plist ]]; then
  mkdir -p ~/.iterm2
  helper message "Downloading iTerm preferences..."
  curl -sSLo ~/.iterm2/com.googlecode.iterm2.plist \
  'https://drive.google.com/uc?export=download&id=0B0o1linrX7FoSmVMVWpTS2R5b1E'
fi

# node version manager
# export NVM_DIR=~/.nvm
# source ${HOMEBREW_PREFIX}/opt/nvm/nvm.sh
