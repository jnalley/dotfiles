# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

PATH=~/local/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/sbin:/usr/bin:/sbin

export PATH

# unlimited history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="#%s# "
# prevent duplicate history entries
export HISTCONTROL=ignoredups:erasedups:ignorespace
# do not create history entries for the following commands
export HISTIGNORE="&:[ ]*:??:???:exit:ls -al:bg:fg:jobs:history:clear:pwd"

# stop here if this is not an interactive shell (e.g. ssh <hostname> ls)
[[ $- == *i* ]] || return

basename() { echo "${1##*/}"; }
include() { source "${HOME}/.bash.d/${1}" 2>/dev/null; }
inpath() { command -v "${1}" >/dev/null; }

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

# date in the format YYYYMMDDHHMMSS (ISO 8601)
alias mydate="date +'%G%m%d%H%M%S'"

# use sudo instead of su
# shellcheck disable=SC2139
alias su="sudo -E $(command -v bash)"

# rehash PATH
alias rehash='hash -r'

# request response times with curl
# see: https://stackoverflow.com/q/18215389
alias tcurl='curl -w "@${HOME}/.curl_format" -o /dev/null -sSL'

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

source ~/local/etc/profile.d/bash_completion.sh 2> /dev/null

source ~/.bash.d/local.sh 2> /dev/null
