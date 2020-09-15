inpath "${1%%.*}" || return 1

source "${HOMEBREW_PREFIX}/opt/asdf/asdf.sh"
source "${HOMEBREW_PREFIX}/opt/asdf/etc/bash_completion.d/asdf.bash"
