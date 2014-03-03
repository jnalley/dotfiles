# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# enable color ls output
alias ls='ls --color=auto'

# enable bash completion
if [ -r /usr/share/bash-completion/bash_completion -a -z "${BASH_COMPLETION}" ] && ! shopt -oq posix; then
    source /usr/share/bash-completion/bash_completion
    complete -d cd
fi
