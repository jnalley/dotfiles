# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

[[ -n $@ ]] || return 1

# stop here if fewer than 8 colors are supported
[[ ${COLOR_COUNT} -lt 8 ]] && return 0

# enable color output for diff
diff() { $(type -P diff) $@ | colordiff | less -R; }
