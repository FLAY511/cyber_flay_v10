#!/bin/bash
# CYBER FLAY v10 – White Hat Toolkit
# Gunakan hanya untuk tujuan legal/izin (bug bounty/asset sendiri).

# ===== Warna =====
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'; B='\033[1;34m'; C='\033[1;36m'; N='\033[0m'

# ===== Cek dependensi ringan (sekali jalan) =====
need(){ command -v "$1" >/dev/null 2>&1; }
setup(){
  if ! need curl; then pkg update -y && pkg install -y curl; fi
  if ! need openssl; then pkg install -y openssl; fi
  if ! need exiftool; then pkg install -y perl-exiftool; fi
  if ! need speedtest-cli; then pkg install -y speedtest; fi
  if ! need bc; then pkg install -y bc; fi
  if ! need figlet; then pkg install -y figlet; fi
}
setup >/dev/null 2>&1

# ===== Banner =====
banner(){
  clear
  echo -e "${R}"
  echo "      ██████╗ ██╗   ██╗██████╗ ███████╗██████╗ "
  echo "      ██╔══██╗██║   ██║██╔══██╗██╔════╝██╔══██╗"
  echo "      ██████╔╝██║   ██║██████╔╝█████╗  ██████╔╝"
  echo "      ██╔═══╝ ██║   ██║██╔═══╝ ██╔══╝  ██╔═══╝ "
  echo "      ██║     ╚██████╔╝██║     ███████╗██║     "
  echo "      ╚═╝      ╚═════╝ ╚═╝     ╚══════╝╚═╝     "
  echo -e "${C}        TOOLS INI DIBUAT OLEH CYBER FLAY${N}\n"
  echo -e "${Y}           (っ◕‿◕)っ Hacker Mode${N}\n"
  echo -e "${R}      [!] Seseorang duduk sambil pegang laptop [!]${N}\n"
}

# ===== OSINT =====
osint_menu(){
  clear
  echo -e "${B}===== OSINT MENU =====${N}"
  echo "1. Whois Lookup"
  echo "2. IP Geolocation"
  echo "3. DNS Lookup"
  echo "4. Reverse IP Lookup"
  echo "5. Subdomain Finder"
  echo "6. Port Scanner"
  echo "7. HTTP Header Grabber"
  echo "8. Email Breach Check (link)"
  echo "9. Phone Number Lookup (link)"
  echo "10. Website Tech Detect (WhatCMS)"
  echo "11. SSL Certificate Info"
  echo "12. Screenshot Website (link)"
  echo "13. Search Leak Database (link)"
  echo "14. Metadata Extractor (file)"
  echo "15. Cek Username (50 situs + link)"
  echo
  read -p "Pilih fitur OSINT (1-15): " O

  case "$O" in
    1) read -p "Domain: " d; curl -s "https://api.hackertarget.com/whois/?q=$d" ;;
    2) read -p "IP: " ip; curl -s "https://ipapi.co/$ip/json/" ;;
    3) read -p "Domain: " d; curl -s "https://api.hackertarget.com/dnslookup/?q=$d" ;;
    4) read -p "IP: " ip; curl -s "https://api.hackertarget.com/reverseiplookup/?q=$ip" ;;
    5) read -p "Domain: " d; curl -s "https://api.hackertarget.com/hostsearch/?q=$d" ;;
    6) read -p "Host/IP: " h; curl -s "https://api.hackertarget.com/nmap/?q=$h" ;;
    7) read -p "Domain/URL: " d; curl -s "https://api.hackertarget.com/httpheaders/?q=$d" ;;
    8) read -p "Email: " e; echo "Buka: https://haveibeenpwned.com/account/$e" ;;
    9) read -p "Nomor (+62xxx): " n; echo "Buka: https://numverify.com (input $n) / https://phoneinfoga.crvx.fr/" ;;
    10) read -p "Domain/URL: " d; echo "Deteksi CMS (demo):"; curl -s "https://api.whatcms.org/?key=DEMO&url=$d" ;;
    11) read -p "Domain: " d; echo | openssl s_client -connect "$d:443" -servername "$d" 2>/dev/null | openssl x509 -noout -text ;;
    12) read -p "URL: " u; echo "Screenshot: https://www.url2png.com/ / https://www.screenshotmachine.com/" ;;
    13) read -p "Keyword/email: " k; echo "Cari leak: https://dehashed.com/ atau https://weleakinfo.to/ (cari \"$k\")" ;;
    14) read -p "Path file (jpg/pdf/docx, dll): " f; exiftool "$f" ;;
    15)
      read -p "Username: " user
      echo -e "${Y}Memeriksa 50 situs, mohon tunggu...${N}"
      UA="Mozilla/5.0"
      sites=(
        "facebook.com" "instagram.com" "twitter.com" "tiktok.com/@"
        "github.com" "gitlab.com" "reddit.com/user" "pinterest.com"
        "medium.com/@"
        "stackoverflow.com/users" "quora.com/profile" "tumblr.com"
        "flickr.com/people" "vimeo.com" "soundcloud.com" "open.spotify.com/user"
        "steamcommunity.com/id" "discord.com/users" "t.me" "linkedin.com/in"
        "snapchat.com/add" "ok.ru/profile" "vk.com" "weheartit.com"
        "twitch.tv" "dailymotion.com" "about.me" "producthunt.com/@"
        "hackerone.com" "kaggle.com" "goodreads.com" "last.fm/user"
        "wattpad.com/user" "archive.org/details" "trello.com" "notion.so"
        "canva.com" "dribbble.com" "behance.net" "deviantart.com"
        "flipboard.com" "slideshare.net" "tripadvisor.com/Profile"
        "booking.com" "myanimelist.net/profile" "crunchyroll.com"
        "roblox.com/users" "patreon.com" "fanfiction.net/u"
      )
      for s in "${sites[@]}"; do
        if [[ "$s" == *"/@"* ]]; then
          url="https://${s}${user}"
        else
          url="https://${s}/${user}"
        fi
        code=$(curl -A "$UA" -m 10 -s -L -o /dev/null -w "%{http_code}" "$url")
        if [[ "$code" =~ ^(200|301|302)$ ]]; then
          echo -e "[${G}+${N}] $url"
        else
          echo -e "[${R}-${N}] $url"
        fi
      done
      ;;
    *) echo -e "${R}Pilihan OSINT tidak valid.${N}" ;;
  esac
}

