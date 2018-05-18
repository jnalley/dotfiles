# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# bail if executables are not present
[[ -x ${HOME}/.fzf/bin/fzf ]] && inpath fd || return 1

# add fzf bin directory to path
[[ "$PATH" == *${HOME}/.fzf/bin* ]] || \
  export PATH="$PATH:${HOME}/.fzf/bin"

# add to MANPATH
[[ "${MANPATH}" == *${HOME}/.fzf/man* && -d "${HOME}/.fzf/man" ]] || \
  export MANPATH="$MANPATH:${HOME}/.fzf/man"

# key bindings
source "${HOME}/.fzf/shell/key-bindings.bash" 2> /dev/null

export FZF_DEFAULT_OPTS='--height 30% --border'

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

bind '"\C-x": "\C-x\C-addi`__fzf_cd__`\C-x\C-e\C-x\C-r\C-m"'
bind -m vi-command '"\C-x": "ddi`__fzf_cd__`\C-x\C-e\C-x\C-r\C-m"'
