#!/bin/bash


BACKUP_LOG_FILEPATH=/tmp/$(date +'%F-%s.%3N')-$(basename $(pwd)).log
# BKPDIR_DEBUG=yes

bash ./cmd/bkpdir/main.sh ./configs/2022-09-backing-pup-multimedia-disk-directories/config.yml >> ${BACKUP_LOG_FILEPATH} 2>&1 &
disown

PROCESS_UUID=$(ps xa | grep 'bkpdir' | grep -v 'grep' | awk '{print $1}')
echo "Process running with the UUID ${PROCESS_UUID}"
echo ""

# tail -f ${BACKUP_LOG_FILEPATH}
