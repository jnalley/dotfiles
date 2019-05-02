# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

: "${VENV_BASE_DIR:=${HOME}/local}"

die() { echo -e "$*" && exit 1; }

inpath() { command -v "${1}" >/dev/null; }

install_requirements() {
  local interpreter="${1}"
  local requirements="${2}"

  [[ -x "${interpreter}" ]] ||
    die "Failed to create virtualenv with: ${1}!"

  "${interpreter}" -m pip install -q --upgrade pip
  [[ -s "${requirements}" ]] && \
    "${interpreter}" -m pip install -q --requirement "${requirements}"
}

python_version="${1}"

mkdir -p "${VENV_BASE_DIR}" || \
  die "Failed to create: ${VENV_BASE_DIR}"

inpath "${python_version}" || \
  die "${python_version} not found in path!"

case "${python_version}" in
  python3)
    python3 -m venv "${VENV_BASE_DIR}/python3" ||
      die "Failed to create virtualenv: ${VENV_BASE_DIR}/python3"
    install_requirements \
      "${VENV_BASE_DIR}/python3/bin/python" "${HOME}/.py3reqs"
    ;;
  python2)
    "${HOME}/.bash.d/scripts/venv.sh" "${VENV_BASE_DIR}/python2" ||
      die "Failed to create virtualenv: ${VENV_BASE_DIR}/python2"
    install_requirements \
      "${VENV_BASE_DIR}/python2/bin/python" "${HOME}/.py2reqs"
    ;;
  *)
    die "Invalid python version: ${python_version}"
    ;;
esac
