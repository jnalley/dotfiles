# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# no ssh
[[ -x $(type -P "$(basename "${BASH_SOURCE[0]%%.sh}")") ]] || return 1

# no ssh config
[[ -s ~/.ssh/config ]] || return 1

# always ignore global ssh config
ssh() {
  TERM=${TERM/tmux/xterm} $(type -P ssh) -F ~/.ssh/config $@
}
