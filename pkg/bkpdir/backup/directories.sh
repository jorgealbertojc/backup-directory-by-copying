#!/bin/bash



function ___copydir {

    local DIRECTORY_SOURCE_PATH="${1}"
    local DIRECTORY_TARGET_PATH="${2}"

    ___info "verifying source directory {${DIRECTORY_SOURCE_PATH}} exists"
    if [ ! -d ${DIRECTORY_SOURCE_PATH} ] ; then
        ___error "source directory was {${DIRECTORY_SOURCE_PATH}} not found"
        return 1
    fi
    ___info "source directory {${DIRECTORY_SOURCE_PATH}} validated successfully"

    ___info "verifying that target directory {${DIRECTORY_TARGET_PATH}} exists"
    if [ ! -d ${DIRECTORY_TARGET_PATH} ] ; then
        ___warning "target directory does not exists, will be created"
        mkdir -p ${DIRECTORY_TARGET_PATH}
    fi
    ___info "target directory {${DIRECTORY_TARGET_PATH}} has been validated successfully"

    ___info "start copying files"
    ___line "from ${DIRECTORY_SOURCE_PATH}"
    ___line "to   ${DIRECTORY_TARGET_PATH}"
    if [ ! -z ${BKPDIR_DEBUG} ] ; then
        echo "cp --recursive --verbose --no-clobber ${DIRECTORY_SOURCE_PATH}/* ${DIRECTORY_TARGET_PATH}"
    else
        cp --recursive --verbose --no-clobber ${DIRECTORY_SOURCE_PATH}/* ${DIRECTORY_TARGET_PATH}
    fi
    if [ $? != 0 ] ; then
        ___warning "some files give errors when trying to copy to destination, maybe the disk have damage on this sectors, sorry."
    fi
    ___info "copying files process has been executed"

    return 0
}
