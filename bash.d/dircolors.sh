# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

[[ -s ${HOME}/.lscolors ]] || curl -sSLo ${HOME}/.lscolors \
  https://raw.githubusercontent.com/trapd00r/LS_COLORS/master/LS_COLORS

[[ $? == 0 ]] || return 1

eval $(gdircolors -b ${HOME}/.lscolors)
