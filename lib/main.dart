import 'package:flutter/material.dart';

import 'screens/auth/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const RvpaApp());
}

class RvpaApp extends StatelessWidget {
  const RvpaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RVPA',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const SplashScreen(),
    );
  }
}
