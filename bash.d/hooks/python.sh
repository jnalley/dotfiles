# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

[[ -n $@ ]] || return 1

for p in python3 python2; do
  [[ -d ${HOME}/local/${p} ]] || continue
  export PATH=${HOME}/local/${p}/active/bin:${PATH}
  export ${p^^}="$(type -P ${p})"
done ; unset p

venv() { ~/.bash.d/scripts/venv.sh $@ ; }
