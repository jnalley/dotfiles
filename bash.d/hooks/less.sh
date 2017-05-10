# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

[[ -n ${1} ]] || return 1

# - 'R' Accept control chars
# - 'X' Don't clear screen
# - 'F' Don't page if output fits on a single screen
# - 'i' Case insensitive search (type -i in less to toggle)
export LESS="-RXFi"
export PAGER='less'
alias more="less"
