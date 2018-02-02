# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

[[ -n $@ ]] || return 1

# git dir status
gds() {
  (
    source ~/.bash.d/helpers.sh
    find . -type d -maxdepth 1 -print | while read dir; do
      [[ -d ${dir} && -d ${dir}/.git ]] || continue
      if [[ -z "$(git -C ${dir} status --porcelain)" ]]; then
        [[ ${1} == "-a" ]] || continue
        echo -e "- $(color P; color GREEN)${dir##./}$(color P)"
      else
        echo -e "* $(color P; color RED)${dir##./}$(color P)"
      fi
    done
  )
}
