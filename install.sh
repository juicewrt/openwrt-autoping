#!/bin/sh
# Installer Auto Ping untuk OpenWRT
# by ChatGPT x hamdanspotec

REPO_URL="https://raw.githubusercontent.com/juicewrt/openwrt-autoping/main"

echo "[+] Memulai instalasi Auto Ping..."

opkg update >/dev/null 2>&1
opkg install screen >/dev/null 2>&1

wget -q -O /root/pingtest.sh $REPO_URL/pingtest.sh
wget -q -O /root/pingtest-control.sh $REPO_URL/pingtest-control.sh

chmod +x /root/pingtest.sh
chmod +x /root/pingtest-control.sh

if ! grep -q "pingtest-control.sh" /root/.profile 2>/dev/null; then
    echo "alias pingtest='/root/pingtest-control.sh'" >> /root/.profile
fi

if ! grep -q "pingtest.sh" /etc/rc.local 2>/dev/null; then
    sed -i '/exit 0/i sleep 20\nscreen -dmS pingtest /root/pingtest.sh' /etc/rc.local
fi

echo "[+] Instalasi selesai!"
echo
echo "Perintah tersedia:"
echo "  pingtest start   -> mulai auto ping"
echo "  pingtest stop    -> hentikan ping"
echo "  pingtest status  -> lihat status"
echo "  pingtest check   -> lihat isi log"
echo "  pingtest update  -> perbarui script"
