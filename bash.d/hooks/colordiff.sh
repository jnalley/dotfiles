# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

[[ -x $(type -P "$(basename "${BASH_SOURCE[0]%%.sh}")") ]] || return 1

# stop here if fewer than 8 colors are supported
[[ ${COLOR_COUNT} -lt 8 ]] && return 0

# enable color output for diff
diff() { $(type -P diff) "$@" | colordiff | less -R; }
