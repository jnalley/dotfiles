#!/bin/bash

########################################################################
# helper functions
########################################################################

# search for string inside another string
strstr() {
    case "$2" in *$1*) return 0;; esac
    return 1
}

# convert a string to uppercase
toupper() {
    echo -n $@ | tr '[:lower:]' '[:upper:]'
}

# convert a string to lowercase
tolower() {
    echo -n $@ | tr '[:upper:]' '[:lower:]'
}

# determine if a function/command is callable
inpath() {
    type -p "${1}" > /dev/null
}

# check if needle is in haystack
in_array() {
    local needle=$1; shift
    [[ -z $1 ]] && return 1
    local item
    for item in "$@"; do
        [[ $item = $needle ]] && return 0
    done
    return 1
}

# check if terminal supports color
colorterm() {
    inpath tput && tput setaf 1 >& /dev/null && return 0
    return 1
}

# returns escape code for given color
color() {
    colorterm || return 1
    case "$1" in
        BLACK)        echo -ne '\033[0;30m' ;;
        WHITE)        echo -ne '\033[1;37m' ;;
        BROWN)        echo -ne '\033[0;33m' ;;
        RED)          echo -ne '\033[0;31m' ;;
        GREEN)        echo -ne '\033[0;32m' ;;
        BLUE)         echo -ne '\033[0;34m' ;;
        YELLOW)       echo -ne '\033[1;33m' ;;
        PURPLE)       echo -ne '\033[0;35m' ;;
        CYAN)         echo -ne '\033[0;36m' ;;
        GREY)         echo -ne '\033[1;30m' ;;
        LIGHT_RED)    echo -ne '\033[1;31m' ;;
        LIGHT_GREEN)  echo -ne '\033[1;32m' ;;
        LIGHT_BLUE)   echo -ne '\033[1;34m' ;;
        LIGHT_PURPLE) echo -ne '\033[1;35m' ;;
        LIGHT_CYAN)   echo -ne '\033[1;36m' ;;
        LIGHT_GREY)   echo -ne '\033[0;37m' ;;
        P)            echo -ne '\033[0m'    ;;
    esac
}

# print an error message
error() {
    local MSG="$@"
    echo -e "$(color P)$(color LIGHT_RED)[ERROR]$(color P)" \
        "$(color P)$(color BROWN)${MSG}$(color P)"
}

# print an info message
message() {
    local MSG="$@"
    echo -e "$(color P)$(color GREEN)[INFO]$(color P)" \
        "$(color P)$(color CYAN)${MSG}$(color P)"
}

# create temporary files/directories
_mktemp() {
    mkdir -p ${TMPDIR:-/tmp}
    TMPDIR=${TMPDIR} mktemp ${1:+-d} -t tmp.XXXXX
}

# create a temporary file
tmpfile() {
    _mktemp
}

# create a temporary directory
tmpdir() {
    _mktemp -d
}

# platform agnostic readlink -f
# this replicates GNU readlink -f behavior
# (OSX does not support readlink -f)
linkread() {
    [[ -n "$1" ]] || return 1
    python -c "import os;print(os.path.realpath('$1'))"
}

# download a file using curl
fetch() {
    local URL="${1}"
    local DESTINATION="$(linkread ${2})"

    # skip files if they exist
    [ -f "${DESTINATION}" ] && return 0

    # check for curl
    if ! inpath curl; then
        error "You need to install curl"
        return 1
    fi

    # create ${DESTINATION} directory
    if ! mkdir -p ${DESTINATION%/*}; then
        error "Failed to create ${DESTINATION%/*}!"
        return 1
    fi

    # create a temporary file for the download
    local TMPFILE=$(tmpfile)

    # download the file
    message "Downloading ${DESTINATION##*/}"
    if ! curl --location --progress-bar --output ${TMPFILE} ${URL}; then
        error "Failed to fetch: ${URL}"
        return 1
    fi

    mv ${TMPFILE} ${DESTINATION}
}

unpack() {
    local FILENAME="${1}"
    local DESTINATION="$(linkread ${2})"

    # skip unpacking if the directory already exists
    [[ -d "${DESTINATION}" ]] && return 0

    # create a temporary directory for extraction
    local TMPDIR=$(tmpdir)

    message "Extracting: ${FILENAME##*/}"

    case ${FILENAME} in
        *.tar*|*.tgz)
            local TAROPTS
            case ${FILENAME} in
                *.gz|*.tgz)
                    TAROPTS='-xzf'
                    ;;
                *.bz2)
                    TAROPTS='-xjf'
                    ;;
                *.xz)
                    TAROPTS='-xJf'
                    ;;
                *.lzma)
                    TAROPTS='-x --lzma -f'
                    ;;
                *)
                    error "Unhandled file type for: ${FILENAME}"
                    return 1
                ;;
            esac
            if ! tar -C ${TMPDIR} ${TAROPTS} ${FILENAME}; then
                error "Failed to extract: ${FILENAME}"
                return 1
            fi
            ;;
        *)
            error "Unhandled file type for: ${FILENAME}"
            return 1
            ;;
    esac

    # make sure the extraction results in only a single directory
    local EXTRACTED=( ${TMPDIR}/* )
    if [[ ${#EXTRACTED[@]} != 1 ]]; then
        error "An error occurred while extracting ${FILENAME}"
        return 1
    fi

    # rename the extracted directory to ${DESTINATION}
    mv ${EXTRACTED[0]} ${DESTINATION}
}

# vim: ft=sh:ts=4:sw=4
