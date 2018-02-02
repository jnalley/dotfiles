# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

declare -r HOMEBREW_PREFIX="$(brew --prefix)"

# use gnu versions if they are available
# - brew install coreutils gnu-tar findutils
export PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:${PATH}"
export MANPATH="${HOMEBREW_PREFIX}/local/opt/coreutils/libexec/gnuman:${MANPATH}"

# color for BSD ls
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxexexabagacad

# use the login keychain for aws-vault
export AWS_VAULT_KEYCHAIN_NAME=login

# homebrew
source ~/.homebrew.key 2> /dev/null

# enable color ls output
inpath gls && alias ls='command gls --color=auto'
