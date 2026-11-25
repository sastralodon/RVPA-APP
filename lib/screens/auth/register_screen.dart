import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../main_shell.dart';

/// Screen 2 - Registrasi.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    store.register(name: _name.text.trim(), email: _email.text.trim(), password: _password.text);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          children: [
            Text('Buat akun RVPA', style: AppText.serif(size: 26)),
            const SizedBox(height: 6),
            const Text('Mulai rutinitas skincare yang lebih teratur.', style: AppText.caption),
            const SizedBox(height: 8),
            const FieldLabel('Nama'),
            RvpaTextField(
              controller: _name,
              hint: 'Nama kamu',
              icon: Icons.person_outline_rounded,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const FieldLabel('Email'),
            RvpaTextField(
              controller: _email,
              hint: 'nama@email.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || !v.contains('@')) ? 'Masukkan email yang valid' : null,
            ),
            const FieldLabel('Password'),
            RvpaTextField(
              controller: _password,
              hint: 'Minimal 8 karakter',
              icon: Icons.lock_outline_rounded,
              obscure: true,
              validator: (v) => (v == null || v.length < 8) ? 'Password minimal 8 karakter' : null,
            ),
            const SizedBox(height: 36),
            RvpaButton(label: 'Daftar', onPressed: _register),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sudah punya akun?', style: AppText.caption),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(color: AppColors.pink, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
