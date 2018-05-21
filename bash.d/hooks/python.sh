# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

: "${VENV_BASE_DIR:=${HOME}/local}"

export VENV_BASE_DIR

python_setup() {
  local skip_install=${1}

  die() { echo -e "$*" ; exit 1 ; }

  install() {
    local p P
    local python
    local requirements

    [[ -z ${skip_install} ]] || return 0

    mkdir -p "${VENV_BASE_DIR}" || \
      die "Failed to create: ${VENV_BASE_DIR}"

    case ${1} in
      python3)
        python3 -m venv "${VENV_BASE_DIR}/python3" || \
          die "Failed to create virtualenv: ${VENV_BASE_DIR}/python3"
        python="${VENV_BASE_DIR}/python3/bin/python"
        requirements="${HOME}/.py3reqs"
        ;;
      python2)
        "${HOME}/.bash.d/scripts/venv.sh" "${VENV_BASE_DIR}/python2" || \
          die "Failed to create virtualenv: ${VENV_BASE_DIR}/python2"
        python="${VENV_BASE_DIR}/python2/bin/python"
        requirements="${HOME}/.py2reqs"
        venv() { "${HOME}/.bash.d/scripts/venv.sh" "$@" ; }
        ;;
    esac

    [[ -x ${python} ]] || \
      die "Failed to create virtualenv with: ${1}!"

    touch "${requirements}"
    ${python} -m pip install -q --upgrade pip
    ${python} -m pip install -q --requirement "${requirements}"
  }

  for p in python2 python3; do
    inpath ${p} || continue
    P=${p^^} ; P=${P%%.*}
    [[ -d ${VENV_BASE_DIR}/${p} ]] || install ${p} || continue
    export PATH=${VENV_BASE_DIR}/${p}/bin:${PATH}
    export ${P}="$(type -P ${p})"
  done
}

python_reset() {
  rm -rf "${VENV_BASE_DIR}"/python[2-3]
  python_setup
}

python_setup skip_install
