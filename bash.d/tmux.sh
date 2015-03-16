# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

########################################################################
# start tmux when logging in via ssh if terminal supports 256 colors
#
# Avoid problems with SSH_AUTH_SOCK when using multiple connections to
# the same host by using SSH connection sharing. Refer to ControlMaster
# in ssh_config(5).
########################################################################

[[ -r ${SSH_TTY} && ${TERM} != "screen-256color" && ${TERM} == *256color ]] || return

TMUXCMD="$(type -p tmux)"

[[ -x ${TMUXCMD} ]] || return

${TMUXCMD} has-session -t main 2> /dev/null && \
    exec ${TMUXCMD} attach-session -t main

exec ${TMUXCMD} new-session -s main
