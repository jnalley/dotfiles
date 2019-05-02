#!/usr/bin/env bash

source ~/.bash.d/helpers.sh

: "${VENV_PYTHON:=$(command -v python2)}"
: "${VENV_VERSION:=16.1.0}"
: "${VENV_URL:=https://github.com/pypa/virtualenv/tarball/${VENV_VERSION}}"
: "${VENV_CACHE:=${HOME}/.venv_cache}"

die() {
  echo -e "$*"
  exit 1
}

venv_install() {
  mkdir -p "${VENV_CACHE}" || \
    die "Failed to create: ${VENV_CACHE}"
  # get virtualenv
  fetch "${VENV_URL}" "${VENV_CACHE}/${VENV_VERSION}.tar.gz" || \
    die "Failed to download: ${VENV_URL}"
  # unpack the tarball
  unpack "${VENV_CACHE}/${VENV_VERSION}.tar.gz" "${VENV_CACHE}/virtualenv" || \
    die "Failed to unpack ${VENV_CACHE}/${VENV_VERSION}.tar.gz"
}

[[ -f ${VENV_CACHE}/virtualenv/virtualenv.py ]] || \
  venv_install

exec "${VENV_PYTHON}" "${VENV_CACHE}/virtualenv/virtualenv.py" "$@"
