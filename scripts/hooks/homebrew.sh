# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

inpath brew || return

export HOMEBREW_PREFIX="$(brew --prefix)"
# use gnu versions if they are available
# - brew install coreutils gnu-tar findutils
PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:${PATH}"
MANPATH="${HOMEBREW_PREFIX}/local/opt/coreutils/libexec/gnuman:${MANPATH}"
export PATH MANPATH

# prevent github rate limiting
source ~/.homebrew.key 2>/dev/null
