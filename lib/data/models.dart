import '../utils/date_utils.dart';

/// Sesi rutinitas.
enum Slot { pagi, malam }

extension SlotLabel on Slot {
  String get label => this == Slot.pagi ? 'Pagi' : 'Malam';
  String get lower => this == Slot.pagi ? 'pagi' : 'malam';
}

/// Urutan kategori (dipakai untuk chip dan urutan langkah rutinitas).
const List<String> productCategories = [
  'Cleanser',
  'Toner',
  'Serum',
  'Moisturizer',
  'Sunscreen',
  'Lainnya',
];

const List<String> skinTypes = ['Berminyak', 'Kering', 'Kombinasi', 'Sensitif', 'Normal'];
const List<String> genders = ['Perempuan', 'Laki-laki'];

/// Produk skincare milik pengguna.
class Product {
  final String id;
  String name;
  String brand;
  String category;
  bool morning;
  bool night;

  /// Hari pemakaian (1 = Senin ... 7 = Minggu). Kosong berarti setiap hari.
  Set<int> days;
  DateTime openedDate;
  DateTime expiryDate;

  /// Toggle "Masuk ke rutinitas". Jika false, produk tetap di koleksi
  /// tetapi tidak muncul di jadwal rutinitas.
  bool active;
  String? photoPath;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.morning,
    required this.night,
    required this.days,
    required this.openedDate,
    required this.expiryDate,
    this.active = true,
    this.photoPath,
  });

  bool get everyDay => days.isEmpty;

  String get timeLabel {
    if (morning && night) return 'Pagi & Malam';
    return morning ? 'Pagi' : 'Malam';
  }

  String get scheduleLabel {
    if (everyDay) return 'Setiap hari';
    final sorted = days.toList()..sort();
    return sorted.map((d) => shortDayNames[d - 1]).join(', ');
  }

  int get daysLeft => dateOnly(expiryDate).difference(today).inDays;

  bool get expiringSoon => daysLeft <= 30;

  bool usedIn(Slot slot) => slot == Slot.pagi ? morning : night;

  bool scheduledOn(DateTime date) => everyDay || days.contains(date.weekday);

  Product copy() => Product(
        id: id,
        name: name,
        brand: brand,
        category: category,
        morning: morning,
        night: night,
        days: {...days},
        openedDate: openedDate,
        expiryDate: expiryDate,
        active: active,
        photoPath: photoPath,
      );
}

/// Alarm pengingat rutinitas.
class Alarm {
  final String id;
  String name;
  int hour;
  int minute;
  bool enabled;

  /// Hari alarm berbunyi (1 = Senin ... 7 = Minggu).
  Set<int> days;
  String note;

  Alarm({
    required this.id,
    required this.name,
    required this.hour,
    required this.minute,
    this.enabled = true,
    Set<int>? days,
    this.note = '',
  }) : days = days ?? {1, 2, 3, 4, 5, 6, 7};

  bool get isNight => hour >= 18 || hour < 4;
}

/// Hasil scan wajah (AI Skin Analysis).
class AnalysisResult {
  final String id;
  final DateTime date;
  final bool acneDetected;
  final String? photoPath;

  /// true jika hasil berasal dari analisis contoh (model belum tersambung).
  final bool isSample;

  const AnalysisResult({
    required this.id,
    required this.date,
    required this.acneDetected,
    this.photoPath,
    this.isSample = true,
  });
}

/// Data akun pengguna.
class UserProfile {
  String name;
  String email;
  String password;
  int age;
  String gender;
  String skinType;
  String? photoPath;

  UserProfile({
    required this.name,
    required this.email,
    required this.password,
    this.age = 21,
    this.gender = 'Perempuan',
    this.skinType = 'Kombinasi',
    this.photoPath,
  });
}
