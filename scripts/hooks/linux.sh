# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

[[ "$(uname -s)" == *Linux* ]] || return

# running x windows?
[[ -n "${DISPLAY}" ]] || return

# skip if xscape is already running
pidof xcape > /dev/null 2>&1 && return

# swap capslock and CTRL
setxkbmap -option ctrl:nocaps
inpath xcape || return

# tap CTRL for ESC
xcape -e 'Control_L=Escape'
