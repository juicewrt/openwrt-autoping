#!/bin/sh
# Kontrol dan Status Auto Ping di OpenWRT

TARGET="xl.co.id"
LOG="/tmp/pingstatus.txt"
SCRIPT="/root/pingtest.sh"
REPO_URL="https://raw.githubusercontent.com/juicewrt/openwrt-autoping/main"
PROFILE="/root/.profile"

case "$1" in
    start)
        if pgrep -f "pingtest.sh" >/dev/null; then
            echo "Pingtest sudah berjalan."
        else
            echo "Menjalankan pingtest..."
            screen -dmS pingtest $SCRIPT
            sleep 1
            echo "Pingtest aktif."
        fi
        ;;
    stop)
        if pgrep -f "pingtest.sh" >/dev/null; then
            echo "Menghentikan pingtest..."
            pkill -f "pingtest.sh"
            echo "Pingtest dihentikan."
        else
            echo "Pingtest tidak sedang berjalan."
        fi
        ;;
    status)
        echo "[ Auto Ping Status ]"
        PID=$(pgrep -f "pingtest.sh")
        if [ -n "$PID" ]; then
            echo "Process  : Aktif (PID $PID)"
            echo "Target   : $TARGET"
            if [ -f $LOG ]; then
                echo "Terakhir : $(cat $LOG)"
            else
                echo "Log belum tersedia."
            fi
        else
            echo "Process  : Tidak aktif!"
            if [ -f $LOG ]; then
                echo "Log terakhir: $(cat $LOG)"
            else
                echo "Belum ada log."
            fi
        fi
        ;;
    check)
        echo "[ Auto Ping Status + Log ]"
        PID=$(pgrep -f "pingtest.sh")
        if [ -n "$PID" ]; then
            echo "Process  : Aktif (PID $PID)"
        else
            echo "Process  : Tidak aktif!"
        fi
        if [ -f $LOG ]; then
            echo "---------------------------------------"
            echo "Log isi:"
            tail -n 3 $LOG
        else
            echo "Belum ada log."
        fi
        ;;
    update)
        echo "[+] Memperbarui script dari GitHub..."
        wget -q -O /root/pingtest.sh $REPO_URL/pingtest.sh
        wget -q -O /root/pingtest-control.sh $REPO_URL/pingtest-control.sh
        chmod +x /root/pingtest.sh /root/pingtest-control.sh
        if ! grep -q "pingtest-control.sh" $PROFILE 2>/dev/null; then
            echo "alias pingtest='/root/pingtest-control.sh'" >> $PROFILE
        fi
        echo "[✓] Update selesai! Versi terbaru sudah diinstal."
        ;;
    *)
        echo "Gunakan: pingtest {start|stop|status|check|update}"
        ;;
esac
