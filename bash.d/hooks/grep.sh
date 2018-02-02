# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

[[ -n $@ ]] || return 1

# pick the best recursive grep option available
for prg in 'rg' 'ag'; do
  inpath ${prg} && alias g="${prg} --ignore-case" && break
done ; unset prg

# use a function wrapper if we are stuck with plain grep
if ! alias g > /dev/null 2>&1; then
  function g() { grep -inRHI "$@" .; }
fi

# enable color for GNU grep
if command grep --version | grep -qi 'GNU'; then
  alias grep='grep --color=auto'
fi
