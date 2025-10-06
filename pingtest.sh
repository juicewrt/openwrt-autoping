#!/bin/sh
# Auto Ping Ringan untuk OpenWRT
# Target: xl.co.id

TARGET="xl.co.id"
LOG="/tmp/pingstatus.txt"
INTERVAL=5

while true; do
    if ping -c 1 -W 2 $TARGET >/dev/null 2>&1; then
        echo "$(date '+%H:%M:%S') OK - $TARGET aktif" > $LOG
    else
        echo "$(date '+%H:%M:%S') GAGAL - $TARGET tidak bisa diakses" > $LOG
    fi
    sleep $INTERVAL
done
