#!/bin/bash

SOURCE="$HOME/"
DESTINATION="/tmp/backup"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# логирование 
log_to_syslog() {
    local message="$1"
    logger -t "backup_hw" "$message"
}

# синхронизация
rsync -av --delete -c "$SOURCE" "$DESTINATION" 2>&1 | while read line; do
    log_to_syslog "RSYNC: $line"
done
