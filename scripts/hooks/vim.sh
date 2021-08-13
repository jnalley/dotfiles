# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

# prefer nvim fallback to vim
for EDITOR in nvim vim; do
  inpath "${EDITOR}" && export EDITOR && break
done
