# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

export PATH="~/local/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/sbin:/usr/bin:/sbin"

# stop here if this is not an interactive shell (e.g. ssh <hostname> ls)
[[ $- == *i* ]] || return

# only for login shells.
if shopt -q login_shell; then
  source ~/.bash.d/tmux.sh
  source ~/.bash.d/env.sh
fi

# shell options:
# - enable programable completion
# - fix spelling errors when using cd
# - change directory by typing directory name
# - extended pattern matching
# - append to the history file, don't overwrite it
# - check the window size after each command
# - don't complete empty command line
shopt -s progcomp cdspell autocd extglob histappend \
  checkwinsize no_empty_cmd_completion

# test if a command is available
inpath() { type -p "${1}" > /dev/null ; }

# report the status of terminated background jobs immediately
set -o notify

# Use a vi-style command line editing interface.
set -o vi

# date in the format YYYYMMDDHHMMSS (ISO 8601)
alias mydate="date +'%G%m%d%H%M%S'"

# use sudo instead of su
alias su="sudo -E $(type -p bash)"

# specialized settings for certain commands
for hook in $(shopt -s nullglob; echo ~/.bash.d/hooks/*.sh); do
  name=${hook##*/}
  name=${name%%.sh}
  cmd=$(type -p ${name})
  source ${hook}
done

# terminal setup
source ~/.bash.d/term.sh 2> /dev/null

# os specific
source ~/.bash.d/os/$(uname -s).sh 2> /dev/null

# host specific
source ~/.bash.d/host/$(hostname -s).sh 2> /dev/null

# local (not under version control)
source ~/.bash.d/local.sh 2> /dev/null
