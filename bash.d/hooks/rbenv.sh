# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

inpath "${1%%.*}" || return 1

__ruby_initialization() {
  eval "$(command rbenv init -)"

  # add ruby bin paths
  inpath gem && export PATH=$(
    IFS=':' read -r -a gempath <<< "$(gem environment gempath)"
    gempath=$(printf ":%s" "${gempath[@]/%//bin}")
    echo "${gempath:1}"
  ):${PATH}

  unset ruby
  unset rbenv
  unset __ruby_initialization
}

rbenv() {
  __ruby_initialization
  command rbenv "$@"
}

ruby() {
  __ruby_initialization
  command ruby "$@"
}
