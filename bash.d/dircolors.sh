# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

[[ -s ~/.lscolors ]] || curl -sSLo ~/.lscolors \
  https://raw.githubusercontent.com/trapd00r/LS_COLORS/master/LS_COLORS

[[ $? == 0 ]] && inpath dircolors || return 1

eval $(dircolors -b ~/.lscolors)
