[[ -s ~/.lscolors ]] || curl -sSLo ~/.lscolors \
  https://raw.githubusercontent.com/trapd00r/LS_COLORS/master/LS_COLORS ||
  return 1

dircolors() {
  local cmd=${1}
  inpath "${cmd}" || return
  unset dircolors
  eval "$(${cmd} -b ~/.lscolors)"
}

# (gdircolors on osx)
dircolors dircolors || dircolors gdircolors
