#!/usr/bin/env bash

readonly ASDF_VERSION='v0.8.1'
readonly ASDF_URL='https://github.com/asdf-vm/asdf.git'

NODEJS_VERSION='14.17.5' # LTS

readonly -A PLUGINS=(
  [python]="${PYTHON_VERSION:-latest}"
  [nodejs]="${NODEJS_VERSION:-latest}"
  [ruby]="${RUBY_VERSION:-latest}"
  [lua]="${LUA_VERSION:-latest}"
)

die() { echo "$*" && exit 1; }
have() { command -v "${1}" >/dev/null || die "Missing: ${1}"; }

have git
have brew # Dependencies will be automatically installed by Homebrew.

if [[ ! -d ~/.asdf ]]; then
  (git -c advice.detachedHead=false \
    clone "${ASDF_URL}" ~/.asdf \
    --single-branch --branch "${ASDF_VERSION}" &&
    git -C ~/.asdf switch -c "${ASDF_VERSION}") ||
    die "Failed to clone ${ASDF_URL}"
fi

source ~/.asdf/asdf.sh

for plugin in "${!PLUGINS[@]}"; do
  echo "Installing: ${plugin} ${PLUGINS[$plugin]}"
  asdf plugin-add "${plugin}"
  asdf install "${plugin}" "${PLUGINS[$plugin]}"
  asdf global "${plugin}" "${PLUGINS[$plugin]}"
done
