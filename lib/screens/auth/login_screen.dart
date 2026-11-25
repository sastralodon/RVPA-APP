import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../main_shell.dart';
import 'register_screen.dart';

/// Screen 3 - Login.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    final error = store.login(_email.text, _password.text);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            children: [
              Center(
                child: Image.asset(
                  'assets/images/face_line.jpg',
                  height: 72,
                  color: AppColors.background,
                  colorBlendMode: BlendMode.multiply,
                ),
              ),
              const SizedBox(height: 18),
              Text('Selamat datang kembali', textAlign: TextAlign.center, style: AppText.serif(size: 24)),
              const SizedBox(height: 6),
              const Text(
                'Masuk untuk melanjutkan rutinitasmu.',
                textAlign: TextAlign.center,
                style: AppText.caption,
              ),
              const SizedBox(height: 16),
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
                hint: 'Password kamu',
                icon: Icons.lock_outline_rounded,
                obscure: true,
                validator: (v) => (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: AppColors.red, fontSize: 12)),
              ],
              const SizedBox(height: 32),
              RvpaButton(label: 'Masuk', onPressed: _login),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun?', style: AppText.caption),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                    child: const Text(
                      'Daftar',
                      style: TextStyle(color: AppColors.pink, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
