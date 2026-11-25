import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semua warna aplikasi dikumpulkan di sini supaya seragam dengan Figma.
class AppColors {
  static const Color pink = Color(0xFFE5508A); // warna utama (tombol, aksen)
  static const Color pinkDark = Color(0xFFC93A73);
  static const Color pinkSoft = Color(0xFFFCE4EC); // latar kartu & chip
  static const Color pinkLight = Color(0xFFFFF1F5); // latar banner / kotak
  static const Color background = Color(0xFFFFF9FB);
  static const Color surface = Colors.white;

  static const Color text = Color(0xFF2B2B2B);
  static const Color textGrey = Color(0xFF8A8A8A);
  static const Color textLight = Color(0xFFB8B8B8);
  static const Color border = Color(0xFFF1E4E8);

  static const Color yellow = Color(0xFFFFF1C2); // kartu rutinitas pagi
  static const Color yellowText = Color(0xFFB98A0B);
  static const Color lilac = Color(0xFFEDE7FF); // kartu rutinitas malam, tag kategori
  static const Color lilacText = Color(0xFF6E5BB8);
  static const Color green = Color(0xFFDDF3E6); // progress 100%, hasil baik
  static const Color greenText = Color(0xFF2E8B57);
  static const Color red = Color(0xFFE53950);
  static const Color redSoft = Color(0xFFFDECEE);

  static const Color dark = Color(0xFF2B2329); // latar pratinjau kamera
}

/// Gaya huruf. Judul memakai Playfair Display (serif), isi memakai Poppins
/// (diatur lewat textTheme di [buildAppTheme]).
class AppText {
  static TextStyle serif({
    double size = 26,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.text,
  }) =>
      GoogleFonts.playfairDisplay(fontSize: size, fontWeight: weight, color: color, height: 1.2);

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const TextStyle body = TextStyle(fontSize: 13, color: AppColors.text, height: 1.5);

  static const TextStyle caption = TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4);

  static const TextStyle tiny = TextStyle(fontSize: 11, color: AppColors.textLight, height: 1.4);

  static const TextStyle section = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.pink,
      primary: AppColors.pink,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );

  return base.copyWith(
    textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? AppColors.pink : const Color(0xFFE0E0E0),
      ),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
