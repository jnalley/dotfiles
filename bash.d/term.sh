# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

export COLOR_COUNT=$(inpath tput && tput colors 2> /dev/null || echo 0)

# update terminal title
title() {
  [[ ${TERM} == @(tmux-*|screen-*|xterm-*) ]] || return
  local msg=''
  if [[ -z ${1} ]]; then
    msg=${PWD/$HOME/\\x7e}
    [[ ${#msg} -gt 24 ]] && msg="${msg:0:12}..${msg:(-12)}"
  else
    msg="$(basename $(git rev-parse --show-toplevel))"
    local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    [[ -n ${branch} ]] && msg="${msg}#${branch}"
  fi
  # add hostname for remote sessions
  [[ -z ${TMUX} && -n ${SSH_CLIENT} ]] && msg="${HOSTNAME%%.*} ${msg}"
  [[ ${msg} == \\x7e ]] && msg="${USER}"
  echo -ne "\033]2;${msg}\033\\" # window title
  [[ -n ${TMUX} ]] && echo -ne "\033k${msg}\033\\" # session title
}

# run commands when directory changes
dirchange() {
  if [[ ${OWD:-${PWD}} != ${PWD} ]]; then
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]; then
      ~/.bash.d/scripts/git_user_email.sh
      return 0
    fi
  fi
  OWD=${PWD}
  return 1
}

# called prior to displaying the prompt
prompt_command() {
  # write history so that it is available in new shell sessions
  history -a
  # set default prompt
  export PS1=${ps1}
  dirchange && title git || title
}

# default prompt
ps1='\W\$'

export PROMPT_COMMAND="prompt_command"

# stop here if fewer than 8 colors are supported
[[ ${COLOR_COUNT} -lt 8 ]] && return 0

t=( $(shopt -s nullglob; echo ~/.terminfo/*/{tmux,xterm}-256color) )
[[ ${#t[@]} == 2 ]] || (
  tic -x ~/.tmux-256color.ti
  tic -x ~/.xterm-256color.ti
) ; unset t

# makes prompt red when root light cyan otherwise
if [ ${UID} -eq 0 ]; then
  ps1="\[[0m\]\[[1;31m\]${ps1}\[[0m\]"
else
  ps1="\[[0m\]\[[0;36m\]${ps1}\[[0m\]"
fi

# set LS_COLORS
source ~/.bash.d/dircolors.sh
