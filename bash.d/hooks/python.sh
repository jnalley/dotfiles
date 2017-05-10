# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

[[ -n ${1} ]] || return 1

export PATH=~/local/python/venv/active/bin:${PATH}

venv() { ~/.bash.d/scripts/venv.sh $@ ; }

venv activate
