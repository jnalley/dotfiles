# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# no ssh config
[[ -s ~/.ssh/config ]] || return 1

# always ignore global ssh config
ssh() {
  # TERM=${TERM/tmux/xterm}
  command ssh -F ~/.ssh/config "$@"
}
