// Fungsi bantu format tanggal berbahasa Indonesia (tanpa package intl).

const List<String> dayNames = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
const List<String> shortDayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
const List<String> monthNames = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

String _two(int n) => n.toString().padLeft(2, '0');

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime get today => dateOnly(DateTime.now());

bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

/// Jumat, 13 November 2026
String formatFullDate(DateTime d) => '${dayNames[d.weekday - 1]}, ${d.day} ${monthNames[d.month - 1]} ${d.year}';

/// 13 November 2026
String formatLongDate(DateTime d) => '${d.day} ${monthNames[d.month - 1]} ${d.year}';

/// 13/11/2026
String formatDdMmYyyy(DateTime d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';

/// November 2026
String formatMonthYear(DateTime d) => '${monthNames[d.month - 1]} ${d.year}';

/// 06:30
String formatTime(int hour, int minute) => '${_two(hour)}:${_two(minute)}';

/// Kunci unik per tanggal, dipakai untuk menyimpan data harian.
String dateKey(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';
