# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

: "${VENV_BASE_DIR:=${HOME}/local}"

python_reset() {
  local p
  rm -rf "${VENV_BASE_DIR}"/python[2-3]
  for p in python2 python3; do
    "${HOME}/.bash.d/scripts/create_python_venv.sh" "${p}"
  done
}

for p in $(shopt -s nullglob && echo "${VENV_BASE_DIR}"/python[2-3]); do
  [[ -x ${p}/bin/python ]] || continue
  export PATH=${p}/bin:${PATH}
  p=${p##*/}
  export "${p^^}"="$(type -P "${p}")"
done

unset p

if ~/.bash.d/scripts/package_installed.py ipdb; then
  export PYTHONBREAKPOINT=ipdb.set_trace
  alias pydebug="PYTHONBREAKPOINT=ipdb.set_trace python -m ipdb -c continue"
fi
