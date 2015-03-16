# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

export PATH="${HOME}/local/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/sbin:/usr/bin:/sbin"

# stop here if this is not an interactive shell (e.g. ssh <hostname> ls)
[[ $- == *i* ]] || return

# only for login shells.
if shopt -q login_shell; then
    source ~/.bash.d/tmux.sh
    source ~/.bash.d/env.sh
fi

# helpers
source ~/.bash.d/helpers.sh

# common
source ~/.bash.d/common.sh

# os specific
source ~/.bash.d/os.$(uname -s).sh 2> /dev/null

# host specific
source ~/.bash.d/host.$(hostname -s).sh 2> /dev/null

# python virtualenv
source ~/.bash.d/venv.sh && venv activate
