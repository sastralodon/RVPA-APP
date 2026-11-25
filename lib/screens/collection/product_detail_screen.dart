import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_utils.dart';
import '../../widgets/common.dart';
import 'product_form_screen.dart';

/// Screen 6 - Detail Produk (card per produk).
class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  Future<void> _delete(BuildContext context, Product product) async {
    final ok = await confirmDialog(
      context,
      title: 'Hapus produk?',
      message: '${product.name} akan dihapus dari koleksi dan rutinitas.',
    );
    if (!ok || !context.mounted) return;
    store.deleteProduct(product.id);
    Navigator.pop(context);
    showMessage(context, 'Produk dihapus');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final product = store.productById(productId);
        if (product == null) return const Scaffold();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Produk'),
            actions: [
              IconButton(
                onPressed: () => _delete(context, product),
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.red),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              ProductThumb(product: product, size: double.infinity, height: 200, radius: 22),
              const SizedBox(height: 18),
              Text(product.brand, style: const TextStyle(color: AppColors.pink, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(product.name, style: AppText.serif(size: 22)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: [
                  Tag(product.timeLabel, icon: Icons.wb_sunny_outlined),
                  Tag.category(product.category),
                ],
              ),
              if (product.expiringSoon) ...[
                const SizedBox(height: 16),
                ExpiryWarning(daysLeft: product.daysLeft),
              ],
              const SizedBox(height: 16),
              _InfoRow(
                icon: Icons.calendar_month_outlined,
                label: 'Jadwal pemakaian',
                value: product.scheduleLabel,
              ),
              _InfoRow(
                icon: Icons.lock_open_rounded,
                label: 'Tanggal dibuka',
                value: formatDdMmYyyy(product.openedDate),
              ),
              _InfoRow(
                icon: Icons.event_busy_outlined,
                label: 'Tanggal kedaluwarsa',
                value: formatDdMmYyyy(product.expiryDate),
                valueColor: product.expiringSoon ? AppColors.red : AppColors.text,
              ),
              const SizedBox(height: 16),
              RoutineToggleCard(
                value: product.active,
                onChanged: (v) => store.setProductActive(product.id, v),
              ),
              const SizedBox(height: 24),
              RvpaButton(
                label: 'Edit Produk',
                icon: Icons.edit_outlined,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductFormScreen(product: product)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.pink),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textGrey)),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }
}
