#!/usr/bin/env bash

NVIM_VERSION="${NVIM_VERSION:-stable}"

url="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}"

die() { echo "$*" && exit 1; }

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
