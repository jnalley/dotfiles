# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

inpath "${1%%.*}" || return 1

# automatically sets git user.email and updates terminal title
_on_enter_git_repo() {
  local branch
  [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]] || return
  "${HOME}/.bash.d/scripts/git_user_email.sh"
  _TITLE_="$(basename "$(git rev-parse --show-toplevel)")"
  branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  [[ -n "${branch}" ]] && _TITLE_="${_TITLE_}#${branch}"
}

add_change_directory_callback _on_enter_git_repo
