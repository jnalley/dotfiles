# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

declare -a _ON_CHANGE_DIRECTORY_

# add a callback to be executed when the current directory changes
add_change_directory_callback()  {
  : "${1?Missing callback}"
  _ON_CHANGE_DIRECTORY_+=("$1")
}

# detect directory change
dirchange() {
  [[ "${OWD}" == "${PWD}" ]] && return 1
  OWD="${PWD}"
  return 0
}

# called prior to displaying the prompt
prompt_command() {
  local callback
  # write history so that it is available in new shell sessions
  history -a
  # set default prompt
  export PS1=${ps1}
  # return if directory did not change
  dirchange || return 0
  # reset terminal title
  unset _TITLE_
  # invoke directory change callbacks
  for callback in "${_ON_CHANGE_DIRECTORY_[@]}"; do
    ${callback}
  done
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
