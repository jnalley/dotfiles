#!/usr/bin/env bash

die() { echo "$*" && exit 1; }
inpath() { command -v "${1}" >/dev/null || die "Missing ${1}!"; }

inpath nvim || die "nvim is missing!"

plug_path=~/.dotfiles/config/nvim/autoload/plug.vim
plug_url='https://raw.github.com/junegunn/vim-plug/master/plug.vim'

[[ -s "${plug_path}" ]] &&
  die "Plug is already installed"

(curl --create-dirs -fsLo "${plug_path}" ${plug_url} &&
  command nvim --headless +PlugInstall +PlugClean! +qa) ||
  die "Failed to install plugins!"
