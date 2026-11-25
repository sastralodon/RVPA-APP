import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'login_screen.dart';

/// Screen 1 - Splash.
/// Animasi: logo wajah "tergambar" dari atas ke bawah, tulisan RVPA muncul
/// huruf demi huruf, lalu tagline dan garis kecil. Setelah itu ke Login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Warna latar splash, dipakai juga untuk menyatukan latar putih gambar logo
  static const Color bg = Color(0xFFFDE9F0);

  late final AnimationController _controller;
  late final Animation<double> _draw;
  late final Animation<double> _letters;
  late final Animation<double> _tagline;
  late final Animation<double> _line;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3600));

    _draw = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.45, curve: Curves.easeInOut));
    _letters = CurvedAnimation(parent: _controller, curve: const Interval(0.45, 0.70));
    _tagline = CurvedAnimation(parent: _controller, curve: const Interval(0.70, 0.88, curve: Curves.easeIn));
    _line = CurvedAnimation(parent: _controller, curve: const Interval(0.80, 1.0, curve: Curves.easeOut));

    _controller.addStatusListener((status) {
      if (status != AnimationStatus.completed) return;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
          ),
        );
      });
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo wajah garis, terbuka dari atas ke bawah (efek digambar)
                SizedBox(
                  height: 170,
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: _draw.value,
                      child: Image.asset(
                        'assets/images/face_line.jpg',
                        height: 170,
                        color: bg,
                        colorBlendMode: BlendMode.multiply,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _buildWordmark(),
                const SizedBox(height: 10),
                Opacity(
                  opacity: _tagline.value,
                  child: const Text(
                    'Bloom into your best skin',
                    style: TextStyle(fontSize: 13, color: AppColors.textGrey, letterSpacing: 0.3),
                  ),
                ),
                const SizedBox(height: 26),
                Container(width: 40 * _line.value, height: 2, color: AppColors.pink),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWordmark() {
    const word = 'RVPA';
    final shown = (_letters.value * word.length).ceil().clamp(0, word.length);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(word.length, (i) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: i < shown ? 1 : 0,
          child: Text(word[i], style: AppText.serif(size: 40, color: AppColors.pink)),
        );
      }),
    );
  }
}
