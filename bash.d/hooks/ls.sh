# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

[[ -n $@ ]] || return 1

# my fancy ll depends on gnu ls
if command ls --version | grep -qi 'GNU'; then
  ll() {
    local extra=''
    [[ -z $@ ]] && extra+=' --dereference '
    [[ ${COLOR_COUNT} -ge 8 ]] && extra+=' --color=always '
    command ls -ov \
    --almost-all \
    --escape \
    --classify \
    --human-readable \
    --group-directories-first \
    --literal \
    --time-style=+'%G:%m:%d %T' \
    ${extra} "$@" | awk \
    '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i)); \
    if(k)printf("[%0o]",k);$1="";$2="";s=$4;$4="";print}' | grep -v '^[[:space:]]*$'
    }
else
  # fallback to safe options
  alias ll="command ls -AbFho"
fi
