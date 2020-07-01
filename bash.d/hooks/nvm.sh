# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

[[ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ]] || return 1

export NVM_DIR=~/.nvm

# the purpose of this function is to avoid the ~6 seconds overhead
# added to shell startup when sourcing nvm.sh
nvm() {
  unset nvm
  source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
  nvm "$@"
}

[[ -s ~/.nvm/alias/default ]] || return 1

# note `default` must contain a vaild version NOT something like `lts/*`
# set using `nvm alias default 12.18.0`
export PATH=~/.nvm/versions/node/v$(<~/.nvm/alias/default)/bin:${PATH}
