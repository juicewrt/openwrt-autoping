<h1 align="center">📡 juicewrt // autoping.sh</h1>
<p align="center">
  <b>monitor koneksi & auto-restart tunnel / vpn untuk openwrt & stb</b><br>
  <i>stabil, ringan, tanpa loop — deteksi delay & loss realtime ⚡</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-v1.3.3-green?style=for-the-badge&logo=linux&logoColor=white">
  <img src="https://img.shields.io/badge/openwrt-compatible-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/autoping-active-orange?style=for-the-badge">
  <img src="https://img.shields.io/badge/recovery-auto-yellow?style=for-the-badge">
</p>

---

## 🧠 Tentang
`autoping.sh` adalah utilitas buatan **juicewrt** untuk menjaga koneksi OpenWrt tetap hidup secara otomatis.  
Script ini secara berkala:
- mem-*ping* host (misalnya `8.8.8.8` atau `xl.co.id`),
- menulis log status koneksi,
- dan menjalankan tindakan pemulihan (restart tunnel, service, atau ping loop) bila terdeteksi koneksi terputus.

Cocok digunakan bersama **OpenClash**, **Passwall**, **Trojan**, **Vmess**, atau mode **bypass hybrid**.

---

## 🚀 Fitur Utama
- 📶 **Ping interval adaptif (custom 5-60 detik)**  
- 🧩 **Deteksi delay tinggi dan auto-log event**  
- 🔁 **Restart otomatis tunnel / service yang gagal**  
- 🧠 **Auto deteksi target dari konfigurasi (`TARGET=`)**  
- 💾 **Log realtime di `/tmp/pingstatus.txt`**  
- ⚡ **Tidak pakai loop berat — sangat ringan**  
- 🧱 **Dapat dijalankan sebagai background service via `/etc/rc.local`**

---

## ⚙️ Instalasi
```bash
wget -O /usr/bin/autoping.sh https://raw.githubusercontent.com/juicewrt/openwrt-autoping/main/autoping.sh
chmod +x /usr/bin/autoping.sh
/usr/bin/autoping.sh
