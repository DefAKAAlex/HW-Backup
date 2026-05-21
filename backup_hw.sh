#!/bin/bash

SOURCE="$HOME/"
DESTINATION="/tmp/backup"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="/var/log/backup_hw.log"

# логирование
log_to_syslog() {
    local message="$1"
    logger -t "backup_hw" "$message"
    echo "$TIMESTAMP - $message" >> "$LOG_FILE"
}

# синхронизация
rsync -av --delete -c "$SOURCE" "$DESTINATION" 2>&1 | while read line; do
    log_to_syslog "RSYNC: $line"
done

# Проверка статуса выполнения
RSYNC_EXIT_CODE=${PIPESTATUS[0]}

if [ $RSYNC_EXIT_CODE -eq 0 ]; then
    log_to_syslog "SUCCESS: Backup OK $SOURCE в $DESTINATION"
    exit 0
else
    log_to_syslog "ERROR: Code err- $RSYNC_EXIT_CODE"
    exit $RSYNC_EXIT_CODE
fi
