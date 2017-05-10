# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

[[ -x ${1} ]] || return

aws() {
  gpg -qd ~/.credentials.gpg > ~/.aws/credentials || return 1
  $(type -P aws) $@
  rm -f ~/.aws/credentials
}
