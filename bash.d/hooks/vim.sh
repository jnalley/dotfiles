# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# make legacy vim use init.vim instead of ~/.vimrc
export VIMINIT='source ~/.dotfiles/nvim/init.vim'

# editor
for editor in nvim vim; do
  if inpath ${editor}; then
    export EDITOR=${editor}
    alias vi='vim'
    break
  fi
done ; unset editor

install_vim_plugins() {
  local plug_path=~/.dotfiles/nvim/autoload/plug.vim
  local plug_url='https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  local cmd=${EDITOR}

  [[ ${EDITOR} == 'nvim' ]] && cmd="${EDITOR} --headless "

  # install vim-plug (and plugins)
  while :; do
    [[ -s ${plug_path} ]] && break
    helper message "Vim plugins appear to be missing..."
    read -s -n 1 -p "Install plugins now? (y/n)" response ; echo
    [[ ${response} == 'y' ]] || return 1
    helper message "Installing vim plugins..."
    curl --create-dirs -fsLo "${plug_path}" ${plug_url} && \
      command ${cmd} +PlugInstall +PlugClean! +qa && \
      helper message "Plugins installed!" && break
    helper error "Failed to install plugins!" ; return 1
  done

  return 0
}

vim() {
  install_vim_plugins || return 1
  command ${EDITOR} "$@"
}
