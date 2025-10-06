#!/bin/sh
# Auto Ping Ringan untuk OpenWRT
# Target default
TARGET="xl.co.id"
LOG="/tmp/pingstatus.txt"
INTERVAL=5

# Auto bersihkan log setiap 24 jam (1 hari)
MAX_LOG_AGE=86400  # 24 jam = 86400 detik
if [ -f $LOG ]; then
    NOW=$(date +%s)
    MODIFIED=$(date +%s -r $LOG)
    AGE=$((NOW - MODIFIED))
    if [ $AGE -ge $MAX_LOG_AGE ]; then
        echo "$(date '+%H:%M:%S') [INFO] Log lama dihapus otomatis." > $LOG
    fi
fi

while true; do
    if ping -c 1 -W 2 $TARGET >/dev/null 2>&1; then
        echo "$(date '+%H:%M:%S') OK - $TARGET aktif" >> $LOG
    else
        echo "$(date '+%H:%M:%S') GAGAL - $TARGET tidak bisa diakses" >> $LOG
    fi
    sleep $INTERVAL
done
