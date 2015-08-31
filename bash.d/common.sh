# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# shell options:
# - enable programable completion
# - fix minor errors in the spelling of a directory names when using cd
# - allow changing to directories by just typing the directory name
# - extended pattern matching
# - append to the history file, don't overwrite it
# - check the window size after each command and, if necessary,
#   update the values of LINES and COLUMNS.
# - do not attempt to complete commands on an empty line
shopt -s \
    progcomp \
    cdspell \
    autocd \
    extglob \
    histappend \
    checkwinsize \
    no_empty_cmd_completion

# report the status of terminated background jobs immediately
set -o notify
# Use a vi-style command line editing interface.
set -o vi

# date in the format YYYYMMDDHHMMSS (ISO 8601)
alias mydate="date +'%G%m%d%H%M%S'"
# use sudo instead of su
alias su="sudo -E $(type -p bash)"

# use htop if it's available
inpath htop && alias top=htop

# editor
for editor in nvim vim; do
  if inpath ${editor}; then
      export EDITOR=${editor}
      alias vim="${editor} -oX"
      alias vi='vim'
      break
  fi
done

# pager
if inpath less; then
    # - 'R' Accept control chars
    # - 'X' Don't clear screen
    # - 'F' Don't page if output fits on a single screen
    export LESS="-RXF"
    export PAGER='less'
    alias more="less"
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# always ignore global ssh config
if inpath ssh && [[ -f ~/.ssh/config ]]; then
    eval "function ssh() {
        $(type -p ssh) -F ~/.ssh/config \$@
    }"
fi

# set user.email in git repos
git_user_email() {
    local email
    [[ $(git config user.email) == "jnalley@earth" ]] || return 0
    read -e -i 'code@bluebot.org' -p 'GIT email: ' email
    git config user.email ${email}
}

# run commands when entering a git repo
git_commands() {
    git_user_email
}

# update terminal title
title() {
    [[ ${TERM} == screen* || ${TERM} == xterm* ]] || return
    local msg=${PWD/$HOME/\\x7e}
    [[ ${#msg} -gt 24 ]] && msg="${msg:0:12}..${msg:(-12)}"
    # add hostname for remote sessions
    [[ -z ${TMUX} && -n ${SSH_CLIENT} ]] && msg="${HOSTNAME%%.*} ${msg}"
    echo -ne "\033]2;${msg}\033\\"
}

# run commands when directory changes
dirchange() {
    if [[ ${OWD:-${PWD}} != ${PWD} ]]; then
        [[ -d .git ]] && inpath git && git_commands
    fi
    OWD=${PWD}
}

# called prior to displaying the prompt
prompt_command() {
    # write history so that it is available between shell sessions
    history -a
    # set default prompt
    export PS1=${DEFAULT_PROMPT}
    dirchange
    title
}

# default prompt
DEFAULT_PROMPT='\W\$'

export PROMPT_COMMAND="prompt_command"

########################################################################
# enable colors
########################################################################

# number of colors supported by the terminal
COLORS=$(tput colors 2> /dev/null)
# stop here if fewer than 8 colors are supported
[[ ${COLORS:-0} -lt 8 ]] && unset COLORS && return
unset COLORS

# makes prompt red when root light cyan otherwise
if [ ${UID} -eq 0 ]; then
    DEFAULT_PROMPT="\[[0m\]\[[1;31m\]${DEFAULT_PROMPT}\[[0m\]"
else
    DEFAULT_PROMPT="\[[0m\]\[[0;36m\]${DEFAULT_PROMPT}\[[0m\]"
fi

# enable color output for diff
if inpath diff && inpath colordiff; then
    eval "function diff() {
        $(type -p diff) \$@ | colordiff | less -R
    }"
fi

# set LS_COLORS
source ~/.bash.d/dircolors.sh

# enable color output for grep
export GREP_OPTIONS="--color=auto"
