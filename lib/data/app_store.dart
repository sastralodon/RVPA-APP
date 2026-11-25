import 'package:flutter/foundation.dart';

import '../utils/date_utils.dart';
import 'models.dart';

/// Penyimpanan data aplikasi (sementara di memori).
///
/// Semua layar membaca dan mengubah data lewat [store]. Saat data berubah,
/// [notifyListeners] membuat layar yang memakai ListenableBuilder ikut
/// diperbarui. Nantinya isi kelas ini bisa diganti Firebase
/// (Authentication + Cloud Firestore) tanpa mengubah tampilan.
class AppStore extends ChangeNotifier {
  AppStore._() {
    _seed();
  }

  static final AppStore instance = AppStore._();

  // ---------------------------------------------------------------- akun
  late UserProfile user;
  bool _hasAccount = true;

  /// Daftar akun baru (menggantikan akun contoh).
  void register({required String name, required String email, required String password}) {
    user = UserProfile(name: name, email: email, password: password);
    _hasAccount = true;
    notifyListeners();
  }

  /// Mengembalikan pesan error, atau null jika berhasil.
  String? login(String email, String password) {
    if (!_hasAccount) return 'Akun belum terdaftar. Silakan daftar dulu.';
    if (email.trim().toLowerCase() != user.email.toLowerCase() || password != user.password) {
      return 'Email atau password salah.';
    }
    return null;
  }

  void updateProfile({
    required String name,
    required String email,
    required String password,
    required int age,
    required String gender,
    required String skinType,
  }) {
    user
      ..name = name
      ..email = email
      ..password = password
      ..age = age
      ..gender = gender
      ..skinType = skinType;
    notifyListeners();
  }

  void updatePhoto(String? path) {
    user.photoPath = path;
    notifyListeners();
  }

  // -------------------------------------------------------------- produk
  final List<Product> products = [];

