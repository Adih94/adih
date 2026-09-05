# Aplikasi Belajar (Flutter) — PRD

## Problem statement
Clone project Flutter dari GitHub (github.com/Adih94/adih) — aplikasi belajar anak
(Huruf, Piano, Menulis) — dan jalankan sebagai Flutter Web di preview. Project belum lengkap.

## Architecture
- Flutter app (target: android, ios, web, desktop). Dijalankan sebagai **Flutter Web**.
- Flutter SDK di /root/flutter (persistent). Build: `flutter build web --release --no-web-resources-cdn`
  (CanvasKit di-serve lokal karena gstatic CDN diblokir di preview).
- Preview: supervisor `frontend` menjalankan `yarn start` di /app/frontend → node server.js
  meng-serve /app/build/web di PORT/HOST dari supervisor. Tidak ada backend (murni offline/lokal).
- Guard locale ditambahkan di /app/web/index.html untuk mencegah crash
  "Incorrect locale information provided" pada browser dengan locale tidak valid.

## Implemented
- 2026-09-05: Clone + jalankan sebagai Flutter Web (berhasil tampil).
- 2026-09-05: Menu "Mengenal Huruf A–Z" — layout & latar **identik dengan halaman A asli**
  untuk semua huruf (latar lavender bg_letter_base.png = letter_a_activity tanpa apel/label,
  huruf gelembung bergaris putus-putus di kiri, tanda "=", ilustrasi kawaii berwajah di kanan,
  label kata pill putih). Hanya warna huruf yang berbeda, bergilir:
  hijau, biru, oranye, merah, ungu, pink, kuning (A hijau, B biru, C oranye, ...).
  Aset: assets/images/letter_a..z.png (huruf, transparan), illus_a..z.png (ilustrasi, transparan).
  Huruf/ilustrasi digenerate dengan latar cyan/magenta lalu di-chroma-key (script /app/gen_tmp/key.py).
  File: lib/screens/lesson/letter_lesson_screen.dart (stage tetap 1809x869, BoxFit.cover).
  Deep link uji: `/?screen=huruf` langsung membuka layar huruf (lib/app.dart).
  Kata: A Apel, B Beruang, C Cicak, D Durian, E Es Krim, F Foto, G Gajah, H Harimau,
  I Ikan, J Jeruk, K Kucing, L Lampu, M Mangga, N Nanas, O Orang, P Pisang, Q Queen,
  R Roti, S Sapi, T Topi, U Ular, V Vas, W Wortel, X Xilofon, Y Yoyo, Z Zebra.

- 2026-09-05: Suara huruf & kata diganti dari TTS robot ke **MP3 bundel** (offline).
  Digenerate sekali via OpenAI TTS `tts-1-hd`, voice `nova` (perempuan ceria) memakai Emergent LLM Key —
  script `tools/gen_audio.py` (jalankan: `EMERGENT_LLM_KEY=... python3 tools/gen_audio.py`).
  Aset: assets/audio/letters/a..z.mp3 (abjad Indonesia: A, Bé, Ché, Dé, …, Zet) dan assets/audio/words/a..z.mp3.
  Interaksi: tekan huruf → bunyi huruf; tekan gambar/label → bunyi kata; tombol speaker → huruf lalu kata;
  ganti huruf (panah) → otomatis bunyi huruf+kata. Pemutar: package audioplayers (AssetSource).

## Backlog
- P1: Modul Angka, Membaca (suku kata), Piano, Menulis, Mewarnai masih placeholder.
- P2: Kuis huruf (tebak huruf dari gambar), bintang progres per huruf.
- Catatan: bila pengucapan huruf tertentu kurang pas, ubah teks fonetiknya di tools/gen_audio.py,
  hapus mp3 terkait, jalankan ulang script, lalu `flutter build web`. / Next
- P1: Rekaman suara asli per huruf (saat ini pakai flutter_tts; TTS di web bisa tidak stabil).
- P1: Isi konten modul lain yang masih dummy (Piano, Menulis, Membaca, Angka, Mewarnai).
- P2: Ganti kata/ilustrasi tertentu sesuai selera (mis. Q, F, O).
