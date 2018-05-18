# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

[[ -x $(type -P "$(basename "${BASH_SOURCE[0]%%.sh}")") ]] || return 1

eval "$(rbenv init -)"
