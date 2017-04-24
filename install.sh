#!/usr/bin/env bash

DOTFILES=${HOME}/.dotfiles
EXISTING=$(mktemp -d ${HOME}/dotfiles.XXXXX)

[[ -d "${DOTFILES}" && -d "${EXISTING}" ]] || exit 1

for file in ${DOTFILES}/*; do
    file=${file##*/}
    # omit files listed in .skip
    egrep -q "^${file}$" ${DOTFILES}/.skip && continue
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
