# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

[[ -n ${1} ]] || return 1

for p in python3 python2; do
  [[ -d ${HOME}/local/${p} ]] || continue
  export PATH=${HOME}/local/${p}/active/bin:${PATH}
done

venv() { ~/.bash.d/scripts/venv.sh $@ ; }

venv activate
