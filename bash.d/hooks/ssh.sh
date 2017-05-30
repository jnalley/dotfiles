# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

# no ssh
[[ -x ${1} ]] || return 1

# no ssh config
[[ -s ~/.ssh/config ]] || return 1

# always ignore global ssh config
ssh() {
  TERM=${TERM/tmux/screen} $(type -P ssh) -F ~/.ssh/config $@
}
