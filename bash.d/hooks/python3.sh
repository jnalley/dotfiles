# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

inpath "${1%%.*}" || return 1

export VIRTUAL_ENV_DISABLE_PROMPT=true
export PYTHONBREAKPOINT=ipdb.set_trace

## NOTE: Always use 'python3 -m pip ...' instead of 'pip ...'

pip() {
  echo "Always use 'python3 -m pip ...' instead of 'pip ...'"
}

_python_version() {
  python3 -c \
    'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")'
}

_activate_virtualenv() {
  local target="${1:-.virtualenv}"
  # must have python3
  if [[ ! -x "${target}/bin/python3" ]]; then
    # deactivate when no longer in a directory containing .virtualenv
    deactivate 2>/dev/null
    return
  fi
  echo "Activating Virtual Environment"
  # shellcheck disable=SC1091
  source "${target}/bin/activate" && hash -r
}

create_top_level_virtualenv() {
  local target="${HOME}/.virtualenv"
  echo "Creating ${HOME}/.virtualenv..."
  python3 -m venv "${target}" && _activate_virtualenv "${target}" &&
    python3 -m pip install --upgrade pip &&
    [[ -s "${HOME}/.requirements.txt" ]] &&
    python3 -m pip install --requirement "${HOME}/.requirements.txt"
}

create_child_virtualenv() {
  local target="${1:-.virtualenv}"
  local packages=".virtualenv/lib/python$(_python_version)/site-packages"
  if [[ ! -d "${HOME}/${packages}" ]]; then
    echo "Failed to identify parent virtualenv: ${HOME}/${packages}"
    return 1
  fi
  python3 -m venv --without-pip "${target}" && _activate_virtualenv &&
    echo "${HOME}/${packages}" >"${packages}/parent.pth"
}

add_change_directory_callback _activate_virtualenv
