# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

inpath "${1%%.*}" || return 1

# stop here if fewer than 8 colors are supported
colorterm || return 0

# enable color output for diff
diff() { command diff "$@" | colordiff | less -R; }
