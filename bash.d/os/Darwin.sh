# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# use gnu versions if they are available
# - brew install coreutils gnu-tar findutils
for CMD in gcp gdircolors gfind gls gmd5sum gmkdir gmv grm gsha1sum \
    gsha224sum gsha256sum gsha384sum gsha512sum gtar; do
  [[ -x /usr/local/bin/${CMD} ]] && [[ ! -L ${HOME}/local/bin/${CMD:1} ]] && \
  ln -s /usr/local/bin/${CMD} ${HOME}/local/bin/${CMD:1}
done

# enable color ls output
if [[ -L ${HOME}/local/bin/ls && -x ${HOME}/local/bin/ls ]]; then
  alias ls='ls --color=auto'
fi

# color for BSD ls
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxexexabagacad

# bash completion
source /usr/local/etc/bash_completion 2> /dev/null

# homebrew
source ~/.homebrew.key 2> /dev/null

# install iterm2 preferences
if [[ ! -s ${HOME}/.iterm2/com.googlecode.iterm2.plist ]]; then
  mkdir -p ${HOME}/.iterm2
  echo -e "\nDownloading iTerm preferences...\n"
  curl -sSLo ${HOME}/.iterm2/com.googlecode.iterm2.plist \
  'https://drive.google.com/uc?export=download&id=0B0o1linrX7FoSmVMVWpTS2R5b1E'
fi
