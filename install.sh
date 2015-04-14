#!/bin/bash

DOTFILES=${HOME}/.dotfiles
EXISTING=$(mktemp -d ${HOME}/dotfiles.XXXXX)

[[ -d "${DOTFILES}" && -d "${EXISTING}" ]] || exit 1

for file in ${DOTFILES}/*; do
    file=${file##*/}
    # skip the install script and README
    [[ ${file} == ${0##*/} ]] && continue
    [[ ${file} == README.md ]] && continue
    # if file exists and is not a symlink
    # move it to the temporary directory
    if [[ ! -L ${HOME}/.${file} ]]; then
        [[ -e ${HOME}/.${file} ]] && \
            mv -v ${HOME}/.${file} ${EXISTING}/
    fi
    # skip files that are already correct
    [[ -e "${HOME}/.${file}" && \
        "$(readlink ${HOME}/.${file})" = ".dotfiles/${file}" ]] && continue
    ln -vsf .dotfiles/${file} ${HOME}/.${file}
done

# fails if the directory contains files
if ! rmdir ${EXISTING} 2> /dev/null; then
    echo "Existing files moved to ${EXISTING}"
fi

type -p curl > /dev/null || exit 1

# install vim-plug
if [[ -s ${DOTFILES}/vim/autoload/plug.vim ]]; then
    curl --create-dirs -sfLo ${DOTFILES}/vim/autoload/plug.vim \
        'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

# install plugins
type -p vim > /dev/null || exit 1

if [[ -t 1 ]]; then
    # interactive
    vim -c 'PlugInstall'
else
    # headless
    vim -En -c 'PlugInstall' -c 'qa' > /dev/null 2>&1
fi
