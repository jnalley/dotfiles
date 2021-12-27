# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

# pick the best recursive grep option available
for _ in 'rg' 'ag'; do
  # shellcheck disable=SC2139
  inpath $_ && alias g="$_ --ignore-case" && break
done

# use a function wrapper if we are stuck with plain grep
if ! alias g > /dev/null 2>&1; then
  function g() { grep -inRHI "$@" .; }
fi

# enable color for GNU grep
if command grep --version | grep -qi 'GNU'; then
  alias grep='grep --color=auto'
fi
