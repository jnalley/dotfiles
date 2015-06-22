# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# use gnu versions if they are available (brew install coreutils)
for CMD in gls gcp gmv grm gmkdir gtar gmd5sum gsha1sum \
            gsha224sum gsha256sum gsha384sum gsha512sum; do
    [[ -x /usr/local/bin/${CMD} ]] && [[ ! -L ${HOME}/local/bin/${CMD:1} ]] && \
        ln -s /usr/local/bin/${CMD} ${HOME}/local/bin/${CMD:1}
done

# enable color ls output
if [[ -L ${HOME}/local/bin/ls ]]; then
    alias ls='ls --color=auto'
fi

# color for BSD ls
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxexexabagacad

# bash completion
source /usr/local/etc/bash_completion 2> /dev/null

# run vagrant commands from anywhere
# <vagrant vm name> <command>
__vagrant() {
    local instance=$1; shift
    [[ -d ~/Projects/vagrant/${instance} ]] || return 1
    (cd ~/Projects/vagrant/${instance} ; exec vagrant $@)
}

for dir in ${HOME}/Projects/vagrant/*; do
    [[ -d ${dir} ]] || continue
    name=${dir##*/}
    eval "function ${name} { __vagrant ${name} \$@; };" \
        "function _${name} { _vagrant \$@; }"
    complete -F _${name} ${name}
done

flushdnscache() {
    sudo discoveryutil mdnsflushcache
}
