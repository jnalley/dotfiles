# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

[[ -x ${1} ]] || return 1

# run vagrant commands from anywhere
# <vagrant vm name> <command>
__vagrant() {
    local instance=$1; shift
    [[ -d ~/Projects/vagrant/${instance} ]] || return 1
    [[ -z "$@" ]] && set -- "ssh -- -A" # make default command be ssh
    (cd ~/Projects/vagrant/${instance} ; exec vagrant $@)
}

for dir in $(shopt -s nullglob; echo ~/Projects/vagrant/*); do
    name=${dir##*/}
    closure ${name} __vagrant ${name}
    closure _${name} _vagrant
    complete -F _${name} ${name}
done ; unset dir ; unset name
