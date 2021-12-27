# vim: set ft=sh:ts=2:sw=2:noet:nowrap # bash

[[ -s ~/.lscolors ]] || return 1

for _ in dircolors gdircolors; do
  inpath $_ && eval "$($_ -b ~/.lscolors)"
done

unalias ll 2>/dev/null
unset -f ll 2>/dev/null

if inpath exa; then
  ll() {
    exa -laF \
      --group-directories-first \
      --no-filesize \
      --no-permissions \
      --octal-permissions \
      --sort Name \
      --time-style long-iso "$@"
  }
elif command ls --version 2>/dev/null | grep -qi 'GNU'; then
  # depends on gnu ls
  ll() {
    local extra=()
    [[ -z $* ]] && extra+=('--dereference')
    colorterm && extra+=('--color=always')
    command ls -ov \
      --almost-all \
      --escape \
      --classify \
      --human-readable \
      --group-directories-first \
      --literal \
      --time-style=+'%G:%m:%d %T' \
      "${extra[@]}" "$@" | awk \
      '{
      k=0;for(i=0;i<=8;i++)
      k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));
      if(k)printf("[%0o]",k);$1="";$2="";s=$4;$4="";print
    }' | grep -v '^[[:space:]]*$'
  }
  alias ls='command ls --color=auto'
else
  # fallback to safe options
  alias ll="command ls -AbFho"
fi
