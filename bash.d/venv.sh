#!/bin/bash

venv() {
    local VENV_VERSION='12.0.5'
    local VENV_URL="https://pypi.python.org/packages/source/v/virtualenv/virtualenv-${VENV_VERSION}.tar.gz"
    local VENV_BASE=${HOME}/local/python/venv
    local VENV_BOOTSTRAP=${VENV_BASE}/bootstrap
    local VENV_OPTS='--no-site-packages --distribute'
    local CMD="${1}"

    shift

    # install virtualenv
    venv_bootstrap() {
        # check for python
        if ! inpath python; then
            error "You need to install python!"
            return 1
        fi
        # create temp dir
        local TMPDIR=$(TMPDIR=${HOME}/local/tmp tmpdir)
        # get virtualenv
        fetch ${VENV_URL} ${TMPDIR}/${VENV_URL##*/} || return 1
        # unpack the tarball
        unpack ${TMPDIR}/${VENV_URL##*/} ${TMPDIR}/virtualenv || return 1
        # create the first "bootstrap" environment.
        ${PYTHON} ${TMPDIR}/virtualenv/virtualenv.py ${VENV_OPTS} ${VENV_BOOTSTRAP}
        # install virtualenv into ${VENV_BOOTSTRAP}
        ${VENV_BOOTSTRAP}/bin/pip install ${TMPDIR}/${VENV_URL##*/}
        # cleanup
        rm -rf ${TMPDIR}
    }

    # list virtualenvs
    venv_list() {
        local venv
        local active=$(linkread ${VENV_BASE}/active)
        [[ -d ${VENV_BASE} ]] || return 1
        for venv in ${VENV_BASE}/*; do
            local flag=0
            [[ ${venv} == ${active} ]] && flag=1
            venv=${venv##*/}
            [[ ${venv} == "active" || ${venv} == "bootstrap" ]] && \
                continue
            if [[ ${flag:-0} -eq 1 ]]; then
                echo -e "$(color P)$(color GREEN)<${venv}>$(color P)"
            else
                echo -e "$(color P)$(color LIGHT_BLUE)[${venv}]$(color P)"
            fi
        done
    }

    # activate a virtualenv
    venv_activate() {
        local venvname=${1:-active}
        local venvdir=${VENV_BASE}/${venvname}
        local activate=${venvdir}/bin/activate
        [[ -d ${venvdir} ]] || return 1
        if [[ ${venvname} == 'bootstrap' ]]; then
            error "Do not activate 'bootstrap'"
            return 1
        fi
        if [[ ! -f ${activate} ]]; then
            error "${venvname} does not contain an activate script!"
            return 1
        fi
        if ! source ${activate} 2> /dev/null; then
            error "Failed to activate ${venvname}"
            return 1
        fi
        [[ ${venvname} == 'active' ]] && return 0
        ln -snf ${venvname} ${VENV_BASE}/active
    }

    # create a new virtualenv
    venv_new() {
        local venvname=${1}
        local venvdir=${VENV_BASE}/${venvname}
        if [[ ! -d ${VENV_BOOTSTRAP} ]]; then
            error "Run 'venv bootstrap' first"
            return 1
        fi
        if [[ -d ${venvdir} ]]; then
            error "${venvdir} already exists"
            return 1
        fi
        ${VENV_BOOTSTRAP}/bin/virtualenv ${VENV_OPTS} ${venvdir} && \
            venv activate ${venvname}
    }

    # remove a virtualenv
    venv_rm() {
        local venvname=${1}
        local active=$(linkread ${VENV_BASE}/active)
        if [[ -z ${venvname} ]]; then
            venv usage
            return 1
        fi
        if [[  ${VENV_BASE}/${venvname} == ${active} ]]; then
            error "You can't remove the active environment"
            return 1
        fi
        if [[ ! -d ${VENV_BASE}/${venvname} ]]; then
            error "${venvname} does not exist!"
            return 1
        fi
        echo -n "Are you sure? (y/n)"
        read -sn1 response && echo
        [[ ${response:-n} == 'y' ]] && \
            rm -rf ${VENV_BASE}/${venvname}
    }

    case "${CMD}" in
        bootstrap)
            venv_bootstrap ${@} ;;
        new)
            venv_new ${@} ;;
        activate)
            venv_activate ${@} ;;
        list)
            venv_list ;;
        rm)
            venv_rm ${@} ;;
        *help)
            echo "Usage:"
            echo "    venv bootstrap       -  Install virtualenv"
            echo "    venv list            -  List virtual environments"
            echo "    venv new <name>      -  Create a new virtual environment"
            echo "    venv activate <name> -  Activate the virtual environment"
            echo "    venv rm <name>       -  Remove the virtual environment"
            ;;
        *)
            [[ -z "${CMD}" ]] && venv_list && return 0

            if [[ -d ${VENV_BASE}/${CMD} ]]; then
                venv_activate ${CMD}
            else
                venv_new ${CMD}
            fi
            ;;
    esac
}
