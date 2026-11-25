import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Screen 13 - Tentang RVPA.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Anggota Kelompok 5 - Teknologi Berkembang (Kelas A)
  static const List<String> _team = [
    'Cheryl',
    'Shakila',
    'Elfa',
    'Khalisa',
    'Aisyah',
    'Mutiara',
    'Jiersa',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang RVPA')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          Center(
            child: Image.asset(
              'assets/images/face_line.jpg',
              height: 90,
              color: AppColors.background,
              colorBlendMode: BlendMode.multiply,
            ),
          ),
          const SizedBox(height: 8),
          Center(child: Text('RVPA', style: AppText.serif(size: 28, color: AppColors.pink))),
          const Center(child: Text('Versi 1.0.0', style: AppText.caption)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.pinkLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.pinkSoft),
            ),
            child: const Text(
              'RVPA (Routine, Vision, Protection, and Analysis) adalah aplikasi pendamping rutinitas '
              'skincare. Kelola koleksi produk, atur jadwal pemakaian pagi dan malam, pantau tanggal '
              'kedaluwarsa, cek kondisi kulit dari foto wajah, dan catat perjalanan kulitmu setiap '
              'hari dalam satu aplikasi.',
              style: AppText.body,
            ),
          ),
          const SizedBox(height: 24),
          const Text('Dibalik RVPA', style: AppText.section),
          const SizedBox(height: 2),
          const Text('Kelompok 5 · Teknologi Berkembang · ITS', style: AppText.caption),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 16,
            children: _team.map((name) => _Member(name: name)).toList(),
          ),
          const SizedBox(height: 14),
          const Text(
            'Ganti lingkaran dengan foto anggota tim di assets/images/.',
            textAlign: TextAlign.center,
            style: AppText.tiny,
          ),
        ],
      ),
    );
  }
}

class _Member extends StatelessWidget {
  final String name;
  const _Member({required this.name});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.pinkSoft,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.pink, width: 1.2),
            ),
            child: const Icon(Icons.person_outline_rounded, color: AppColors.pink, size: 30),
          ),
          const SizedBox(height: 6),
          Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
