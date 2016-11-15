# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

export LANG="en_US.UTF-8"
export LC_COLLATE="${LANG}"
export LC_CTYPE="${LANG}"
export LC_MESSAGES="${LANG}"
export LC_MONETARY="${LANG}"
export LC_NUMERIC="${LANG}"
export LC_TIME="${LANG}"
export LC_ALL=

export GREP_OPTIONS="--color=auto"

export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 5)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 51; tput setab 20)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 3)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)

# prevent duplicate history entries
HISTCONTROL=ignoredups:erasedups
# do not create history entries for the following commands
HISTIGNORE="&:[ ]*:exit:ls:bg:fg:jobs:history:clear:pwd"
# unlimited history size
HISTSIZE=-1
# format output of ps
export PS_FORMAT="user:15,pid,state,tt=TTY,etime=TIME,command"
# search path for cd command
CDPATH=.:~/Projects
# python startup script
export PYTHONSTARTUP=~/.pystartup.py
# default editor
export EDITOR=vi

# set LS_COLORS
source ~/.bash.d/dircolors.sh

# store config files in .dotfiles directory
export XDG_CONFIG_HOME=~/.dotfiles
export XDG_DATA_HOME="${XDG_CONFIG_HOME}"
