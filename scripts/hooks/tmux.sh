# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

# prevent nested tmux/screen sessions and skip for vscode
[[ ${TERM} == @(tmux-*|screen-*) || ${TERM_PROGRAM} == vscode ]] && return

TMUXCMD="$(command -v tmux)"

[[ -x "${TMUXCMD}" ]] || return

# connect to existing session
if "${TMUXCMD}" has-session 2> /dev/null; then
  # only if it has no clients
  [[ -z $(${TMUXCMD} list-clients) ]] && \
    exec "${TMUXCMD}" attach
else
  # create new session
  exec "${TMUXCMD}" new
fi
