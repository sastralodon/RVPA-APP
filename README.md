# RVPA

Aplikasi pendamping rutinitas skincare (Final Project Teknologi Berkembang, Kelas A Kelompok 5, SI ITS).

## Cara menjalankan

```bash
flutter pub get
flutter run
```

Akun contoh untuk login:

- Email: `mutiara@email.com`
- Password: `rvpa1234`

Atau buat akun baru dari halaman Registrasi.

## Struktur folder

```
lib/
├── main.dart
├── theme/app_theme.dart          warna & font (Playfair Display + Poppins)
├── utils/date_utils.dart         format tanggal bahasa Indonesia
├── data/
│   ├── models.dart               Product, Alarm, AnalysisResult, UserProfile
│   └── app_store.dart            penyimpanan data + data contoh
├── services/skin_analyzer.dart   analisis kulit (masih hasil contoh)
├── widgets/                      komponen dipakai bersama
│   ├── common.dart               tombol, isian, chip, kartu, dll.
│   ├── calendar.dart             kalender bulan + dialog pilih tanggal
│   └── bottom_nav.dart           navigasi bawah 5 menu
└── screens/
    ├── auth/                     1 Splash, 2 Registrasi, 3 Login
    ├── main_shell.dart           kerangka 5 tab
    ├── home/                     4 Beranda
    ├── collection/               5 Koleksi, 6 Detail Produk, 7 Tambah/Edit Produk
    ├── routine/                  8 Rutinitas Pagi & Malam
    ├── diary/                    10 Skin Diary
    ├── profile/                  9 Profil, 11 Reminder (+ Pengaturan alarm),
    │                             12 Edit Profil (+ Edit foto), 13 Tentang RVPA
    └── analysis/                 Analisis kulit: Kamera, Hasil, Riwayat
```

## Yang belum tersambung

- **Database**: data masih disimpan di memori (`AppStore`) dan kembali ke data contoh saat aplikasi ditutup. Rencananya diganti Firebase (Authentication, Cloud Firestore, Storage).
- **Analisis kulit**: `SkinAnalyzer.analyze` masih mengembalikan hasil contoh acak. Ganti dengan pemanggilan API model Roboflow.
- **Notifikasi alarm**: data alarm sudah tersimpan, tetapi notifikasi belum dijadwalkan. Sambungkan ke `flutter_local_notifications`.
