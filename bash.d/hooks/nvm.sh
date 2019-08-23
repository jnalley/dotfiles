# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

[[ -s ~/.nvm/alias/default ]] || return 1

export PATH=~/.nvm/versions/node/v$(<~/.nvm/alias/default)/bin:${PATH}
