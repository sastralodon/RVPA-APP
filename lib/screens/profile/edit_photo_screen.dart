import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

/// Edit foto profil (dibuka dari Edit Profil).
class EditPhotoScreen extends StatefulWidget {
  const EditPhotoScreen({super.key});

  @override
  State<EditPhotoScreen> createState() => _EditPhotoScreenState();
}

class _EditPhotoScreenState extends State<EditPhotoScreen> {
  String? _photoPath = store.user.photoPath;

  Future<void> _upload() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (file != null) setState(() => _photoPath = file.path);
  }

  void _save() {
    store.updatePhoto(_photoPath);
    Navigator.pop(context);
    showMessage(context, 'Foto profil diperbarui');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit foto profil')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          children: [
            Avatar(photoPath: _photoPath, size: 150, background: AppColors.pinkSoft),
            const SizedBox(height: 14),
            const Text('Foto profil', style: AppText.caption),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: RvpaButton(label: 'Unggah foto', outlined: true, height: 44, onPressed: _upload),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: _photoPath == null ? null : () => setState(() => _photoPath = null),
              child: const Text('Hapus foto', style: TextStyle(color: AppColors.pink)),
            ),
            const Spacer(),
            RvpaButton(label: 'Simpan perubahan', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
