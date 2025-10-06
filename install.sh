#!/bin/sh
# ================================================
# Auto Installer for OpenWRT Auto Ping (juicewrt)
# ================================================

REPO_URL="https://raw.githubusercontent.com/juicewrt/openwrt-autoping/main"
PROFILE="/root/.profile"
RC_LOCAL="/etc/rc.local"

echo "⚡ Menginstal OpenWRT Auto Ping by juicewrt..."
sleep 1

# --- Download script utama ---
echo "📦 Mengunduh file dari GitHub..."
wget -q -O /root/pingtest.sh $REPO_URL/pingtest.sh
wget -q -O /root/pingtest-control.sh $REPO_URL/pingtest-control.sh

if [ ! -f /root/pingtest.sh ] || [ ! -f /root/pingtest-control.sh ]; then
    echo "❌ Gagal mengunduh file dari GitHub!"
    exit 1
fi

# --- Beri izin eksekusi ---
chmod +x /root/pingtest.sh /root/pingtest-control.sh

# --- Tambah alias pingtest ke profile ---
if ! grep -q "pingtest-control.sh" $PROFILE 2>/dev/null; then
    echo "alias pingtest='/root/pingtest-control.sh'" >> $PROFILE
    echo "✅ Alias 'pingtest' ditambahkan ke $PROFILE"
else
    echo "ℹ️ Alias 'pingtest' sudah ada di $PROFILE"
fi

# --- Tambah autostart di /etc/rc.local ---
if ! grep -q "pingtest.sh" $RC_LOCAL 2>/dev/null; then
    sed -i '/exit 0/d' $RC_LOCAL
    echo "sleep 20 && screen -dmS pingtest /root/pingtest.sh" >> $RC_LOCAL
    echo "exit 0" >> $RC_LOCAL
    echo "✅ Autostart pingtest ditambahkan ke $RC_LOCAL"
else
    echo "ℹ️ Autostart sudah ada di $RC_LOCAL"
fi

# --- Pastikan screen tersedia ---
if ! command -v screen >/dev/null 2>&1; then
    echo "⚙️ Menginstal paket screen..."
    opkg update >/dev/null 2>&1
    opkg install screen >/dev/null 2>&1
fi

echo ""
echo "🎉 Instalasi selesai!"
echo "Kamu bisa jalankan:"
echo "   pingtest m      → buka menu interaktif"
echo "   pingtest start  → mulai ping otomatis"
echo "   pingtest stop   → hentikan ping"
echo ""
echo "Log akan tersimpan di /tmp/pingstatus.txt"
echo ""
echo "💡 Setelah reboot, pingtest akan otomatis aktif (delay 20 detik)."
echo ""
