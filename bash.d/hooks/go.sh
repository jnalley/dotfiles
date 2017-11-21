export GOPATH=${HOME}/Projects/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=${PATH}:${GOPATH}/bin:${GOROOT}/bin

mkdir -p ${GOPATH}/{src,pkg,bin}
