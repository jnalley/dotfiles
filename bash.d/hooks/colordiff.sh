# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

[[ -n ${cmd} ]] || return 1

# stop here if fewer than 8 colors are supported
[[ $(tput colors 2> /dev/null) -lt 8 ]] && return 0

# enable color output for diff
eval "function diff() { $(type -p diff) \$@ | colordiff | less -R; }"
