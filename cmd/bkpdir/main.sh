#!/bin/bash



function ___include {

    source ${BKPDIR_PKG_HELPERS_DIRPATH}/print.sh

    source ${BKPDIR_PKG_BACKUPS_DIRPATH}/directories.sh
}



function ___help {

    echo "Usage:"
    echo "    ./$(basename ${0}) <config-filepath>"
    echo "    example: ./$(basename ${0}) ./config.yml"
}



function ___main {

    if [ $# == 0 ] ; then
        ___help
        return 1
    fi

    local BKPDIR_FILEPATH="$(realpath ${0})"
    local BKPDIR_DIRPATH="$(dirname ${BKPDIR_FILEPATH})"
    local BKPDIR_ROOT_DIRPATH="$(dirname $(dirname ${BKPDIR_DIRPATH}))"
    local BKPDIR_CONFIGURATION_FILEPATH="$(realpath ${1})"

    local BKPDIR_PKG_HELPERS_DIRPATH="${BKPDIR_ROOT_DIRPATH}/pkg/bkpdir/helpers"
    local BKPDIR_PKG_BACKUPS_DIRPATH="${BKPDIR_ROOT_DIRPATH}/pkg/bkpdir/backup"

    ___include
    if [ $? != 0 ] ; then
        echo "ERROR: cannot import script dependencies"
        return 2
    fi

    if [ ! -f ${BKPDIR_CONFIGURATION_FILEPATH} ] ; then
        ___error "cannot read configuration file from ${BKPDIR_CONFIGURATION_FILEPATH}"
        return 3
    fi

    local BKPDIR_CONFIGURATION_FILECONTENTS=$(cat ${BKPDIR_CONFIGURATION_FILEPATH} | yq -r '.')
    local BKPDIR_CONFIGURATION_DESCRIPTION=$(echo ${BKPDIR_CONFIGURATION_FILECONTENTS} | jq -r '.description')

    echo "==== ${BKPDIR_CONFIGURATION_DESCRIPTION} ===="
    echo ""

    ___info "starting directory backups"

    for DIRECTORY_ID in $( echo ${BKPDIR_CONFIGURATION_FILECONTENTS} | jq -r '.directories[]._id' ) ; do
        local BKPDIR_BACKUP_DIRECTORY_ID=${DIRECTORY_ID}
        ___info "starting backing up process {${BKPDIR_BACKUP_DIRECTORY_ID}}"

        local BKPDIR_BACKUP_DIRECTORY=$(echo ${BKPDIR_CONFIGURATION_FILECONTENTS} | jq -r '.directories[] | select( ._id == "'${BKPDIR_BACKUP_DIRECTORY_ID}'" )')
        local BKPDIR_BACKUP_DIRECTORY_DESCRIPTION=$(echo ${BKPDIR_BACKUP_DIRECTORY} | jq -r '.description')
        local BKPDIR_BACKUP_DIRECTORY_PATH_SOURCE=$(echo ${BKPDIR_BACKUP_DIRECTORY} | jq -r '.paths.source')
        local BKPDIR_BACKUP_DIRECTORY_PATH_TARGET=$(echo ${BKPDIR_BACKUP_DIRECTORY} | jq -r '.paths.target')

        ___info "migrating directory ${BKPDIR_BACKUP_DIRECTORY_ID}"
        ___line "${BKPDIR_BACKUP_DIRECTORY_ID} / ${BKPDIR_BACKUP_DIRECTORY_DESCRIPTION}"
        ___line " · · · · source directory {${BKPDIR_BACKUP_DIRECTORY_PATH_SOURCE}}"
        ___line " · · · · target directory {${BKPDIR_BACKUP_DIRECTORY_PATH_TARGET}}"

        ___copydir "${BKPDIR_BACKUP_DIRECTORY_PATH_SOURCE}" "${BKPDIR_BACKUP_DIRECTORY_PATH_TARGET}"
        if [ $? != 0 ] ; then
            ___error "something goes wrong copying files"
            return 3
        fi
    done

    ___success "directory backups has done successfully"
    echo "==== DONE ===="
}



___main "${@}"
