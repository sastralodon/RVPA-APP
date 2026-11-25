import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_utils.dart';
import '../../widgets/calendar.dart';
import '../../widgets/common.dart';

/// Screen 7 - Tambah Produk / Edit Produk.
/// Jika [product] diisi, form berjalan dalam mode edit.
class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _brand;

  late String _category;
  late bool _morning;
  late bool _night;
  late bool _everyDay;
  late Set<int> _days;
  DateTime? _opened;
  DateTime? _expiry;
  late bool _active;
  String? _photoPath;

  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name = TextEditingController(text: p?.name ?? '');
    _brand = TextEditingController(text: p?.brand ?? '');
    _category = p?.category ?? productCategories.first;
    _morning = p?.morning ?? true;
    _night = p?.night ?? false;
    _everyDay = p?.everyDay ?? true;
    _days = {...?p?.days};
    _opened = p?.openedDate;
    _expiry = p?.expiryDate;
    _active = p?.active ?? true;
    _photoPath = p?.photoPath;
  }

  @override
  void dispose() {
    _name.dispose();
    _brand.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (file != null) setState(() => _photoPath = file.path);
  }

  Future<void> _pickDate({required bool opened}) async {
    final current = opened ? _opened : _expiry;
    final picked = await showRvpaDatePicker(
      context,
      title: opened ? 'Tanggal dibuka' : 'Tanggal kedaluwarsa',
      initialDate: current ?? today,
    );
    if (picked == null) return;
    setState(() {
      if (opened) {
        _opened = picked;
      } else {
        _expiry = picked;
      }
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    String? error;
    if (!_morning && !_night) {
      error = 'Pilih waktu pemakaian (pagi, malam, atau keduanya)';
    } else if (!_everyDay && _days.isEmpty) {
      error = 'Pilih minimal satu hari pemakaian';
    } else if (_opened == null || _expiry == null) {
      error = 'Isi tanggal dibuka dan tanggal kedaluwarsa';
    } else if (_expiry!.isBefore(_opened!)) {
      error = 'Tanggal kedaluwarsa tidak boleh sebelum tanggal dibuka';
    }
    if (error != null) {
      showMessage(context, error);
      return;
    }

    final product = Product(
      id: widget.product?.id ?? store.newId('p'),
      name: _name.text.trim(),
      brand: _brand.text.trim(),
      category: _category,
      morning: _morning,
      night: _night,
      days: _everyDay ? <int>{} : {..._days},
      openedDate: _opened!,
      expiryDate: _expiry!,
      active: _active,
      photoPath: _photoPath,
    );
    if (_isEdit) {
      store.updateProduct(product);
    } else {
      store.addProduct(product);
    }
    Navigator.pop(context);
    showMessage(context, _isEdit ? 'Perubahan disimpan' : 'Produk ditambahkan');
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = _expiry == null ? null : dateOnly(_expiry!).difference(today).inDays;

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Produk' : 'Tambah Produk')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            _buildPhoto(),
            const FieldLabel('Nama produk'),
            RvpaTextField(
              controller: _name,
              hint: 'Contoh: Niacinamide 10% + Zinc 1%',
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama produk wajib diisi' : null,
            ),
            const FieldLabel('Merek'),
            RvpaTextField(
              controller: _brand,
              hint: 'Contoh: The Ordinary',
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Merek wajib diisi' : null,
            ),
            const FieldLabel('Kategori'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: productCategories
                  .map((c) => SelectChip(
                        label: c,
                        selected: _category == c,
                        onTap: () => setState(() => _category = c),
                      ))
                  .toList(),
            ),
            const FieldLabel('Waktu pemakaian'),
            Row(
              children: [
                SelectChip(
                  label: 'Pagi',
                  icon: Icons.wb_sunny_outlined,
                  selected: _morning,
                  onTap: () => setState(() => _morning = !_morning),
                ),
                const SizedBox(width: 8),
                SelectChip(
                  label: 'Malam',
                  icon: Icons.nightlight_outlined,
                  selected: _night,
                  onTap: () => setState(() => _night = !_night),
                ),
                const SizedBox(width: 10),
                const Text('Bisa pilih keduanya', style: AppText.tiny),
              ],
            ),
            const FieldLabel('Jadwal pemakaian (hari)'),
            Row(
              children: [
                SelectChip(
                  label: 'Setiap hari',
                  selected: _everyDay,
                  onTap: () => setState(() => _everyDay = true),
                ),
                const SizedBox(width: 8),
                SelectChip(
                  label: 'Hari tertentu',
                  selected: !_everyDay,
                  onTap: () => setState(() => _everyDay = false),
                ),
              ],
            ),
            if (!_everyDay) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (i) {
                  final day = i + 1;
                  return DayCircle(
                    label: shortDayNames[i],
                    selected: _days.contains(day),
                    onTap: () => setState(() {
                      if (!_days.remove(day)) _days.add(day);
                    }),
                  );
                }),
              ),
            ],
            const FieldLabel('Tanggal dibuka'),
            _DateField(date: _opened, onTap: () => _pickDate(opened: true)),
            const FieldLabel('Tanggal kedaluwarsa'),
            _DateField(date: _expiry, onTap: () => _pickDate(opened: false)),
            if (_isEdit) ...[
              const SizedBox(height: 16),
              RoutineToggleCard(value: _active, onChanged: (v) => setState(() => _active = v)),
            ],
            if (daysLeft != null && daysLeft <= 30) ...[
              const SizedBox(height: 16),
              ExpiryWarning(daysLeft: daysLeft),
            ],
            const SizedBox(height: 8),
            const Text('Peringatan muncul otomatis dari tanggal kedaluwarsa.', style: AppText.tiny),
            const SizedBox(height: 24),
            RvpaButton(label: _isEdit ? 'Simpan perubahan' : 'Simpan', onPressed: _save),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    if (_photoPath != null) {
      return GestureDetector(
        onTap: _pickPhoto,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Image.file(File(_photoPath!), height: 150, width: double.infinity, fit: BoxFit.cover),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: const Text('Ubah foto', style: TextStyle(fontSize: 12, color: AppColors.pink)),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return DashedBox(
      height: 130,
      onTap: _pickPhoto,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.photo_camera_outlined, color: AppColors.pink, size: 28),
          const SizedBox(height: 8),
          Text(
            _isEdit ? 'Ubah foto' : 'Tambah foto (opsional)',
            style: const TextStyle(fontSize: 12.5, color: AppColors.pink),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime? date;
  final VoidCallback onTap;
  const _DateField({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.pink),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date == null ? 'Pilih tanggal' : formatDdMmYyyy(date!),
                style: TextStyle(fontSize: 14, color: date == null ? AppColors.textLight : AppColors.text),
              ),
            ),
            const Text('dd/mm/yyyy', style: AppText.tiny),
          ],
        ),
      ),
    );
  }
}
