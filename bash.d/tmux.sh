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

[[ ${TERM} != "screen-256color" && ${TERM} == *256color ]] || return

TMUXCMD="$(type -p tmux)"

[[ -x ${TMUXCMD} ]] || return

# connect if a sesion exists
${TMUXCMD} has-session 2> /dev/null && \
    exec ${TMUXCMD} attach

# create a new session when connecting through SSH
[[ -r ${SSH_TTY} ]] && \
    exec ${TMUXCMD} new
