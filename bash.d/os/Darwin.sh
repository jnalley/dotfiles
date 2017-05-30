# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# use gnu versions if they are available
# - brew install coreutils gnu-tar findutils
export PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"

# enable color ls output
if command ls --version | grep -qi 'GNU'; then
  alias ls='command ls --color=auto'
fi

# color for BSD ls
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxexexabagacad

# bash completion
source /usr/local/etc/bash_completion 2> /dev/null

# homebrew
source ~/.homebrew.key 2> /dev/null

# install iterm2 preferences
if [[ ! -s ~/.iterm2/com.googlecode.iterm2.plist ]]; then
  mkdir -p ~/.iterm2
  helper message "Downloading iTerm preferences..."
  curl -sSLo ~/.iterm2/com.googlecode.iterm2.plist \
  'https://drive.google.com/uc?export=download&id=0B0o1linrX7FoSmVMVWpTS2R5b1E'
fi
