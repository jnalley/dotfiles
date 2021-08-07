# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash
inpath "${1%%.*}" || return 1

export VIRTUAL_ENV_DISABLE_PROMPT=true
export PYTHONBREAKPOINT=pdb.set_trace
