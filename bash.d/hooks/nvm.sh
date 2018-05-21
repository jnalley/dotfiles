# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

[[ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ]] || return 1

export NVM_DIR=~/.nvm

__node_initialization() {
  unset nvm
  unset node
  unset __node_initialization
  source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
}

nvm() {
  __node_initialization
  # no recursion - __node_initializations creates a new nvm function
  nvm "$@"
}

node() {
  __node_initialization
  command node "$@"
}
