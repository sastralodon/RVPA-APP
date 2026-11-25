import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_utils.dart';
import '../../widgets/common.dart';
import '../collection/product_detail_screen.dart';
import '../main_shell.dart';
import '../routine/routine_screen.dart';

/// Screen 4 - Beranda.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final now = today;
          final expiring = store.expiringProducts;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: [
              // Sapaan + tombol profil
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi, ${store.user.name}!', style: AppText.serif(size: 26)),
                        const SizedBox(height: 4),
                        Text(formatFullDate(now), style: AppText.caption),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => MainShell.goTo(context, MainShell.profileTab),
                    child: Avatar(photoPath: store.user.photoPath, size: 44, background: AppColors.pinkSoft),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text('Rutinitas', style: AppText.section),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _RoutineCard(slot: Slot.pagi, date: now)),
                  const SizedBox(width: 12),
                  Expanded(child: _RoutineCard(slot: Slot.malam, date: now)),
                ],
              ),
              const SizedBox(height: 26),

              Row(
                children: [
                  const Text('Kedaluwarsa', style: AppText.section),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => MainShell.goTo(context, MainShell.collectionTab),
                    child: const Text(
                      'Lihat koleksi',
                      style: TextStyle(fontSize: 12, color: AppColors.pink, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (expiring.isEmpty)
                const RvpaCard(
                  child: Text(
                    'Tidak ada produk yang kedaluwarsa dalam 30 hari ke depan.',
                    style: AppText.caption,
                  ),
                )
              else
                ...expiring.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ExpiringTile(product: p),
                    )),
            ],
          );
        },
      ),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  final Slot slot;
  final DateTime date;
  const _RoutineCard({required this.slot, required this.date});

  @override
  Widget build(BuildContext context) {
    final isMorning = slot == Slot.pagi;
    final total = store.routineFor(date, slot).length;
    final done = store.doneCount(date, slot);
    final bg = isMorning ? AppColors.yellow : AppColors.lilac;
    final accent = isMorning ? AppColors.yellowText : AppColors.lilacText;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RoutineScreen(initialSlot: slot)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Icon(
                    isMorning ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
                    size: 18,
                    color: accent,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded, color: AppColors.text),
              ],
            ),
            const SizedBox(height: 14),
            Text('Rutinitas ${slot.label}', style: AppText.label),
            const SizedBox(height: 2),
            Text('$done dari $total langkah', style: TextStyle(fontSize: 11, color: accent)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : done / total,
                minHeight: 6,
                backgroundColor: Colors.white,
                color: AppColors.pink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpiringTile extends StatelessWidget {
  final Product product;
  const _ExpiringTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final days = product.daysLeft;
    final urgent = days <= 25;
    return RvpaCard(
      padding: const EdgeInsets.all(10),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: product.id)),
      ),
      child: Row(
        children: [
          ProductThumb(product: product, size: 52),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.brand, style: const TextStyle(fontSize: 11, color: AppColors.pink)),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Tag(
                  days < 0 ? 'Sudah kedaluwarsa' : '$days hari lagi',
                  background: urgent ? AppColors.redSoft : AppColors.yellow,
                  foreground: urgent ? AppColors.red : AppColors.yellowText,
                ),
              ],
            ),
          ),
          Icon(
            Icons.warning_amber_rounded,
            color: urgent ? AppColors.red : AppColors.yellowText,
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
