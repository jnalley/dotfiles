# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

export VIMINIT='source ~/.vim/vimrc'

# editor
for editor in nvim vim; do
  if inpath ${editor}; then
    export EDITOR=${editor}
    alias vim="${editor}"
    alias vi='vim'
    break
  fi
done

if [[ -n ${NVIM_LISTEN_ADDRESS} ]]; then
  alias vim=nvim-terminal-edit.py
fi
