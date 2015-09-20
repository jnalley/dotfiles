# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

# update terminal title
title() {
  [[ ${TERM} == screen* || ${TERM} == xterm* ]] || return
  local msg=${PWD/$HOME/\\x7e}
  [[ ${#msg} -gt 24 ]] && msg="${msg:0:12}..${msg:(-12)}"
  # add hostname for remote sessions
  [[ -z ${TMUX} && -n ${SSH_CLIENT} ]] && msg="${HOSTNAME%%.*} ${msg}"
  echo -ne "\033]2;${msg}\033\\"
}

# run commands when directory changes
dirchange() {
  if [[ ${OWD:-${PWD}} != ${PWD} ]]; then
    [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]] && \
      ~/.bash.d/scripts/git_user_email.sh
  fi
  OWD=${PWD}
}

# called prior to displaying the prompt
prompt_command() {
  # write history so that it is available between shell sessions
  history -a
  # set default prompt
  export PS1=${ps1}
  dirchange
  title
}

# default prompt
ps1='\W\$'

export PROMPT_COMMAND="prompt_command"

# stop here if fewer than 8 colors are supported
[[ $(tput colors 2> /dev/null) -lt 8 ]] && return 0

# makes prompt red when root light cyan otherwise
if [ ${UID} -eq 0 ]; then
  ps1="\[[0m\]\[[1;31m\]${ps1}\[[0m\]"
else
  ps1="\[[0m\]\[[0;36m\]${ps1}\[[0m\]"
fi
