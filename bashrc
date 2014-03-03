export PATH="${HOME}/local/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/sbin:/usr/bin:/sbin"

## start profiling
# PS4='+ $(date "+%s.%N")\011 '
# exec 3>&2 2> /tmp/bashstart.$$.log
# set -x

# stop here if this is not an interactive shell
[[ $- == *i* ]] || return

[[ -f /usr/local/etc/bash_completion ]] && \
    source /usr/local/etc/bash_completion

# default prompt
DEFAULT_PROMPT='\W\$'

# called prior to displaying the prompt
prompt_command() {
    # write history so that it is available between shell sessions
    history -a
    # update path in terminal title
    if [[ ${TERM} == screen* || ${TERM} == xterm* || ${TERM} == rxvt* ]]; then
        echo -ne "\033]0;${HOSTNAME%%.*} ${PWD/$HOME/~}\007"
    fi
    # set default prompt
    export PS1=${DEFAULT_PROMPT}
}

########################################################################
# automatically start or re-connect to tmux
########################################################################

# start tmux only when logging in via ssh and terminal supports 256 colors
if [[ ${TERM} != "screen-256color" && ${TERM} == *256color ]]; then
    TMUXCMD="$(type -p tmux)"
    if [[ -x "${TMUXCMD}" && -r "${SSH_TTY}" ]]; then
        # set SSH_AUTH_SOCK appropriately
        if [[ -S ${SSH_AUTH_SOCK} ]]; then
            rm -f ${HOME}/.ssh/socket
            ln -s ${SSH_AUTH_SOCK} ${HOME}/.ssh/socket
            export SSH_AUTH_SOCK=${HOME}/.ssh/socket
        fi
        # if the 'main' session exists re-attach - otherwise create it.
        if ${TMUXCMD} has-session -t main 2> /dev/null; then
            TMUXARGS="${TMUXARGS} attach-session -t main"
        else
            TMUXARGS="${TMUXARGS} new-session -s main"
        fi
        exec ${TMUXCMD} ${TMUXARGS}
    fi
fi

export PROMPT_COMMAND=prompt_command

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

## stop profiling
# set +x
# exec 2>&3 3>&-
