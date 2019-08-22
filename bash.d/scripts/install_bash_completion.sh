#!/usr/bin/env bash

# - Install bash completion from source -
#
# Although bash completion is generally available through packages, (e.g.
# homebrew, apt) these packages can be quite outdated. More recent versions
# of bash completion supports dynamic loading which prevents potential delay
# when starting new shells.

RAW_GIT_URL='https://raw.githubusercontent.com'

: "${VERSION:=2.9}"
: "${DESTDIR:=${HOME}/local}"
: "${BASE_URL:=https://github.com/scop/bash-completion/releases/download/}"

BASH_COMPLETION_URL="${BASE_URL}/${VERSION}/bash-completion-${VERSION}.tar.xz"

declare -A extras=(
  [git]="${RAW_GIT_URL}/git/git/master/contrib/completion/git-completion.bash"
)

die() { echo -e "$*" ; exit 1 ; }

tmp=$(mktemp -d -t tmp.XXXXX) || \
  die "Failed to create temporary directory!"

# shellcheck disable=SC2064
trap "rm -r ${tmp}" EXIT

curl -sSL "${BASH_COMPLETION_URL}" | \
  tar -C "${tmp}" -xJ --strip-components=1 || \
    die "Failed to download: ${BASH_COMPLETION_URL}"

(cd "${tmp}" && ./configure --prefix="${DESTDIR}" && make install) || \
  die "Failed to install bash-completion-${VERSION}!"

[[ -d "${DESTDIR}/share/bash-completion/completions" ]] || \
  die "Completions directory missing!"

for extra in "${!extras[@]}"; do
  curl -sSL -o "${DESTDIR}/share/bash-completion/completions/${extra}" \
    "${extras[${extra}]}" || die "Failed to download: ${extras[${extra}]}"
done
