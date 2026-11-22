import 'package:material_ui/material_ui.dart';
import 'package:rvpa/screens/main_screen.dart';
import 'package:rvpa/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RVPA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Sementara langsung ke MainScreen.
      // Nanti diganti SplashScreen -> Login oleh pemilik fitur auth.
      home: const MainScreen(),
    );
  }
}
