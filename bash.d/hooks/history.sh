# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

history() {
  case "$1" in
    --squish)
        local OLDHIST=${HISTFILE}
        HISTFILE=$(mktemp -t tmp.XXXXX)
        command history -c
        perl -ne '$H{$_}++ or print' < ${OLDHIST} > ${HISTFILE}
        command history -r
        rm ${HISTFILE}
        HISTFILE=${OLDHIST}
        command history -w
      return
      ;;
  esac
  command history $@
}
