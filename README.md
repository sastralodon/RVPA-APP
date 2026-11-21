# RVPA (re: Rupa)

> *Konsisten hari ini, bersinar esok hari.*

**RVPA** (*Routine, Vision, Protection, and Analysis*) adalah aplikasi mobile Android berbasis Flutter untuk membantu pengguna mengelola rutinitas perawatan kulit (skincare): koleksi produk, jadwal pemakaian pagi dan malam, pengingat, serta pencatatan perkembangan kondisi kulit.

Proyek mata kuliah **Teknologi Berkembang (kelas A)**, Departemen Sistem Informasi, Institut Teknologi Sepuluh Nopember, tahun ajaran 2026/2027. **Kelompok 5.**

---

## Fitur Utama

| Modul | Deskripsi |
|---|---|
| Splash dan Autentikasi | Tampilan awal, registrasi, dan login |
| Beranda | Sapaan, ringkasan rutinitas pagi/malam, produk yang mendekati kedaluwarsa |
| Skincare Collection | Daftar produk, detail, tambah/edit/hapus, aktif/nonaktif ke rutinitas |
| Skincare Routine | Checklist rutinitas pagi dan malam per tanggal beserta progress |
| Skin Diary | Kalender skin journey dan catatan kondisi kulit harian |
| Profil | Edit profil, pengaturan reminder/alarm, tentang RVPA, logout |

> Fitur analisis kondisi kulit lewat foto wajah (*Vision*) disebut di laporan, namun belum diputuskan masuk scope implementasi.

## Tech Stack

- **Flutter** 3.50.0 (stable), **Dart** 3.14.0
- **Platform target:** Android
- **Autentikasi:** Firebase Authentication
- **Package ID Android:** `id.ac.its.rvpa.rvpa`

Keputusan lain (penyimpanan data, state management, dll.) akan dicatat di sini setelah disepakati tim.

## Prasyarat

- Flutter SDK **3.50.0** atau yang kompatibel (cek dengan `flutter --version`)
- Android Studio (untuk Android SDK dan emulator), atau HP Android dengan USB debugging aktif
- Git
- VS Code dengan extension **Flutter** dan **Dart** (disarankan)

Pastikan `flutter doctor` tidak menampilkan masalah pada bagian Android toolchain.

## Menjalankan Proyek

```bash
# 1. Clone dan masuk ke folder
git clone https://github.com/sastralodon/RVPA-APP.git
cd RVPA-APP

# 2. Pindah ke branch develop
git checkout develop

# 3. Ambil dependency
flutter pub get

# 4. Jalankan
flutter devices
flutter run
```

### Preview cepat di Chrome (opsional)

Untuk mengerjakan UI tanpa emulator:

```bash
flutter run -d chrome
```

Tekan `F12` lalu `Ctrl+Shift+M` untuk tampilan ukuran HP (sekitar 360x800). Mode web hanya untuk preview. **Fitur yang bergantung perangkat (notifikasi/alarm, kamera, izin Android) harus dites di Android.**

## Struktur Folder

```
lib/
├── main.dart
├── core/          # dipakai lintas fitur
│   ├── constants/
│   ├── theme/
│   ├── routes/
│   ├── errors/
│   ├── services/
│   ├── providers/
│   ├── utils/
│   └── widgets/
└── features/      # satu folder per fitur
    ├── splash/
    ├── auth/
    ├── home/
    ├── collection/
    ├── routine/
    ├── diary/
    └── profile/
```

Setiap fitur di `features/` dipecah menjadi `models/`, `data/`, `providers/`, dan `presentation/` (halaman dan `widgets/`). Pendekatannya **feature-first**: tiap anggota mengerjakan foldernya sendiri agar jarang bentrok.

## Alur Kerja Git

| Branch | Fungsi |
|---|---|
| `main` | Versi stabil, hanya di-merge dari `develop` saat milestone atau demo |
| `develop` | Gabungan seluruh fitur yang sudah selesai |
| `feature/<nama-fitur>` | Kerjaan masing-masing anggota |

**Aturan:**

1. **Jangan commit langsung ke `main` atau `develop`.**
2. Mulai kerja dari `develop` terbaru, lalu buat branch fitur:

   ```bash
   git checkout develop
   git pull
   git checkout -b feature/collection
   ```
3. Commit kecil dan sering, lalu push:

   ```bash
   git add .
   git commit -m "feat: add product list page"
   git push -u origin feature/collection
   ```
4. Buka **Pull Request** ke `develop` di GitHub, minta minimal 1 anggota me-review, lalu merge.
5. Sebelum membuka PR, jalankan:

   ```bash
   flutter analyze
   flutter test
   ```

   Pastikan tidak ada error.

### Format commit

| Prefix | Dipakai untuk |
|---|---|
| `feat:` | Fitur baru |
| `fix:` | Perbaikan bug |
| `chore:` | Setup, konfigurasi, dependency |
| `docs:` | Dokumentasi |
| `refactor:` | Merapikan kode tanpa mengubah perilaku |

Contoh: `feat: add expiry warning on product detail`

### Contoh nama branch

`feature/auth`, `feature/collection`, `feature/home-routine`, `feature/diary`, `feature/profile`

## Konvensi Kode

- Nama file `snake_case.dart`, nama class `PascalCase`.
- Nama kode (class, variabel, file) memakai bahasa Inggris, teks yang tampil ke pengguna memakai bahasa Indonesia.
- Hindari menulis warna dan teks UI langsung di tiap halaman. Pakai konstanta bersama di `lib/core/constants/` agar tampilan konsisten (warna, tipografi, dan teks final menunggu panduan desain dari Figma).
- Jangan commit file rahasia (`.env`, `*.jks`, `key.properties`).
- Jalankan `flutter analyze` sebelum commit, dan usahakan nol warning.

## Status Pengembangan

- [x] Setup repository dan struktur folder `lib/`
- [ ] Fondasi aplikasi (tema, navigasi, halaman placeholder)
- [ ] Firebase Authentication, Splash, Registrasi, Login
- [ ] Koleksi dan Detail Produk
- [ ] Beranda dan Rutinitas
- [ ] Skin Diary
- [ ] Profil dan Reminder
- [ ] Keputusan fitur analisis foto wajah (*Vision*)

## Tim (Kelompok 5)

| Nama | NRP |
|---|---|
| Cheryl Salsabilla H | 5026241108 |
| Shakila Putri D | 5026241110 |
| Elfa Setiana | 5026241208 |
| Khalisa Aulia Zahra | 5026241077 |
| Aisyah Nabilah Putri | 5026241141 |
| Ananda Mutiara Ramadhani Rambe | 5026241152 |
| Jiersa Hilal Indrasastra | 5026241191 |
