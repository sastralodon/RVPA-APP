import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../auth/login_screen.dart';
import 'about_screen.dart';
import 'edit_profile_screen.dart';
import 'reminder_screen.dart';

/// Screen 9 - Profil.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final ok = await confirmDialog(
      context,
      title: 'Keluar dari akun?',
      message: 'Kamu perlu login lagi untuk melanjutkan rutinitas.',
      confirmLabel: 'Keluar',
    );
    if (!ok || !context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final user = store.user;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: [
              Text('Profil', style: AppText.serif(size: 26)),
              const SizedBox(height: 16),

              // Kartu identitas
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: AppColors.pinkSoft, borderRadius: BorderRadius.circular(22)),
                child: Row(
                  children: [
                    Avatar(photoPath: user.photoPath, size: 64),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: AppText.serif(size: 20)),
                          const SizedBox(height: 2),
                          Text(user.email, style: AppText.caption),
                          const SizedBox(height: 8),
                          Tag(
                            'Kulit ${user.skinType.toLowerCase()}',
                            icon: Icons.water_drop_outlined,
                            background: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _StatCard(icon: Icons.science_outlined, value: '${store.products.length}', label: 'Produk'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(icon: Icons.book_outlined, value: '${store.diaryCount}', label: 'Diary'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _MenuTile(
                icon: Icons.notifications_none_rounded,
                title: 'Pengaturan Reminder',
                onTap: () => _open(context, const ReminderScreen()),
              ),
              _MenuTile(
                icon: Icons.edit_outlined,
                title: 'Edit Profil',
                onTap: () => _open(context, const EditProfileScreen()),
              ),
              _MenuTile(
                icon: Icons.info_outline_rounded,
                title: 'Tentang RVPA',
                onTap: () => _open(context, const AboutScreen()),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: TextButton.icon(
                  onPressed: () => _logout(context),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.pinkSoft,
                    foregroundColor: AppColors.pink,
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return RvpaCard(
      child: Row(
        children: [
          Icon(icon, color: AppColors.pink, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppText.serif(size: 20)),
              Text(label, style: AppText.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _MenuTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RvpaCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: AppColors.pinkSoft, shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: AppColors.pink),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
