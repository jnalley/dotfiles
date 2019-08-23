# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

export PYTHONBREAKPOINT=ipdb.set_trace
export PATH=${HOME}/.virtualenv/bin:${PATH}

python_reset() {
  echo "Creating ${HOME}/.virtualenv..."
  python3 -m venv "${HOME}/.virtualenv" && hash -r &&
    python3 -m pip install --upgrade pip &&
    [[ -s ~/.requirements.txt ]] &&
    python3 -m pip install --requirement ~/.requirements.txt
}

[[ -d "${HOME}/.virtualenv" ]] || python_reset
