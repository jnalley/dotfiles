#!/usr/bin/env bash

# reset PATH (to remove existing python)
source ~/.bashrc

venv=~/.bash.d/scripts/venv.sh

die() { echo -e $@; exit 1; }

[[ -x ${venv} ]] || die "Missing venv.sh"

modules=(
  awscli
  flake8
  neovim
  pyflakes
  request
)

for version in 2.7 3; do
  rm -rf ~/local/python${version}
  inpath python${version} || continue
  VENV_PYTHON=python${version} ${venv} bootstrap \
    || die "Bootstrap failed"
  VENV_PYTHON=python${version} ${venv} default \
    || die "Default venv failed"
  source ~/local/python${version}/active/bin/activate \
    || die "Failed to activate python${version}"
  pip${version} install --upgrade ${modules[@]} \
    || die "Module install failed"
done
