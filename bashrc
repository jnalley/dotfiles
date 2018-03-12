# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

export PATH="~/local/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/sbin:/usr/bin:/sbin"

# unlimited history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="#%s# "
# prevent duplicate history entries
export HISTCONTROL=ignoredups:erasedups:ignorespace
# do not create history entries for the following commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:jobs:history:clear:pwd"

# test if a command is available
inpath() { type -P "${1}" > /dev/null ; }

# built-in basename
basename() { echo ${1##*/} ; }

# run helper function in a subshell
helper() { (source ~/.bash.d/helpers.sh; $@) ; }

# wrap function callbacks
closure() {
  local fname=${1} ; shift
  eval "function ${fname} { $@ \$@; };"
}

# stop here if this is not an interactive shell (e.g. ssh <hostname> ls)
[[ $- == *i* ]] || return

hooks() {
  local hook

  # os specific
  source ~/.bash.d/os/$(uname -s)-hooks.sh 2> /dev/null

  # host specific
  source ~/.bash.d/host/$(hostname -s)-hooks.sh 2> /dev/null

  # customized commands
  for hook in $(shopt -s nullglob; echo ~/.bash.d/hooks/*.sh); do
    source ${hook} "$(type -P $(basename ${hook%%.sh}))"
  done
}

# only for login shells.
if shopt -q login_shell; then
  source ~/.bash.d/tmux.sh
  source ~/.bash.d/env.sh
fi

# shell options:
# - enable programable completion
# - fix spelling errors when using cd
# - expand directories with completion results
# - fix spelling errors during tab-completion
# - change directory by typing directory name
# - extended pattern matching
# - append to the history file, don't overwrite it
# - check the window size after each command
# - don't complete empty command line
# - recursive globbing (enables ** to recurse all directories)
shopt -s progcomp cdspell direxpand dirspell autocd extglob histappend \
  cmdhist checkwinsize no_empty_cmd_completion globstar

# report the status of terminated background jobs immediately
set -o notify

# Use a vi-style command line editing interface.
set -o vi

# Enable history expansion with space
# e.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# date in the format YYYYMMDDHHMMSS (ISO 8601)
alias mydate="date +'%G%m%d%H%M%S'"

# use sudo instead of su
alias su="sudo -E $(type -p bash)"

# rehash PATH
alias rehash='hash -r'

# local binaries
[[ -d ~/local/bin ]] || mkdir -p ~/local/bin

# os specific
source ~/.bash.d/os/$(uname -s).sh 2> /dev/null

# host specific
source ~/.bash.d/host/$(hostname -s).sh 2> /dev/null

# local (not under version control)
source ~/.bash.d/local.sh 2> /dev/null

# terminal setup
source ~/.bash.d/term.sh

# hack to run hooks in the background (fast shell prompt)
trap "hooks ; trap QUIT" QUIT
{ sleep 0.1 ; command kill -QUIT $$ ; } & disown
