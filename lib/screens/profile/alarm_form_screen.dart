import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_utils.dart';
import '../../widgets/common.dart';

/// Pengaturan alarm (tambah / edit satu alarm).
///
/// Catatan: layar ini menyimpan data alarm. Untuk membunyikan notifikasi
/// sungguhan, sambungkan [AppStore.saveAlarm] ke flutter_local_notifications.
class AlarmFormScreen extends StatefulWidget {
  final Alarm? alarm;
  const AlarmFormScreen({super.key, this.alarm});

  @override
  State<AlarmFormScreen> createState() => _AlarmFormScreenState();
}

class _AlarmFormScreenState extends State<AlarmFormScreen> {
  late final TextEditingController _name = TextEditingController(text: widget.alarm?.name ?? '');
  late final TextEditingController _note = TextEditingController(text: widget.alarm?.note ?? '');
  late int _hour = widget.alarm?.hour ?? 6;
  late int _minute = widget.alarm?.minute ?? 30;
  late bool _enabled = widget.alarm?.enabled ?? true;
  late final Set<int> _days = {...?widget.alarm?.days};

  bool get _isEdit => widget.alarm != null;

  @override
  void initState() {
    super.initState();
    if (!_isEdit) _days.addAll([1, 2, 3, 4, 5, 6, 7]);
  }

  @override
  void dispose() {
    _name.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: _minute),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      _hour = picked.hour;
      _minute = picked.minute;
    });
  }

  void _save() {
    if (_name.text.trim().isEmpty) {
      showMessage(context, 'Nama alarm wajib diisi');
      return;
    }
    if (_days.isEmpty) {
      showMessage(context, 'Pilih minimal satu hari');
      return;
    }
    store.saveAlarm(Alarm(
      id: widget.alarm?.id ?? store.newId('a'),
      name: _name.text.trim(),
      hour: _hour,
      minute: _minute,
      enabled: _enabled,
      days: {..._days},
      note: _note.text.trim(),
    ));
    Navigator.pop(context);
    showMessage(context, 'Alarm disimpan');
  }

  Future<void> _delete() async {
    final ok = await confirmDialog(context, title: 'Hapus alarm?', message: 'Alarm ini akan dihapus.');
    if (!ok || !mounted) return;
    store.deleteAlarm(widget.alarm!.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final hh = _hour.toString().padLeft(2, '0');
    final mm = _minute.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan alarm'),
        actions: [
          if (_isEdit)
            IconButton(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.red),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const FieldLabel('Nama alarm'),
          RvpaTextField(controller: _name, hint: 'Contoh: Skincare pagi'),
          const SizedBox(height: 16),
          RvpaCard(
            onTap: _pickTime,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Waktu pengingat', style: AppText.caption),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    '$hh  :  $mm',
                    style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w700, letterSpacing: 1),
                  ),
                ),
                const Center(child: Text('Ketuk untuk ubah waktu', style: AppText.tiny)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          RvpaCard(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Aktifkan alarm', style: AppText.label),
                          Text('Pengingat menyala sesuai jadwal.', style: AppText.tiny),
                        ],
                      ),
                    ),
                    Switch(value: _enabled, onChanged: (v) => setState(() => _enabled = v)),
                  ],
                ),
                const Divider(height: 24, color: AppColors.border),
                const Row(
                  children: [
                    Text('Ulang', style: AppText.label),
                    Spacer(),
                    Text('Pilih hari', style: AppText.tiny),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (i) {
                    final day = i + 1;
                    return DayCircle(
                      label: shortDayNames[i],
                      size: 36,
                      selected: _days.contains(day),
                      onTap: () => setState(() {
                        if (!_days.remove(day)) _days.add(day);
                      }),
                    );
                  }),
                ),
              ],
            ),
          ),
          const FieldLabel('Catatan pengingat'),
          RvpaTextField(controller: _note, hint: 'Contoh: Jangan lupa sunscreen sebelum keluar', maxLines: 3),
          const SizedBox(height: 10),
          const Text(
            'Matikan sakelar untuk menjeda alarm tanpa menghapus waktu dan catatanmu.',
            style: AppText.tiny,
          ),
          const SizedBox(height: 24),
          RvpaButton(label: 'Simpan alarm', onPressed: _save),
        ],
      ),
    );
  }
}
