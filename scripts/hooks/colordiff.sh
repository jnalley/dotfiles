# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

inpath colordiff && colorterm || return

# enable color output for diff
diff() { command diff "$@" | colordiff | less -R; }
