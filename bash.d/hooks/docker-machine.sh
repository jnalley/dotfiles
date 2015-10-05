# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

# skip if this is a SUDO shell
[[ -n ${SUDO_USER} ]] && return 1

[[ -n ${cmd} ]] || return 1

alias dm=docker-machine

denv() {
  local name=${1}
  if [[ -z ${name} ]]; then
    echo ${DOCKER_MACHINE_NAME:-unset} ; return
  fi
  if ! [[ "$(docker-machine ls -q)" =~ .*${name}.* ]]; then
    >&2 echo "Invalid machine name: ${name}"
    return 1
  fi
  eval "$(docker-machine env ${name})"
}

dps() {
  for instance in $(docker-machine ls -q); do
    echo "[ ${instance} - $(docker-machine ip ${instance}) ]"
    # use a subshell to prevent clobbering environment.
    (denv ${instance} ; docker ps -a)
    echo
  done
}

[[ $(denv) == "dev" ]] || denv dev
