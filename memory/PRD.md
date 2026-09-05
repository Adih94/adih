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
- 2026-09-05: Menu "Mengenal Huruf A–Z" — sebelumnya hanya A (dan B parsial).
  Direfaktor jadi **1 layout dipakai semua huruf** (huruf besar+kecil + ilustrasi kata),
  lengkap A–Z. File: lib/screens/lesson/letter_lesson_screen.dart.
  Ilustrasi 26 kata Indonesia digenerate & disimpan di assets/images/illus_a..z.png,
  background bersama assets/images/bg_letter_generic.png.
  Kata: A Apel, B Beruang, C Cicak, D Durian, E Es Krim, F Foto, G Gajah, H Harimau,
  I Ikan, J Jeruk, K Kucing, L Lampu, M Mangga, N Nanas, O Orang, P Pisang, Q Queen,
  R Roti, S Sapi, T Topi, U Ular, V Vas, W Wortel, X Xilofon, Y Yoyo, Z Zebra.

## Backlog / Next
- P1: Rekaman suara asli per huruf (saat ini pakai flutter_tts; TTS di web bisa tidak stabil).
- P1: Isi konten modul lain yang masih dummy (Piano, Menulis, Membaca, Angka, Mewarnai).
- P2: Ganti kata/ilustrasi tertentu sesuai selera (mis. Q, F, O).
