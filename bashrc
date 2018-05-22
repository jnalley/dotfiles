# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

PATH=~/local/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/sbin:/usr/bin:/sbin

export PATH

# stop here if this is not an interactive shell (e.g. ssh <hostname> ls)
[[ $- == *i* ]] || return

basename() { echo "${1##*/}"; }
include() { source "${HOME}/.bash.d/${1}" 2>/dev/null; }
inpath() { type -P "${1}" >/dev/null; }

# run helper function in a subshell
helper() { (
  source ~/.bash.d/helpers.sh
  "$@"
); }

# test for colors
colorterm() {
  [[ -n ${COLOR_COUNT} ]] ||
    export COLOR_COUNT=$(tput colors 2>/dev/null || echo 0)
  [[ ${COLOR_COUNT} -ge 8 ]]
}

include 'tmux.sh'
include 'term.sh'

[[ ${SHLVL} == 1 ]] && include 'startup.sh'

# report the status of terminated background jobs immediately
set -o notify

# use a vi-style command line editing interface
set -o vi

# Enable history expansion with space
# e.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# date in the format YYYYMMDDHHMMSS (ISO 8601)
alias mydate="date +'%G%m%d%H%M%S'"

# use sudo instead of su
# shellcheck disable=SC2139
alias su="sudo -E $(type -p bash)"

# rehash PATH
alias rehash='hash -r'

[[ ${PAGER} == less ]] && alias more="less"

# STARTTIME=$(date "+%s")
# PS4='+ $(($(date "+%s") - ${STARTTIME})) '
# exec 3>&2 2> /tmp/bashstart.$$.log
# set -x
# customize commands
for hook in $(
  shopt -s nullglob
  echo ~/.bash.d/hooks/*.sh
); do
  source "${hook}" "$(basename "${hook}")"
done
# set +x
# exec 2>&3 3>&-

[[ -n ${HOMEBREW_PREFIX} ]] && source "${HOMEBREW_PREFIX}/etc/bash_completion"
