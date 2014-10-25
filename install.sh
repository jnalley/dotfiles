#!/bin/bash

DOTFILES=${HOME}/.dotfiles
EXISTING=$(mktemp -d ${HOME}/dotfiles.XXXXX)

[ -d "${DOTFILES}" -a -d "${EXISTING}" ] || exit 1

for file in ${DOTFILES}/*; do
    file=${file##*/}
    # skip the install script and README
    [ ${file} = ${0##*/} ] && continue
    [ ${file} = README.md ] && continue
    # if file exists and is not a symlink
    # move it to the temporary directory
    if [ ! -L ${HOME}/.${file} ]; then
        [ -e ${HOME}/.${file} ] && \
            mv -v ${HOME}/.${file} ${EXISTING}/
    fi
    # skip files that are already correct
    [ -e "${HOME}/.${file}" -a \
        "$(readlink ${HOME}/.${file})" = ".dotfiles/${file}" ] && continue
    ln -vsf .dotfiles/${file} ${HOME}/.${file}
done

# fails if the directory contains files
if ! rmdir ${EXISTING} 2> /dev/null; then
    echo "Existing files moved to ${EXISTING}"
fi

type -p git > /dev/null || exit 1

# clone vundle
if [ ! -d ${DOTFILES}/vim/bundle/vundle ]; then
    git clone https://github.com/gmarik/vundle.git \
        ${DOTFILES}/vim/bundle/vundle
fi

# install/update plugins
type -p vim > /dev/null && \
    vim -En -c 'PluginInstall' -c 'qa' > /dev/null 2>&1 || true
