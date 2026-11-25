import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Bottom navigation 5 menu dengan tombol Analisis bulat di tengah.
class RvpaBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const RvpaBottomNav({super.key, required this.currentIndex, required this.onTap});

  static const _items = [
    (Icons.home_outlined, 'Beranda'),
    (Icons.grid_view_rounded, 'Koleksi'),
    (Icons.photo_camera_outlined, 'Analisis'),
    (Icons.book_outlined, 'Diary'),
    (Icons.person_outline_rounded, 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: List.generate(_items.length, (i) {
              final (icon, label) = _items[i];
              return Expanded(
                child: i == 2
                    ? _CenterButton(icon: icon, label: label, onTap: () => onTap(i))
                    : _NavItem(
                        icon: icon,
                        label: label,
                        selected: currentIndex == i,
                        onTap: () => onTap(i),
                      ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.pink : AppColors.textGrey;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: selected ? AppColors.pinkSoft : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CenterButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Transform.translate(
            offset: const Offset(0, -10),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.pink,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: const [
                  BoxShadow(color: Color(0x40E5508A), blurRadius: 12, offset: Offset(0, 4)),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.pink, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
