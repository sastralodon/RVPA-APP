import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_utils.dart';
import '../../widgets/common.dart';

/// Riwayat analisis (hasil scan yang sudah disimpan).
class AnalysisHistoryView extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNewScan;
  final ValueChanged<AnalysisResult> onOpen;

  const AnalysisHistoryView({
    super.key,
    required this.onBack,
    required this.onNewScan,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final items = store.analyses;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleBackButton(onPressed: onBack),
                  const SizedBox(width: 12),
                  const Text('Riwayat analisis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 18),
              Text('Perjalanan kulitmu', style: AppText.serif(size: 22)),
              const SizedBox(height: 4),
              const Text('Buka kembali hasil scan yang sudah kamu simpan.', style: AppText.caption),
              const SizedBox(height: 16),
              Expanded(
                child: items.isEmpty
                    ? const _EmptyHistory()
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _HistoryTile(result: items[i], onTap: () => onOpen(items[i])),
                      ),
              ),
              const SizedBox(height: 12),
              RvpaButton(label: 'Scan baru', icon: Icons.photo_camera_outlined, onPressed: onNewScan),
              const SizedBox(height: 8),
              const Center(child: Text('Indikasi visual, bukan diagnosis medis.', style: AppText.tiny)),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return RvpaCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(color: AppColors.pinkSoft, shape: BoxShape.circle),
            child: const Icon(Icons.history_rounded, color: AppColors.pink, size: 26),
          ),
          const SizedBox(height: 14),
          const Text('Belum ada hasil tersimpan', style: AppText.section),
          const SizedBox(height: 6),
          const Text(
            'Selesai scan? Pilih Simpan hasil agar kamu bisa melihatnya lagi di sini.',
            textAlign: TextAlign.center,
            style: AppText.caption,
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final AnalysisResult result;
  final VoidCallback onTap;
  const _HistoryTile({required this.result, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final acne = result.acneDetected;
    final fg = acne ? AppColors.red : AppColors.greenText;
    return RvpaCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: fg, width: 1.4),
                ),
                child: Icon(acne ? Icons.priority_high_rounded : Icons.check_rounded, size: 14, color: fg),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formatLongDate(result.date), style: AppText.label),
                    Text(
                      result.isSample ? 'Scan wajah · Contoh hasil' : 'Scan wajah',
                      style: AppText.tiny,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textGrey),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: acne ? AppColors.redSoft : AppColors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              acne ? 'Terindikasi jerawat' : 'Tidak terindikasi jerawat',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: fg),
            ),
          ),
          const SizedBox(height: 6),
          const Text('Lihat hasil dan saran perawatan', style: AppText.tiny),
        ],
      ),
    );
  }
}
