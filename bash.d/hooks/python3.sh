# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash
inpath "${1%%.*}" || return 1


export VIRTUAL_ENV_DISABLE_PROMPT=true
export PYTHONBREAKPOINT=pdb.set_trace

return 0  # skip for now

export PATH="${HOME}/.pyenv/shims:${PATH}"

## NOTE: Always use 'python -m pip ...' instead of 'pip ...'

pip() {
  ${PYTHON:-python3} -m pip "$@"
}

_python_version() {
  ${PYTHON:-python3} -c \
    'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")'
}

_full_path() {
  local path=${1:?Missing path}
  ${PYTHON:-python3} -c \
    "from pathlib import Path; print(Path('${path}').resolve())"
}

_activate_virtualenv() {
  local path="${1:-${PWD}}"
  while [[ $path != "" ]]; do
    if [[ -s "${path}/.virtualenv/bin/activate" ]]; then
      [[ ${VIRTUAL_ENV} == "${path}/.virtualenv" ]] && return 0
      # shellcheck disable=SC1091
      source "${path}/.virtualenv/bin/activate" && hash -r
      return
    fi
    path=${path%/*}
  done
  return 1
}

mkvenv() {
  local target="$(_full_path "${1:-.virtualenv}")"

  if [[ -d "${target}" ]]; then
    echo "${target} already exists!" && return 1
  fi

  if ! ${PYTHON:-python3} -m venv "${target}"; then
    echo "Error creating: ${target}" && return 1
  fi

  if ! _activate_virtualenv "${target%/*}"; then
    echo "Failed to activate: ${target}!" && return 1
  fi

  if ! ${PYTHON:-python3} -m pip install --upgrade pip; then
    echo "Error during pip upgrade!" && return 1
  fi

  # install requirements for primary virtualenv
  if [[ "${target%/*}" == "${HOME}" ]]; then
    if [[ -s ~/.requirements.txt ]]; then
      if ! ${PYTHON:-python3} -m pip install --requirement ~/.requirements.txt; then
        echo "Error installing requirements!" && return 1
      fi
    fi
  fi
}

add_change_directory_callback _activate_virtualenv
