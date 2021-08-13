#!/usr/bin/env bash

die() { echo "$*" && exit 1; }

# gnu vs bsd ln :-(
command ln --version 2>/dev/null | grep -qi 'GNU' &&
  params='-vsnf' || params='-vshf'

EXISTING=$(mktemp -d ~/dotfiles.XXXXX)

mkdir -p ~/.config ~/.ssh

# save existing ssh config
[[ ! -L ~/.ssh/config && -s ~/.ssh/config ]] &&
  mv ~/.ssh/config "${EXISTING}/"

# link to ssh config
ln "${params}" ../.dotfiles/ssh_config ~/.ssh/config

# link entries and config
for file in ~/.dotfiles/entries/* ~/.dotfiles/config/*; do
  entry=${file#*.dotfiles/}
  entry=${entry#entries/}

  # if file exists and is not a symlink move it to the temporary directory
  if [[ ! -L "${HOME}/.${entry}" && -e "${HOME}/.${entry}" ]]; then
    [[ ${entry} == *config/* ]] && mkdir -p "${EXISTING}/.config"
    mv -v "${HOME}/.${entry}" "${EXISTING}/"
  fi

  prefix='.dotfiles/entries'
  [[ ${entry} == *config/* ]] && prefix='../.dotfiles'

  ln "${params}" "${prefix}/${entry}" "${HOME}/.${entry}"
done

# fails if the directory contains files
if ! rmdir "${EXISTING}" 2>/dev/null; then
  echo "Existing files moved to ${EXISTING}"
fi
