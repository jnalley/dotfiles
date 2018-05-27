# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# shell options:
# - enable programable completion
# - fix spelling errors when using cd
# - expand directories with completion results
# - fix spelling errors during tab-completion
# - change directory by typing directory name
# - extended pattern matching
# - append to the history file, don't overwrite it
# - check the window size after each command
# - don't complete empty command line
# - recursive globbing (enables ** to recurse all directories)
# - attempt to perform hostname completion
shopt -s progcomp cdspell direxpand dirspell autocd extglob histappend \
  cmdhist checkwinsize no_empty_cmd_completion globstar hostcomplete

# preserve "shopt" options in subshells
export BASHOPTS

# local binaries
mkdir -p ~/local/bin

include env.sh

# create terminfo for (modified) tmux-256color and xterm-256color
mapfile -t t < <(
  shopt -s nullglob
  echo ~/.terminfo/*/{tmux,xterm}-256color
)

[[ ${#t[@]} == 2 ]] || (
  tic -x ~/.tmux-256color.ti
  tic -x ~/.xterm-256color.ti) 2> /dev/null ; unset t

# install iterm2 preferences
if [[ -n ${ITERM_SESSION_ID} ]]; then
  mkdir -p ~/.iterm2
  if [[ ! -s ~/.iterm2/com.googlecode.iterm2.plist ]]; then
    helper message "Downloading iTerm preferences..."
    curl -sSLo ~/.iterm2/com.googlecode.iterm2.plist \
      'https://drive.google.com/uc?export=download&id=0B0o1linrX7FoSmVMVWpTS2R5b1E'
  fi
fi

if HOMEBREW_PREFIX="$(brew --prefix)"; then
  readonly HOMEBREW_PREFIX ; export HOMEBREW_PREFIX
  # use gnu versions if they are available
  # - brew install coreutils gnu-tar findutils
  PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:${PATH}"
  MANPATH="${HOMEBREW_PREFIX}/local/opt/coreutils/libexec/gnuman:${MANPATH}"
  export PATH MANPATH

  # prevent github rate limiting
  source ~/.homebrew.key 2> /dev/null
fi

# add bash completion install function if completions are missing
[[ -s ~/local/etc/profile.d/bash_completion.sh ]] || \
  install_bash_completion() {
    ~/.bash.d/scripts/install_bash_completion.sh && \
      source ~/local/etc/profile.d/bash_completion.sh 2> /dev/null
  }