  Product? productById(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  void addProduct(Product p) {
    products.insert(0, p);
    notifyListeners();
  }

  void updateProduct(Product updated) {
    final i = products.indexWhere((p) => p.id == updated.id);
    if (i != -1) products[i] = updated;
    notifyListeners();
  }

  void deleteProduct(String id) {
    products.removeWhere((p) => p.id == id);
    for (final set in _done.values) {
      set.remove(id);
    }
    notifyListeners();
  }

  void setProductActive(String id, bool active) {
    productById(id)?.active = active;
    notifyListeners();
  }

  List<Product> get expiringProducts {
    final list = products.where((p) => p.expiringSoon).toList()
      ..sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
    return list;
  }

  String newId(String prefix) => '$prefix${DateTime.now().microsecondsSinceEpoch}';

  // ----------------------------------------------------------- rutinitas
  /// Key: "yyyy-mm-dd|pagi" -> id produk yang sudah dicentang.
  final Map<String, Set<String>> _done = {};

  String _doneKey(DateTime d, Slot s) => '${dateKey(d)}|${s.lower}';

  /// Produk yang masuk rutinitas pada tanggal & sesi tertentu:
  /// hanya produk aktif yang jadwal harinya cocok.
  List<Product> routineFor(DateTime date, Slot slot) {
    final list = products.where((p) => p.active && p.usedIn(slot) && p.scheduledOn(date)).toList();
    list.sort((a, b) => productCategories.indexOf(a.category).compareTo(productCategories.indexOf(b.category)));
    return list;
  }

  bool isDone(DateTime date, Slot slot, String productId) =>
      _done[_doneKey(date, slot)]?.contains(productId) ?? false;

  void toggleDone(DateTime date, Slot slot, String productId) {
    final set = _done.putIfAbsent(_doneKey(date, slot), () => <String>{});
    if (!set.remove(productId)) set.add(productId);
    notifyListeners();
  }

  int doneCount(DateTime date, Slot slot) =>
      routineFor(date, slot).where((p) => isDone(date, slot, p.id)).length;

  /// Produk yang sudah dipakai (dicentang) pada tanggal & sesi tertentu.
  List<Product> usedProducts(DateTime date, Slot slot) =>
      routineFor(date, slot).where((p) => isDone(date, slot, p.id)).toList();

  /// Progress harian gabungan pagi + malam (0.0 - 1.0).
  /// null jika belum ada data (tanggal di masa depan / tidak ada langkah).
  double? dayProgress(DateTime date) {
    if (dateOnly(date).isAfter(today)) return null;
    final total = routineFor(date, Slot.pagi).length + routineFor(date, Slot.malam).length;
    if (total == 0) return null;
    final done = doneCount(date, Slot.pagi) + doneCount(date, Slot.malam);
    return done / total;
  }

  // --------------------------------------------------------------- diary
  final Map<String, String> _diary = {};

  String? diaryFor(DateTime date) => _diary[dateKey(date)];

  int get diaryCount => _diary.length;

  void saveDiary(DateTime date, String text) {
    if (text.trim().isEmpty) {
      _diary.remove(dateKey(date));
    } else {
      _diary[dateKey(date)] = text.trim();
    }
    notifyListeners();
  }

  void deleteDiary(DateTime date) {
    _diary.remove(dateKey(date));
    notifyListeners();
  }

  // -------------------------------------------------------------- alarm
  final List<Alarm> alarms = [];

  void saveAlarm(Alarm alarm) {
    final i = alarms.indexWhere((a) => a.id == alarm.id);
    if (i == -1) {
      alarms.add(alarm);
    } else {
      alarms[i] = alarm;
    }
    alarms.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
    notifyListeners();
  }

  void toggleAlarm(String id, bool enabled) {
    for (final a in alarms) {
      if (a.id == id) a.enabled = enabled;
    }
    notifyListeners();
  }

  void deleteAlarm(String id) {
    alarms.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  // ------------------------------------------------------ analisis kulit
  final List<AnalysisResult> analyses = [];

  void saveAnalysis(AnalysisResult result) {
    analyses.insert(0, result);
    notifyListeners();
  }

  // ------------------------------------------------------- data contoh
  void _seed() {
    user = UserProfile(
      name: 'Mutiara',
      email: 'mutiara@email.com',
      password: 'rvpa1234',
      age: 21,
      gender: 'Perempuan',
      skinType: 'Kombinasi',
    );

    final t = today;
    products.addAll([
      Product(
        id: 'p1',
        name: 'Gentle Foaming Cleanser',
        brand: 'Cetaphil',
        category: 'Cleanser',
        morning: true,
        night: true,
        days: {},
        openedDate: t.subtract(const Duration(days: 60)),
        expiryDate: t.add(const Duration(days: 240)),
      ),
      Product(
        id: 'p2',
        name: 'Niacinamide 10% + Zinc 1%',
        brand: 'The Ordinary',
        category: 'Serum',
        morning: true,
        night: true,
        days: {},
        openedDate: t.subtract(const Duration(days: 156)),
        expiryDate: t.add(const Duration(days: 22)),
      ),
      Product(
        id: 'p3',
        name: 'Daily Moisturizer',
        brand: 'CeraVe',
        category: 'Moisturizer',
        morning: true,
        night: false,
        days: {},
        openedDate: t.subtract(const Duration(days: 30)),
        expiryDate: t.add(const Duration(days: 300)),
      ),
      Product(
        id: 'p4',
        name: 'Sunscreen SPF50',
        brand: 'Skin Aqua',
        category: 'Sunscreen',
        morning: true,
        night: false,
        days: {},
        openedDate: t.subtract(const Duration(days: 90)),
        expiryDate: t.add(const Duration(days: 28)),
      ),
      Product(
        id: 'p5',
        name: 'Retinol 0.5%',
        brand: "Paula's Choice",
        category: 'Serum',
        morning: false,
        night: true,
        days: {},
        openedDate: t.subtract(const Duration(days: 170)),
        expiryDate: t.add(const Duration(days: 9)),
      ),
      Product(
        id: 'p6',
        name: 'Gokujyun Hydrating Lotion',
        brand: 'Hada Labo',
        category: 'Toner',
        morning: false,
        night: true,
        days: {},
        openedDate: t.subtract(const Duration(days: 40)),
        expiryDate: t.add(const Duration(days: 320)),
      ),
      Product(
        id: 'p7',
        name: 'Moisturizing Cream',
        brand: 'CeraVe',
        category: 'Moisturizer',
        morning: false,
        night: true,
        days: {},
        openedDate: t.subtract(const Duration(days: 20)),
        expiryDate: t.add(const Duration(days: 340)),
      ),
      Product(
        id: 'p8',
        name: 'Volcanic Clay Mask',
        brand: 'Innisfree',
        category: 'Lainnya',
        morning: false,
        night: true,
        days: {3, 6},
        openedDate: t.subtract(const Duration(days: 80)),
        expiryDate: t.add(const Duration(days: 200)),
        active: false,
      ),
    ]);

    // Riwayat centang rutinitas bulan ini (supaya kalender Skin Diary berwarna)
    for (var day = 1; day < t.day; day++) {
      final d = DateTime(t.year, t.month, day);
      final pattern = day % 7;
      if (pattern == 6) continue; // 0%: tidak ada yang dicentang
      for (final p in routineFor(d, Slot.pagi)) {
        _done.putIfAbsent(_doneKey(d, Slot.pagi), () => <String>{}).add(p.id);
      }
      if (pattern == 3 || pattern == 5) continue; // 1-99%: hanya pagi
      for (final p in routineFor(d, Slot.malam)) {
        _done.putIfAbsent(_doneKey(d, Slot.malam), () => <String>{}).add(p.id);
      }
    }
    // Hari ini: 3 dari 4 langkah pagi sudah selesai
    _done[_doneKey(t, Slot.pagi)] = {'p1', 'p2', 'p3'};

    // Contoh catatan diary di beberapa hari sebelumnya
    const notes = [
      'Kulit terasa lembap, ada sedikit kemerahan di pipi setelah retinol. Besok pakai pelembap lebih tebal.',
      'Muncul satu jerawat kecil di dagu. Tetap rutin pakai niacinamide.',
      'Kulit terasa kencang setelah cuci muka, jangan lupa toner.',
      'Bekas jerawat mulai memudar.',
    ];
    var n = 0;
    for (var day = t.day - 1; day >= 1 && n < 7; day -= 2) {
      _diary[dateKey(DateTime(t.year, t.month, day))] = notes[n % notes.length];
      n++;
    }

    alarms.addAll([
      Alarm(id: 'a1', name: 'Pagi', hour: 6, minute: 30, note: 'Jangan lupa sunscreen sebelum keluar'),
      Alarm(id: 'a2', name: 'Malam', hour: 21, minute: 0, note: 'Double cleanse lalu serum'),
      Alarm(id: 'a3', name: 'Touch-up', hour: 13, minute: 0, enabled: false, note: 'Reapply sunscreen'),
    ]);
    alarms.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
  }
}

/// Akses singkat ke penyimpanan data.
final AppStore store = AppStore.instance;
