# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

# make legacy vim use init.vim instead of ~/.vimrc
export VIMINIT='source ~/.dotfiles/nvim/init.vim'

# editor
for editor in nvim vim; do
  if inpath ${editor}; then
    export EDITOR=${editor}
    alias vim="${editor}"
    alias vi='vim'
    break
  fi
done ; unset editor

# use nvr - https://github.com/mhinz/neovim-remote.git
if [[ -n ${NVIM_LISTEN_ADDRESS} ]] && inpath nvr; then
  alias vim='nvr --remote'
fi
