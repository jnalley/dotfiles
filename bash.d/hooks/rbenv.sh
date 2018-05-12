# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

[[ -n $@ ]] || return 1

return 0

eval "$(rbenv init -)"
