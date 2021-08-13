# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

inpath fzf || return

export FZF_DEFAULT_OPTS='--height 30% --border'

inpath tree && export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

[[ -d "${HOMEBREW_PREFIX}" ]] &&
  source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.bash"

inpath fd || return 0

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='fd --type f --exclude .git'
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
