#!/bin/bash



function ___line {

    local MESSAGE_TEXT="${1}"
    echo "  -- [$(date +'%s.%3N')] - ${MESSAGE_TEXT}"
}



function ___print {

    local MESSAGE_TYPE="${1}"
    local MESSAGE_TEXT="${2}"

    echo "$(date +'%FT%TZ')  - ${MESSAGE_TYPE} - ${MESSAGE_TEXT}"
}



function ___info {

    local MESSAGE_TEXT="${1}"
    ___print "INFO" "${MESSAGE_TEXT}"
}



function ___error {

    local MESSAGE_TEXT="${1}"
    ___print "ERRR" "${MESSAGE_TEXT}"
}



function ___success {

    local MESSAGE_TEXT="${1}"
    ___print "SCSS" "${MESSAGE_TEXT}"
}



function ___warning {

    local MESSAGE_TEXT="${1}"
    ___print "WARN" "${MESSAGE_TEXT}"
}
