#!/usr/bin/env bash

NVIM_VERSION="${NVIM_VERSION:-stable}"

url="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}"

die() { echo "$*" && exit 1; }
inpath() { command -v "${1}" >/dev/null; }

inpath curl || die "Missing curl!"
inpath git || die "Missing git!"

case "$(uname -s)" in
  Darwin)
    filename=nvim-macos.tar.gz
    ;;
  Linux)
    filename=nvim-linux64.tar.gz
    ;;
  *)
    die "Unsupported OS!"
    ;;
esac

mkdir -p "${HOME}/.local" ||
  die "Failed to create ~/.local"

curl -sSL "${url}/${filename}" |
  tar -C "${HOME}/.local" -xz --strip-components=1 -f - ||
  die "Failed to install Neovim!"

git clone https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
