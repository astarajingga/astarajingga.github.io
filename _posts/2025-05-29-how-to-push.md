---
title: HOW TO PUSH
description: Berikut adalah contoh penulisan untuk melakukan update pada website Jekyll (static) pada GitHub. 
categories: [Setup]
tags: [github]
math: true
mermaid: true
---

# Langkah-Langkah Push ke GitHub

Langkah-langkah ini ditulis karena keterbatasan daya ingat saya — maklum, saya seorang pelupa, hehe.

## 1. Unduh Repository dan Buat Post Baru

- Unduh terlebih dahulu repository Jekyll Anda dari GitHub.
- Masuk ke direktori repository yang telah Anda unduh.
- Buka folder `_posts`, dan buat file baru untuk post.

**Penamaan file:**  
Gunakan format: `YYYY-MM-DD-judul-post.md`  
Contoh: `2025-08-02-cara-push-github.md`  
> **Catatan:** Jangan melebihi tanggal saat Anda menulis, dan hindari spasi di nama file.

## 2. Lihat Perubahan Secara Lokal

Sebelum mengunggah post ke GitHub, Anda bisa melihat tampilannya secara lokal dengan menjalankan perintah berikut:

```bash 
bundle exec jekyll s
``` 
anda juga dapat menggunakan ekstensi dari vcode yang ada pada bagian kanan atas halaman untuk melakukan `preview` dan melihat perubahan secara real-time.

jika perubahan yang anda lakukan telah selesai maka lanjut ke bagian publish dengan mengikuti langkah - langkahnya sebagai berikut:


## 3. Langkah-Langkah Lengkap Push Pertama ke GitHub
### 1. Masuk ke Folder Proyek Lokal anda
Buka Git Bash lalu masuk ke direktori proyek lokal Anda:

```bash
cd "D:/WEBSITE ASTARAJINGGA/astarajingga.github.io"
```
Ganti path di atas sesuai folder proyek Anda.

### 2. Inisialisasi Git Repository
Jika folder tersebut belum diinisialisasi:

```bash
git init
```

## 3. Tambahkan Semua File ke Git

```bash
git add .
```

## 4. Buat Commit Pertama

```bash
git commit -m "Initial commit"
```

## 5. Pastikan Branch Lokal Bernama `main` 

```bash
git branch -M main
```

## 6. Tarik Dulu Isi GitHub Jika Belum Kosong
Kalau GitHub repository tidak kosong (misalnya ada README.md dari awal), maka Anda harus tarik dulu:

```bash
git pull origin main --rebase  
```

## 7. Push ke GitHub
Kalau GitHub repository tidak kosong (misalnya ada README.md dari awal), maka Anda harus tarik dulu:

```bash
 git push -u origin main
```

# SELESAI. 

## Untuk Push Berikutnya
setiap kali anda melakukan perubahan/update pada website static anda gunakan :
```bash
 git add .
 git commit -m "Deskripsi perubahan"
 git push
```

sekian terimakasih, semoga bermanfaat hehe :)