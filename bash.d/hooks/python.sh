# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

[[ -n $@ ]] || return 1

for p in python3 python2.7; do
  inpath ${p} || continue
  [[ -d ${HOME}/local/${p} ]] || continue
  export PATH=${HOME}/local/${p}/active/bin:${PATH}
  P=${p^^}
  export ${P%%.*}="$(type -P ${p})"
done ; unset p P

venv() { ~/.bash.d/scripts/venv.sh $@ ; }
