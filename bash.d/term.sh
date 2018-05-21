# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

# update terminal title
title() {
  [[ ${TERM} == @(tmux-*|screen-*|xterm-*) ]] || return
  local msg=''
  if [[ -z ${1} ]]; then
    msg=${PWD/$HOME/\\x7e}
    [[ ${#msg} -gt 24 ]] && msg="${msg:0:12}..${msg:(-12)}"
  else
    msg="$(basename "$(git rev-parse --show-toplevel)")"
    local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    [[ -n ${branch} ]] && msg="${msg}#${branch}"
  fi
  # add hostname for remote sessions
  [[ -z ${TMUX} && -n ${SSH_CLIENT} ]] && msg="${HOSTNAME%%.*} ${msg}"
  [[ ${msg} == \\x7e ]] && msg="${USER}"
  echo -ne "\\033]2;${msg}\\033\\" # window title
  [[ -n ${TMUX} ]] && echo -ne "\\033k${msg}\\033\\" # session title
}

# run commands when directory changes
dirchange() {
  if [[ ${OWD:-${PWD}} != "${PWD}" ]]; then
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
  if dirchange; then
    title git
  else
    title
  fi
}

# default prompt
ps1='\W\$'
export PROMPT_COMMAND="prompt_command"

colorterm || return 0

# red prompt when root, light cyan otherwise
if [[ ${UID} == 0 ]]; then
  ps1="\\[[0m\\]\\[[1;31m\\]${ps1}\\[[0m\\]"
else
  ps1="\\[[0m\\]\\[[0;36m\\]${ps1}\\[[0m\\]"
fi
