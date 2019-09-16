#!/usr/bin/env bash

url=https://github.com/neovim/neovim/releases/download/stable

die() { echo "$*" && exit 1; }

case "$(uname -o)" in
  Darwin)
    filename=nvim-macos.tar.gz
    ;;
  GNU/Linux)
    filename=nvim-linux64.tar.gz
    ;;
  *)
    die "Unsupported OS!"
    ;;
esac

curl -sSL "${url}/${filename}" |
  tar -C "${HOME}/local" -xz --strip-components=1 -f -
