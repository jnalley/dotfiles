# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

################################
# Automate tmux session creation
################################

########################################################################
# Avoid problems with SSH_AUTH_SOCK when using multiple connections to
# the same host by using SSH connection sharing. Refer to ControlMaster
# in ssh_config(5).
########################################################################

# prevent nested tmux/screen sessions
[[ ${TERM} == @(tmux-*|screen-*) ]] && return

TMUXCMD="$(command -v tmux)"

[[ -x "${TMUXCMD}" ]] || return

# connect to existing session
if ${TMUXCMD} has-session 2> /dev/null; then
  # only if it has no clients
  [[ -z $(${TMUXCMD} list-clients) ]] && \
    exec "${TMUXCMD}" attach
else
  # create new session
  exec "${TMUXCMD}" new
fi
