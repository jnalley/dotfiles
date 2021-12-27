# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

export LANG="en_US.UTF-8"
export LC_COLLATE="${LANG}"
export LC_CTYPE="${LANG}"
export LC_MESSAGES="${LANG}"
export LC_MONETARY="${LANG}"
export LC_NUMERIC="${LANG}"
export LC_TIME="${LANG}"
export LC_ALL=

export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 5)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 51; tput setab 20)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 3)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)

# format output of ps
export PS_FORMAT="user:15,pid,state,tt=TTY,etime=TIME,command"
# search path for cd command
export CDPATH=.:~/Projects
# default editor
export EDITOR=vi

# store config files in .dotfiles directory
export XDG_CONFIG_HOME=~/.dotfiles
export XDG_DATA_HOME="${XDG_CONFIG_HOME}"

# store (auto generated) plugin manifest in tmp directory
export NVIM_RPLUGIN_MANIFEST="${XDG_DATA_HOME}/nvim/tmp/rplugin.vim"

# disable some shellcheck errors
export SHELLCHECK_OPTS="-e SC1090 -e SC2155"

# use the login keychain for aws-vault
export AWS_VAULT_KEYCHAIN_NAME=login

# some AWS SDK's only use ~/.aws/credentials by default and not ~/.aws/config
export AWS_SDK_LOAD_CONFIG=true

# - 'R' Accept control chars
# - 'X' Don't clear screen
# - 'F' Don't page if output fits on a single screen
# - 'i' Case insensitive search (type -i in less to toggle)
export LESS="-RXFi"
export PAGER='less'

# color for BSD ls
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxexexabagacad

include dircolors.sh
