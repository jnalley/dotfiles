# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

# no ssh
[[ -n ${cmd} ]] || return 1

# no ssh config
[[ -s ~/.ssh/config ]] || return 1

# always ignore global ssh config
eval "ssh() { ${cmd} -F ~/.ssh/config \$@; }"