# ===== Pembuatan JSO (MENU 2) =====
jso_menu(){
  clear
  echo -e "${Y}=========================================${N}"
  echo -e "${Y}           P E M B U A T A N   J S O      ${N}"
  echo -e "${Y}=========================================${N}"
  echo -e "${C}(っ◕‿◕)っ  J S O  W I Z A R D${N}\n"
  read -p "Tekan ENTER untuk membuka haxor.my.id..." _
  termux-open-url "https://haxor.my.id"

  echo -e "\n${Y}Jika sudah selesai membuat HTML di browser, kembali ke Termux.${N}"
  read -p "Ketik 'lanjutkan' untuk tempel HTML dan dibuatkan file .jso: " L
  if [[ "$L" != "lanjutkan" ]]; then
    echo -e "${R}Dibatalkan.${N}"; return
  fi

  echo -e "${C}Tempel HTML Anda di bawah (akhiri dengan CTRL+D):${N}"
  tmpfile="$(mktemp)"
  cat > "$tmpfile"

  read -p "Nama file output (tanpa ekstensi) [default: hasil]: " out
  [[ -z "$out" ]] && out="hasil"
  outfile="${out}.jso"

  mv "$tmpfile" "$outfile"

  if [[ -s "$outfile" ]]; then
    echo -e "${G}[+] File berhasil dibuat: ${outfile}${N}"
  else
    echo -e "${R}Gagal membuat JSO (file kosong).${N}"
    rm -f "$outfile" 2>/dev/null
  fi
}

# ===== Menu Lain =====
menu_lain(){
  clear
  echo -e "${B}===== MENU LAIN =====${N}"
  echo "1. Cek Cuaca (wttr.in)"
  echo "2. Kalkulator"
  echo "3. Nama Hacker Random"
  echo "4. Chat AI (Web)"
  echo "5. Base64 Encode/Decode"
  echo "6. Hash (MD5 & SHA256)"
  echo "7. Password Generator (12 char)"
  echo "8. IP Public"
  echo "9. Speedtest"
  echo "10. Kalender"
  echo
  read -p "Pilih (1-10): " U

  case "$U" in
    1) read -p "Kota: " k; curl -s "wttr.in/$k?format=3" ;;
    2) echo "Kalkulator bc (ketik 'quit' untuk keluar)"; bc ;;
    3) arr=("DarkGhost" "CyberNinja" "ShadowX" "NullByte" "RootKing" "ZeroDay" "HexFlay" "AnonMaster" "PhantomSec" "BlackHood"); echo "Nama Hacker: ${arr[$RANDOM % ${#arr[@]}]}" ;;
    4) termux-open-url "https://chat.openai.com" ;;
    5) read -p "Teks: " t; echo "Encode: $(echo -n "$t" | base64)"; echo "Decode: $(echo -n "$t" | base64 -d 2>/dev/null)" ;;
    6) read -p "Teks: " t; echo "MD5    : $(echo -n "$t" | md5sum | cut -d' ' -f1)"; echo "SHA256 : $(echo -n "$t" | sha256sum | cut -d' ' -f1)" ;;
    7) < /dev/urandom tr -dc 'A-Za-z0-9' | head -c 12; echo ;;
    8) curl -s ifconfig.me; echo ;;
    9) speedtest-cli ;;
    10) cal ;;
    *) echo -e "${R}Pilihan tidak valid.${N}" ;;
  esac
}

# ===== Loop Utama =====
while true; do
  banner
  echo -e "${C}[1] OSINT TOOLS"
  echo "[2] Pembuatan JSO"
  echo "[3] Menu Lain"
  echo "[0] Keluar${N}"
  read -p "Pilih menu: " M
  case "$M" in
    1) osint_menu ;;
    2) jso_menu ;;
    3) menu_lain ;;
    0) echo -e "${Y}Terima kasih sudah pakai tools CYBER FLAY!${N}"; exit 0 ;;
    *) echo -e "${R}Pilihan tidak valid!${N}"; sleep 1 ;;
  esac
  echo
  read -p "Tekan Enter untuk kembali ke menu utama..." _
done
