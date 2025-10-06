#!/bin/sh
# Auto Ping Control by juicewrt
VERSION="v1.3.4"

LOG="/tmp/pingstatus.txt"
SCRIPT="/root/pingtest.sh"
REPO_URL="https://raw.githubusercontent.com/juicewrt/openwrt-autoping/main"
PROFILE="/root/.profile"

# --- Fungsi bantu: ambil target dari pingtest.sh ---
get_target() {
    if grep -q '^TARGET=' /root/pingtest.sh 2>/dev/null; then
        grep '^TARGET=' /root/pingtest.sh | cut -d'"' -f2
    else
        echo "xl.co.id"
    fi
}

# --- Fungsi: hentikan semua proses pingtest + screen ---
stop_pingtest() {
    PIDLIST=$(ps | grep pingtest.sh | grep -v grep | awk '{print $1}')
    if [ -n "$PIDLIST" ]; then
        echo "$PIDLIST" | xargs kill >/dev/null 2>&1
    fi
    if screen -list 2>/dev/null | grep -q "pingtest"; then
        screen -S pingtest -X quit >/dev/null 2>&1
    fi
    screen -wipe >/dev/null 2>&1
}

# --- Fungsi: perbaiki shebang otomatis jika hilang ---
fix_shebang() {
    if ! grep -q "^#!/bin/sh" /root/pingtest.sh 2>/dev/null; then
        echo "[!] Shebang hilang, menambahkan ulang..."
        sed -i '1i#!/bin/sh' /root/pingtest.sh
    fi
}

case "$1" in
start)
    fix_shebang
    TARGET=$(get_target)
    if pgrep -f "pingtest.sh" >/dev/null 2>&1; then
        echo "Pingtest sudah berjalan (target: $TARGET)."
    else
        echo "Menjalankan pingtest (target: $TARGET)..."
        screen -dmS pingtest $SCRIPT
        sleep 1
        echo "Pingtest aktif."
    fi
    ;;
stop)
    if pgrep -f "pingtest.sh" >/dev/null 2>&1; then
        echo "Menghentikan pingtest..."
        stop_pingtest
        echo "Pingtest dihentikan."
    else
        echo "Pingtest tidak sedang berjalan."
    fi
    ;;
status)
    fix_shebang
    echo "[ Auto Ping Status ]"
    PID=$(pgrep -f "pingtest.sh")
    TARGET=$(get_target)
    if [ -n "$PID" ]; then
        echo "Process  : Aktif (PID $PID)"
        echo "Target   : $TARGET"
        [ -f $LOG ] && echo "Terakhir : $(tail -n 1 $LOG)" || echo "Log belum tersedia."
    else
        echo "Process  : Tidak aktif!"
        echo "Target   : $TARGET"
        [ -f $LOG ] && echo "Log terakhir: $(tail -n 1 $LOG)" || echo "Belum ada log."
    fi
    ;;
check)
    fix_shebang
    echo "[ Auto Ping Status + Log ]"
    PID=$(pgrep -f "pingtest.sh")
    TARGET=$(get_target)
    [ -n "$PID" ] && echo "Process  : Aktif (PID $PID)" || echo "Process  : Tidak aktif!"
    echo "Target   : $TARGET"
    if [ -f $LOG ]; then
        echo "---------------------------------------"
        echo "Log isi:"
        tail -n 5 $LOG
    else
        echo "Belum ada log."
    fi
    ;;
update)
    echo "[+] Memperbarui script dari GitHub..."
    wget -q -O /root/pingtest.sh $REPO_URL/pingtest.sh
    wget -q -O /root/pingtest-control.sh $REPO_URL/pingtest-control.sh
    chmod +x /root/pingtest.sh /root/pingtest-control.sh

    # Auto perbaiki shebang kalau hilang
    fix_shebang

    if ! grep -q "pingtest-control.sh" $PROFILE 2>/dev/null; then
        echo "alias pingtest='/root/pingtest-control.sh'" >> $PROFILE
    fi

    echo "[✓] Update selesai! Versi terbaru sudah diinstal."
    ;;
