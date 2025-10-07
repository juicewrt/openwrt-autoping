<h1 align="center">📡 juicewrt // autoping.sh</h1>
<p align="center">
  <b>monitor koneksi & kendali ping otomatis untuk openwrt & stb</b><br>
  <i>ringan, stabil, dan mudah dikontrol dari terminal ⚡</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-v1.3.4-green?style=for-the-badge&logo=linux&logoColor=white">
  <img src="https://img.shields.io/badge/openwrt-compatible-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/controller-menu-orange?style=for-the-badge">
  <img src="https://img.shields.io/badge/screen-session-yellow?style=for-the-badge">
</p>

---

## 🧠 Tentang
**AutoPing v1.3.4** adalah versi terbaru dari _Auto Ping Control_ buatan **juicewrt**,  
sebuah utilitas ringan untuk memantau koneksi internet di sistem **OpenWrt / STB**.  

Script ini bekerja bersama dua file:
- `/root/pingtest.sh` → loop utama untuk _ping target_ dan logging  
- `/root/pingtest-control.sh` → interface pengendali (start, stop, status, update, menu interaktif)

Dengan versi baru ini, sistem **tidak lagi restart OpenClash atau injek** — hanya memonitor dan mencatat status koneksi, aman untuk semua setup jaringan.

---

## 🚀 Fitur Baru (v1.3.4)
- 🧩 **CLI Menu Interaktif (`-m` mode)** — tampilkan status, log, uptime, dan menu kendali.  
- 🧱 **Auto perbaiki shebang** kalau hilang di `/root/pingtest.sh`.  
- 🧠 **Deteksi target otomatis** (`TARGET=` diambil langsung dari script pingtest).  
- 🧹 **Pembersihan screen otomatis** (`screen -wipe`) setiap stop.  
- ⚙️ **Update langsung dari GitHub** (`pingtest-control.sh update`).  
- 📋 **Alias otomatis** `pingtest` di `.profile`.  
- ⚡ **Tidak restart OpenClash / Zerotier / Injek apapun.**  

---

## ⚙️ Instalasi
```bash
wget -qO- https://raw.githubusercontent.com/juicewrt/openwrt-autoping/main/install.sh | sh
