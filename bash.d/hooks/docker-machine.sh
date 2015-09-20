# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

[[ -n ${cmd} ]] || return 1

alias dm=docker-machine

denv() {
  local name=${1:?}
  if ! [[ "$(docker-machine ls -q)" =~ .*${name}.* ]]; then
    >&2 echo "Invalid machine name: ${name}"
    return 1
  fi
  eval "$(docker-machine env ${name})"
}

dps() {
  for instance in $(docker-machine ls -q); do
    echo "[ ${instance} - $(dm ip ${instance}) ]"
    denv ${instance}
    docker ps -a
    echo
  done
}

denv dev
