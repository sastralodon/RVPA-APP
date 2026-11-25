import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

/// Screen 5 - Koleksi.
class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  String _category = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final products = _category == 'Semua'
                ? store.products
                : store.products.where((p) => p.category == _category).toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              children: [
                Text('Koleksi', style: AppText.serif(size: 26)),
                const SizedBox(height: 4),
                Text('${store.products.length} produk', style: AppText.caption),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Semua', ...productCategories]
                      .map((c) => SelectChip(
                            label: c,
                            selected: c == _category,
                            onTap: () => setState(() => _category = c),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 18),
                if (products.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: Text('Belum ada produk di kategori ini', style: AppText.caption)),
                  )
                else
                  ...products.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ProductTile(product: p),
                      )),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductFormScreen()),
        ),
        backgroundColor: AppColors.pink,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return RvpaCard(
      padding: const EdgeInsets.all(10),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: product.id)),
      ),
      child: Row(
        children: [
          ProductThumb(product: product, size: 70),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand,
                  style: TextStyle(fontSize: 11, color: product.active ? AppColors.pink : AppColors.textGrey),
                ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Tag.category(product.category),
                    Tag(product.timeLabel),
                  ],
                ),
              ],
            ),
          ),
          // Titik hijau = aktif masuk rutinitas, abu-abu = nonaktif
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 4),
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: product.active ? const Color(0xFF3CC27A) : AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
