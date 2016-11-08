# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

history() {
  case "$1" in
    --squish)
      # prevent changing parent shell environment with subshell
      (
        source ~/.bash.d/helpers.sh
        local OLDHIST=${HISTFILE}
        HISTFILE=$(tmpfile)
        history -c
        perl -ne '$H{$_}++ or print' < ${OLDHIST} > ${HISTFILE}
        history -r
        rm ${HISTFILE}
        HISTFILE=${OLDHIST}
        history -w
      )
      return
      ;;
  esac
  command history $@
}
