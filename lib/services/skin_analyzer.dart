import 'dart:math';

/// Layanan analisis kulit dari foto wajah.
///
/// SAAT INI: masih analisis CONTOH (hasil acak) supaya alur aplikasi bisa
/// dicoba tanpa internet. Hasilnya ditandai "Contoh hasil" di layar.
///
/// NANTI: ganti isi [analyze] dengan pemanggilan API model Roboflow
/// (dataset Skin-Problem-MultiLabel), misalnya pakai package `http`:
///   1. Baca file foto, ubah ke base64.
///   2. POST ke endpoint model Roboflow beserta API key.
///   3. Baca label hasil prediksi (misalnya "acne") dan nilai confidence-nya.
///   4. Kembalikan true jika label jerawat terdeteksi.
class SkinAnalyzer {
  static final Random _random = Random();

  /// Mengembalikan true jika terindikasi jerawat.
  static Future<bool> analyze(String photoPath) async {
    // Simulasi waktu proses model
    await Future.delayed(const Duration(milliseconds: 1800));
    return _random.nextBool();
  }

  /// true selama [analyze] masih memakai hasil contoh.
  static const bool usesSampleResult = true;
}
