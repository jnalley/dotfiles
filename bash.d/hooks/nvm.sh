# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

[[ -s ~/.nvm/alias/default ]] || return 1

export PATH=~/.nvm/versions/node/v$(<~/.nvm/alias/default)/bin:${PATH}

[[ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ]] || return 1

export NVM_DIR=~/.nvm

nvm() {
  unset nvm
  source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
  nvm "$@"
}
