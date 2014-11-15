# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# enable color ls output
export CLICOLOR=1

# use gnu versions if they are available (brew install coreutils)
for CMD in gcp gmv grm gmkdir gmd5sum gsha1sum \
            gsha224sum gsha256sum gsha384sum gsha512sum; do
    [[ -x /usr/local/bin/${CMD} ]] && [[ ! -L ${HOME}/local/bin/${CMD} ]] && \
        ln -s /usr/local/bin/${CMD} ${HOME}/local/bin/${CMD:1}
done

inpath coreosx && eval $(coreosx env)
