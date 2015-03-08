# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# enable color ls output
export CLICOLOR=1

# use gnu versions if they are available (brew install coreutils)
for CMD in gcp gmv grm gmkdir gtar gmd5sum gsha1sum \
            gsha224sum gsha256sum gsha384sum gsha512sum; do
    [[ -x /usr/local/bin/${CMD} ]] && [[ ! -L ${HOME}/local/bin/${CMD} ]] && \
        ln -s /usr/local/bin/${CMD} ${HOME}/local/bin/${CMD:1}
done

inpath coreosx && eval $(coreosx env)

reset-dns-cache() {
    sudo discoveryutil mdnsflushcache
}

# run vagrant commands from anywhere
# <vagrant vm name> <command>
__vagrant() {
    local instance=$1; shift
    [[ -d ~/Projects/vagrant/${instance} ]] || return 1
    (cd ~/Projects/vagrant/${instance} ; vagrant $@)
}

for dir in ${HOME}/Projects/vagrant/*; do
    [[ -d ${dir} ]] || continue
    name=${dir##*/} 
    eval "function ${name} { __vagrant ${name} \$@; };" \
         "function _${name} { _vagrant \$@; }"
    complete -F _${name} ${name}
done
