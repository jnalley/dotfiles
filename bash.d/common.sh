# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

########################################################################
# options/environment/aliases
########################################################################

# shell options:
# - enable programable completion
# - fix minor errors in the spelling of a directory names when using cd
# - allow changing to directories by just typing the directory name
# - extended pattern matching
# - append to the history file, don't overwrite it
# - check the window size after each command and, if necessary,
#   update the values of LINES and COLUMNS.
# - do not attempt to complete commands on an empty line
shopt -s \
    progcomp \
    cdspell \
    autocd \
    extglob \
    histappend \
    checkwinsize \
    no_empty_cmd_completion
# report the status of terminated background jobs immediately
set -o notify
# Use a vi-style command line editing interface.
set -o vi

# prevent duplicate history entries
export HISTCONTROL=erasedups
# do not create history entries for the following commands
export HISTIGNORE="history*:exit:jobs:fg:bg:top:clear:cd:pwd"
# limit history size
export HISTSIZE=100000
# format output of ps
export PS_FORMAT="user:15,pid,state,tt=TTY,etime=TIME,command"
# search path for cd command
export CDPATH=.:~:~/share
# python startup script
export PYTHONSTARTUP=~/.pystartup.py
# allow host specific hgrc
export HGRCPATH=${HOME}/.hgrc:${HOME}/.hgrc.d/${HOSTNAME}.rc

# date in the format YYYYMMDDHHMMSS (ISO 8601)
alias mydate="date +'%G%m%d%H%M%S'"
# use sudo instead of su
alias su="sudo -E $(type -p bash)"
# use htop if it's available
inpath htop && alias top=htop

# editor
if inpath vim; then
    export EDITOR=vim
    alias vi="vim -oX"
fi

# pager
if inpath less; then
    export LESS="-RX"
    export PAGER='less'
    alias more="less"
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# always ignore global ssh config
if inpath ssh && [[ -f ~/.ssh/config ]]; then
    eval "function ssh() {
        $(type -p ssh) -F ~/.ssh/config \$@
    }"
fi

########################################################################
# enable colors
########################################################################

# number of colors supported by the terminal
COLORS=$(tput colors 2> /dev/null)
# stop here if fewer than 8 colors are supported
[[ ${COLORS:-0} -lt 8 ]] && unset COLORS && return
unset COLORS

# makes prompt red when root light cyan otherwise
if [ ${UID} -eq 0 ]; then
    DEFAULT_PROMPT="\[[0m\]\[[1;31m\]${DEFAULT_PROMPT}\[[0m\]"
else
    DEFAULT_PROMPT="\[[0m\]\[[0;36m\]${DEFAULT_PROMPT}\[[0m\]"
fi

# enable color output for diff
if inpath diff && inpath colordiff; then
    eval "function diff() {
        $(type -p diff) \$@ | colordiff | less -R
    }"
fi

# set LS_COLORS
source ~/.bash.d/dircolors.sh

# enable color output for grep
export GREP_OPTIONS="--color=auto"
