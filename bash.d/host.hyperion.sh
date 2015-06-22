inpath boot2docker && $(boot2docker shellinit 2> /dev/null)

inpath lua-5.1 && \
    alias lua=lua-5.1

update_neovim() {
    brew update
    brew reinstall --HEAD neovim
}


kitt_say() {
    local channel=$1 ; shift
    local message="$@"
    local url=${KITT_URL:-http://viewmasterdev1.corpapps.wc.truecarcorp.com:8000}

    : ${channel:?}
    : ${message:?}

    if ! inpath http; then
        error "Couldn't find 'http' command!"
        return 1
    fi

    http --json "${url}/hook/post_to_channel" \
        channel="${channel}" message="${message}"
}

noggin() {
    docker --tlsverify=true \
        --tlscacert=${HOME}/.docker/ca.pem \
        --tlscert=${HOME}/.docker/cert.pem \
        --tlskey=${HOME}/.docker/key.pem \
        -H tcp://noggin1.corpapps.wc.truecarcorp.com:2376 $@
}
