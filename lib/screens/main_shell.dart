import 'package:flutter/material.dart';

import '../widgets/bottom_nav.dart';
import 'analysis/analysis_tab.dart';
import 'collection/collection_screen.dart';
import 'diary/skin_diary_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';

/// Kerangka utama setelah login: 5 tab dengan bottom navigation.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  /// Pindah tab dari layar mana pun di dalam shell, misalnya
  /// `MainShell.goTo(context, MainShell.collectionTab)`.
  static void goTo(BuildContext context, int index) {
    context.findAncestorStateOfType<_MainShellState>()?.select(index);
  }

  static const int homeTab = 0;
  static const int collectionTab = 1;
  static const int analysisTab = 2;
  static const int diaryTab = 3;
  static const int profileTab = 4;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = MainShell.homeTab;

  void select(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga isi tiap tab tetap tersimpan saat berpindah
      body: IndexedStack(
        index: _index,
        children: const [
          HomeScreen(),
          CollectionScreen(),
          AnalysisTab(),
          SkinDiaryScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: RvpaBottomNav(currentIndex: _index, onTap: select),
    );
  }
}
