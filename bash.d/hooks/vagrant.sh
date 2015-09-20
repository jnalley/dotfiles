# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

[[ -n ${cmd} ]] || return 1

# run vagrant commands from anywhere
# <vagrant vm name> <command>
__vagrant() {
    local instance=$1; shift
    [[ -d ~/Projects/vagrant/${instance} ]] || return 1
    (cd ~/Projects/vagrant/${instance} ; exec vagrant $@)
}

for dir in $(shopt -s nullglob; echo ~/Projects/vagrant/*); do
    name=${dir##*/}
    eval "function ${name} { __vagrant ${name} \$@; };" \
        "function _${name} { _vagrant \$@; }"
    complete -F _${name} ${name}
done
