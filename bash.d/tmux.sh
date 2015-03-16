# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

################################
# Automate tmux session creation
################################

########################################################################
# Avoid problems with SSH_AUTH_SOCK when using multiple connections to
# the same host by using SSH connection sharing. Refer to ControlMaster
# in ssh_config(5).
########################################################################

[[ ${TERM} != "screen-256color" && ${TERM} == *256color ]] || return

TMUXCMD="$(type -p tmux)"

[[ -x ${TMUXCMD} ]] || return

# connect if a sesion exists and has no clients
${TMUXCMD} has-session 2> /dev/null && \
    [[ -z $(${TMUXCMD}  list-clients > /dev/null) ]] && \
        exec ${TMUXCMD} attach

# auto-create session only when connecting through SSH
[[ -r ${SSH_TTY} ]] && exec ${TMUXCMD} new