m)
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
    BLUE='\033[1;34m'; CYAN='\033[0;36m'; NC='\033[0m'

    while true; do
        clear
        fix_shebang
        CURRENT_TARGET=$(get_target)
        PID=$(pgrep -f "pingtest.sh")
        [ -n "$PID" ] && STATUS="${GREEN}AKTIF${NC}" || STATUS="${RED}TIDAK AKTIF${NC}"
        [ -f $LOG ] && LAST=$(tail -n 1 $LOG) || LAST="Belum ada log"

        if command -v uptime >/dev/null 2>&1; then
            UPTIME=$(uptime | sed 's/.*up \([^,]*\),.*/\1/')
        else
            UPTIME="Tidak diketahui"
        fi
        FAIL_COUNT=0
        [ -f $LOG ] && FAIL_COUNT=$(grep -c "GAGAL" $LOG 2>/dev/null)

        echo -e "${CYAN}=================================="
        echo -e "     AUTO PING ${VERSION} (juicewrt)"
        echo -e "==================================${NC}"
        echo -e "Status   : $STATUS"
        echo -e "Target   : ${YELLOW}$CURRENT_TARGET${NC}"
        echo -e "Uptime   : ${YELLOW}$UPTIME${NC}"
        echo -e "Gagal dlm 1 jam: ${RED}$FAIL_COUNT${NC}"
        echo -e "Terakhir : ${YELLOW}$LAST${NC}"
        echo -e "${CYAN}----------------------------------${NC}"
        echo -e "${GREEN}[1]${NC} Start Ping"
        echo -e "${GREEN}[2]${NC} Stop Ping"
        echo -e "${YELLOW}[3]${NC} Status Ping"
        echo -e "${YELLOW}[4]${NC} Check Log"
        echo -e "${BLUE}[5]${NC} Update Script"
        echo -e "${BLUE}[6]${NC} Restart Ping"
        echo -e "${YELLOW}[7]${NC} Reset Log Sekarang"
        echo -e "${CYAN}[8]${NC} Ganti Target Ping"
        echo -e "${RED}[0]${NC} Keluar"
        echo -ne "\nPilih opsi (0-8): "
        read choice

        case "$choice" in
            1) /root/pingtest-control.sh start; read -p "Tekan Enter..." ;;
            2) /root/pingtest-control.sh stop; read -p "Tekan Enter..." ;;
            3) /root/pingtest-control.sh status; read -p "Tekan Enter..." ;;
            4) /root/pingtest-control.sh check; read -p "Tekan Enter..." ;;
            5) /root/pingtest-control.sh update; read -p "Tekan Enter..." ;;
            6)
                echo -e "${YELLOW}Merestart pingtest...${NC}"
                stop_pingtest
                sleep 2
                /root/pingtest-control.sh start
                echo -e "${GREEN}Pingtest telah direstart!${NC}"
                read -p "Tekan Enter..."
                ;;
            7)
                echo -e "${YELLOW}Menghapus log lama...${NC}"
                echo "$(date '+%H:%M:%S') [INFO] Log direset manual." > $LOG
                echo -e "${GREEN}Log berhasil direset!${NC}"
                sleep 1
                ;;
            8)
                echo -ne "${CYAN}Masukkan target baru (contoh: google.com): ${NC}"
                read newtarget
                if [ -n "$newtarget" ]; then
                    sed -i "s|^TARGET=.*|TARGET=\"$newtarget\"|" /root/pingtest.sh
                    echo -e "${YELLOW}Target diganti ke: ${GREEN}$newtarget${NC}"
                    echo -e "${YELLOW}Merestart pingtest...${NC}"
                    stop_pingtest
                    sleep 2
                    /root/pingtest-control.sh start
                    echo -e "${GREEN}Pingtest aktif dengan target baru!${NC}"
                else
                    echo -e "${RED}Target tidak boleh kosong!${NC}"
                fi
                read -p "Tekan Enter..."
                ;;
            0)
                echo -e "${RED}Keluar...${NC}"
                sleep 1
                break
                ;;
            *)
                echo -e "${RED}Pilihan tidak valid!${NC}"
                sleep 1
                ;;
        esac
    done
    ;;
esac
