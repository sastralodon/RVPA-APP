import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

/// Hasil analisis: "Terindikasi jerawat" atau "Tidak terindikasi jerawat".
class AnalysisResultView extends StatelessWidget {
  final AnalysisResult result;
  final bool saved;
  final VoidCallback onBack;
  final VoidCallback onSave;
  final VoidCallback onRescan;

  const AnalysisResultView({
    super.key,
    required this.result,
    required this.saved,
    required this.onBack,
    required this.onSave,
    required this.onRescan,
  });

  static const _acneTips = [
    ('Bersihkan wajah dengan lembut', 'Hindari scrub keras dan memencet jerawat.'),
    ('Jaga kelembapan kulit', 'Pilih pelembap nonkomedogenik.'),
    ('Lindungi dari matahari', 'Gunakan sunscreen sesuai petunjuk.'),
  ];

  static const _clearTips = [
    ('Lanjutkan rutinitas lembut', 'Bersihkan wajah tanpa menggosok berlebihan.'),
    ('Tetap jaga kelembapan', 'Gunakan pelembap sesuai kebutuhan kulit.'),
    ('Jangan lewatkan sunscreen', 'Lindungi kulit dari paparan matahari.'),
  ];

  @override
  Widget build(BuildContext context) {
    final acne = result.acneDetected;
    final tips = acne ? _acneTips : _clearTips;
    final bg = acne ? AppColors.redSoft : AppColors.green;
    final fg = acne ? AppColors.red : AppColors.greenText;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Row(
          children: [
            CircleBackButton(onPressed: onBack),
            const SizedBox(width: 12),
            const Text('Hasil analisis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            if (result.isSample) ...[
              const Tag('Contoh hasil', background: Color(0xFFF2F0F1), foreground: AppColors.text),
              const SizedBox(width: 8),
            ],
            const Text('Analisis visual', style: AppText.tiny),
          ],
        ),
        const SizedBox(height: 6),
        Text('Hasil scan wajahmu', style: AppText.serif(size: 22)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(
                      acne ? Icons.priority_high_rounded : Icons.check_rounded,
                      color: fg,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      acne ? 'Terindikasi jerawat' : 'Tidak terindikasi jerawat',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: fg),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                acne
                    ? 'Ada tanda visual yang menyerupai jerawat pada foto.'
                    : 'Tidak tampak tanda jerawat yang jelas pada foto ini.',
                style: const TextStyle(fontSize: 12, color: AppColors.text),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(acne ? 'Rawat kulitmu dengan lembut' : 'Pertahankan kebiasaan baikmu', style: AppText.section),
        const SizedBox(height: 10),
        for (var i = 0; i < tips.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RvpaCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.pinkSoft, shape: BoxShape.circle),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(fontSize: 11, color: AppColors.pink, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tips[i].$1, style: AppText.label),
                        Text(tips[i].$2, style: AppText.tiny),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 8),
        const Text('Indikasi visual, bukan diagnosis medis.', style: AppText.label),
        const SizedBox(height: 4),
        Text(
          acne
              ? 'Jika jerawat terasa nyeri atau menetap, konsultasikan dengan dokter kulit.'
              : 'Kualitas foto dapat memengaruhi hasil. Konsultasikan jika ada keluhan kulit.',
          style: AppText.caption,
        ),
        const SizedBox(height: 22),
        RvpaButton(
          label: saved ? 'Tersimpan di riwayat' : 'Simpan hasil',
          icon: saved ? Icons.check_rounded : null,
          onPressed: saved ? null : onSave,
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: onRescan,
            icon: const Icon(Icons.photo_camera_outlined, size: 18, color: AppColors.pink),
            label: const Text('Scan ulang', style: TextStyle(color: AppColors.pink, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}
