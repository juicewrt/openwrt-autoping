#!/bin/sh
# ==========================================================
# Auto Ping Installer for OpenWRT
# by juicewrt (github.com/juicewrt/openwrt-autoping)
# ==========================================================

REPO_URL="https://raw.githubusercontent.com/juicewrt/openwrt-autoping/main"

echo "[+] Memulai instalasi Auto Ping untuk OpenWRT..."

# -------------------------------
# 1. Pastikan 'screen' tersedia
# -------------------------------
if ! command -v screen >/dev/null 2>&1; then
    echo "[+] Menginstal paket 'screen'..."
    opkg update >/dev/null 2>&1
    opkg install screen >/dev/null 2>&1
else
    echo "[✓] Paket 'screen' sudah terinstal."
fi

# -------------------------------
# 2. Unduh script utama & kontrol
# -------------------------------
echo "[+] Mengunduh file dari GitHub..."
wget -q -O /root/pingtest.sh $REPO_URL/pingtest.sh
wget -q -O /root/pingtest-control.sh $REPO_URL/pingtest-control.sh
chmod +x /root/pingtest.sh /root/pingtest-control.sh

# -------------------------------
# 3. Tambahkan alias global permanen
# -------------------------------
PROFILE="/root/.profile"
ASHRC="/etc/profile"
BASHRC="/root/.bashrc"

for FILE in $PROFILE $ASHRC $BASHRC; do
    if [ -f "$FILE" ]; then
        if ! grep -q "pingtest-control.sh" "$FILE" 2>/dev/null; then
            echo "alias pingtest='/root/pingtest-control.sh'" >> "$FILE"
            echo "[+] Alias 'pingtest' ditambahkan ke $FILE"
        fi
    fi
done

# Tambahkan source otomatis di rc.local biar alias aktif tiap boot
if ! grep -q ". /root/.profile" /etc/rc.local 2>/dev/null; then
    sed -i '/exit 0/i . /root/.profile' /etc/rc.local
    echo "[+] Menambahkan auto-load alias di /etc/rc.local"
fi

# -------------------------------
# 4. Tambahkan autostart pingtest
# -------------------------------
if ! grep -q "pingtest.sh" /etc/rc.local 2>/dev/null; then
    sed -i '/exit 0/i sleep 20\nscreen -dmS pingtest /root/pingtest.sh' /etc/rc.local
    echo "[+] Autostart pingtest ditambahkan ke /etc/rc.local"
else
    echo "[✓] Autostart sudah ada di /etc/rc.local"
fi

# -------------------------------
# 5. Selesai
# -------------------------------
echo ""
echo "[✓] Instalasi Auto Ping selesai!"
echo ""
echo "Perintah tersedia:"
echo "  pingtest start   -> mulai auto ping"
echo "  pingtest stop    -> hentikan auto ping"
echo "  pingtest status  -> lihat status"
echo "  pingtest check   -> lihat isi log"
echo "  pingtest m       -> buka menu interaktif"
echo "  pingtest update  -> perbarui script"
echo ""
echo "Alias aktif otomatis tiap reboot ✅"
echo "Script ping otomatis berjalan 20 detik setelah boot ⚙️"
