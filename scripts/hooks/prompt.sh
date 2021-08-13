# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

# update terminal title
title() {
  [[ ${TERM} == @(tmux-*|screen-*|xterm-*) ]] || return
  # don't set title in neovim terminals
  [[ -z ${NVIM_LISTEN_ADDRESS} ]] || return
  if [[ -z ${_TITLE_} ]]; then
    _TITLE_=${PWD/$HOME/\\x7e}
    [[ ${#_TITLE_} -gt 24 ]] &&
      _TITLE_="${_TITLE_:0:12}..${_TITLE_:(-12)}"
  fi
  # add hostname for remote sessions
  [[ -z ${TMUX} && -n ${SSH_CLIENT} ]] && _TITLE_="${HOSTNAME%%.*} ${_TITLE_}"
  [[ ${_TITLE_} == \\x7e ]] && _TITLE_="${USER}"
  echo -ne "\\033]2;${_TITLE_}\\033\\"                   # window title
  [[ -n ${TMUX} ]] && echo -ne "\\033k${_TITLE_}\\033\\" # session title
}

# detect directory change
dirchange() {
  [[ "${OWD}" == "${PWD}" ]] && return 1
  OWD="${PWD}"
  return 0
}

# called prior to displaying the prompt
prompt_command() {
  local branch
  # write history so that it is available in new shell sessions
  history -a
  # set default prompt
  export PS1=${ps1}
  # return if directory did not change
  dirchange || return 0
  # reset terminal title
  unset _TITLE_
  # automatically sets git user.email and updates terminal title
  if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]]; then
    ~/.dotfiles/scripts/git_user_email.sh
    _TITLE_="$(git rev-parse --show-toplevel | sed 's!.*/!!')"
    branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    [[ -n "${branch}" ]] && _TITLE_="${_TITLE_}#${branch}"
  fi
  title
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
