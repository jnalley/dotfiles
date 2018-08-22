# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

inpath "${1%%.*}" || return 1

newer() {
  local range="${1}" ; shift
  local path="${1:-.}" ; shift
  find "${path}" -newermt "$(date +%Y-%m-%d -d "${range}")" -type f -print
}
