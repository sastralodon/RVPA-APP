import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'edit_photo_screen.dart';

/// Screen 12 - Edit Profil.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: store.user.name);
  final _email = TextEditingController(text: store.user.email);
  final _password = TextEditingController(text: store.user.password);
  late int _age = store.user.age;
  late String _gender = store.user.gender;
  late String _skinType = store.user.skinType;

  static const int _minAge = 10;
  static const int _maxAge = 80;
  late final FixedExtentScrollController _ageController =
      FixedExtentScrollController(initialItem: _age - _minAge);

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    store.updateProfile(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
      age: _age,
      gender: _gender,
      skinType: _skinType,
    );
    Navigator.pop(context);
    showMessage(context, 'Profil diperbarui');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Center(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditPhotoScreen()),
                ),
                child: ListenableBuilder(
                  listenable: store,
                  builder: (context, _) => Stack(
                    children: [
                      Avatar(photoPath: store.user.photoPath, size: 92, background: AppColors.pinkSoft),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.pink,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.photo_camera_outlined, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const FieldLabel('Nama'),
            RvpaTextField(
              controller: _name,
              icon: Icons.person_outline_rounded,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const FieldLabel('Email'),
            RvpaTextField(
              controller: _email,
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || !v.contains('@')) ? 'Masukkan email yang valid' : null,
            ),
            const FieldLabel('Password'),
            RvpaTextField(
              controller: _password,
              icon: Icons.lock_outline_rounded,
              obscure: true,
              validator: (v) => (v == null || v.length < 8) ? 'Password minimal 8 karakter' : null,
            ),
            const FieldLabel('Umur', trailing: Text('scroll untuk memilih', style: AppText.tiny)),
            _buildAgeWheel(),
            const FieldLabel('Gender'),
            Wrap(
              spacing: 8,
              children: genders
                  .map((g) => SelectChip(label: g, selected: _gender == g, onTap: () => setState(() => _gender = g)))
                  .toList(),
            ),
            const FieldLabel('Jenis kulit'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skinTypes
                  .map((s) => SelectChip(
                        label: s,
                        selected: _skinType == s,
                        onTap: () => setState(() => _skinType = s),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            const Text('Ditampilkan di kartu profil.', style: AppText.tiny),
            const SizedBox(height: 28),
            RvpaButton(label: 'Simpan perubahan', onPressed: _save),
          ],
        ),
      ),
    );
  }

  /// Pemilih umur dengan scroll angka.
  Widget _buildAgeWheel() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: AppColors.pinkSoft, borderRadius: BorderRadius.circular(10)),
          ),
          ListWheelScrollView.useDelegate(
            controller: _ageController,
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (i) => setState(() => _age = _minAge + i),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: _maxAge - _minAge + 1,
              builder: (context, i) {
                final value = _minAge + i;
                final selected = value == _age;
                return Center(
                  child: Text(
                    '$value',
                    style: TextStyle(
                      fontSize: selected ? 18 : 14,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: selected ? AppColors.pink : AppColors.textLight,
                    ),
                  ),
                );
              },
            ),
          ),
          const Positioned(
            right: 28,
            child: Text('tahun', style: TextStyle(fontSize: 12, color: AppColors.pink)),
          ),
        ],
      ),
    );
  }
}
