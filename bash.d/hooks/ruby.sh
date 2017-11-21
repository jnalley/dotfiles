# this script should only ever be sourced
# [[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

export PATH=$(
  IFS=':' read -a gempath <<< $(gem environment gempath)
  gempath=$(printf ":%s" "${gempath[@]/%//bin}")
  echo ${gempath:1}
):${PATH}
