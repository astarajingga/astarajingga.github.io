---
title: "Cara Membuat API Key di OpenWeatherMap untuk Aplikasi Cuaca"
date: 2025-10-31 09:00:00 +0700
categories: [Tutorial, API]
tags: [OpenWeatherMap, API, Cuaca, Pemrograman, Tutorial]
description: "Panduan lengkap cara membuat API key di OpenWeatherMap untuk mendapatkan data cuaca real-time, prakiraan, dan historis."
image:
  path: https://user-images.githubusercontent.com/84259086/144032703-b5a58856-6a46-4ebf-9ef7-e54275e2643f.PNG
  alt: "Cara Membuat API Key di OpenWeatherMap"
pin: true
---

> 🌤️ **OpenWeatherMap** menyediakan data cuaca global yang bisa kamu akses lewat API.  
> Pada tutorial ini, kita akan belajar cara membuat akun, mendapatkan API key, dan mencoba memanggil data cuaca dengan mudah.

---

# 🧩 Apa Itu API dan OpenWeatherMap?

## 🔗 Apa Itu API?
**API (Application Programming Interface)** adalah sebuah jembatan yang menghubungkan antara dua aplikasi agar bisa saling berkomunikasi.
Dengan API, kita bisa mengambil, mengirim, atau memanipulasi data dari suatu layanan tanpa harus mengetahui cara kerja internal sistem tersebut.

Contohnya:
> Saat kamu membuat aplikasi cuaca, kamu tidak perlu mengumpulkan data cuaca sendiri. 
{: .prompt-tip }

> Cukup panggil **API cuaca** untuk mendapatkan data suhu, kelembapan, dan kondisi langit dari penyedia seperti OpenWeatherMap.
 {: .prompt-tip }
 
🧠 Sederhananya:
> **API = pintu masuk data dari layanan lain ke dalam aplikasimu.**

---

### 🌦️ Apa Itu OpenWeatherMap?

**OpenWeatherMap** adalah layanan penyedia **data cuaca global berbasis API**.  
Melalui API-nya, kamu bisa mendapatkan berbagai informasi seperti:
- [x] Cuaca saat ini (`current weather`)
- [x] Prakiraan cuaca (`forecast`)
- [x] Data historis (`historical data`)
- [x] Kualitas udara (`air pollution`)
- [x] Data suhu, tekanan, kelembapan, dan kecepatan angin

Kelebihan OpenWeatherMap:
- 🌍 Data global dan akurat  
- 💰 Ada paket **gratis** untuk pemula  
- 💻 Mudah diintegrasikan dengan berbagai bahasa pemrograman  
- 📚 Dokumentasi lengkap dan developer-friendly

---

## 🧭 Langkah-Langkah Membuat API Key di OpenWeatherMap

Berikut panduan lengkap untuk mendapatkan API key kamu sendiri.

---

### 🪄 1. Kunjungi Situs Resmi

Buka halaman utama [OpenWeatherMap.org](https://openweathermap.org/)

---

### 🧑‍💻 2. Buat Akun Baru

1. Klik tombol **Sign Up** di kanan atas.  
2. Isi data seperti:
   - Nama pengguna  
   - Email aktif  
   - Password  
3. Lakukan **verifikasi email** yang dikirim oleh OpenWeatherMap.

---

### 🔑 3. Masuk ke Dashboard

Setelah akun aktif, buka halaman:
👉 [https://home.openweathermap.org/](https://home.openweathermap.org/)

Masuk menggunakan email dan password kamu.

---

### ⚙️ 4. Buat API Key

1. Buka menu **API Keys**  
2. Klik **“+ Create Key”**  
3. Masukkan nama API Key (misal: `myweatherapp`)  
4. Klik **Generate**

API key kamu akan muncul di daftar seperti ini:

API Key: abcd1234efgh5678ijkl9012mnop3456

---

> ⚠️ **Jangan bagikan API key kamu ke publik!**.  
{: .prompt-warning }

> Simpan dengan aman di file `.env` atau konfigurasi aplikasi kamu.


---

### 🌐 5. Coba API di Browser atau Postman

Sekarang kamu bisa mencoba mengambil data cuaca berdasarkan nama kota.

**Contoh URL:**
```bash
https://api.openweathermap.org/data/2.5/weather?q=Jakarta&appid=API_KEY_KAMU&units=metric
```

