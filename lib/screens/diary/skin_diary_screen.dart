import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_utils.dart';
import '../../widgets/calendar.dart';
import '../../widgets/common.dart';

/// Screen 10 - Skin Diary.
/// Kalender diwarnai sesuai progress rutinitas harian. Pilih tanggal untuk
/// melihat produk yang dipakai dan menulis catatan diary.
class SkinDiaryScreen extends StatefulWidget {
  const SkinDiaryScreen({super.key});

  @override
  State<SkinDiaryScreen> createState() => _SkinDiaryScreenState();
}

class _SkinDiaryScreenState extends State<SkinDiaryScreen> {
  DateTime _month = DateTime(today.year, today.month);
  DateTime? _selected;
  final _note = TextEditingController();
  bool _editing = false;
  bool _justSaved = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _select(DateTime date) {
    if (date.isAfter(today)) {
      showMessage(context, 'Diary hanya bisa diisi sampai hari ini');
      return;
    }
    final existing = store.diaryFor(date);
    setState(() {
      _selected = date;
      _note.text = existing ?? '';
      _editing = existing == null;
      _justSaved = false;
    });
  }

  void _save() {
    final date = _selected!;
    if (_note.text.trim().isEmpty) {
      showMessage(context, 'Tulis catatan dulu sebelum menyimpan');
      return;
    }
    store.saveDiary(date, _note.text);
    FocusScope.of(context).unfocus();
    setState(() {
      _editing = false;
      _justSaved = true;
    });
  }

  Future<void> _delete() async {
    final date = _selected!;
    if (store.diaryFor(date) == null) {
      _note.clear();
      return;
    }
    final ok = await confirmDialog(context, title: 'Hapus catatan?', message: 'Catatan diary tanggal ini akan dihapus.');
    if (!ok) return;
    store.deleteDiary(date);
    setState(() {
      _note.clear();
      _editing = true;
      _justSaved = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              children: [
                Text('Skin Diary', style: AppText.serif(size: 26)),
                const SizedBox(height: 4),
                Text(
                  _justSaved ? 'Diary berhasil disimpan' : 'Catat rutinitas dan kondisi kulitmu.',
                  style: TextStyle(fontSize: 12, color: _justSaved ? AppColors.greenText : AppColors.textGrey),
                ),
                const SizedBox(height: 16),
                _buildCalendar(),
                if (_selected != null) ...[
                  const SizedBox(height: 22),
                  _buildDayDetail(_selected!),
                ],
              ],
            );
          },
        ),
      ),
      floatingActionButton: _selected == null
          ? FloatingActionButton(
              onPressed: () => _select(today),
              backgroundColor: AppColors.pink,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.add_rounded, size: 30),
            )
          : null,
    );
  }

  Widget _buildCalendar() {
    return RvpaCard(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 14),
      child: Column(
        children: [
          MonthHeader(month: _month, onChanged: (m) => setState(() => _month = m)),
          MonthGrid(
            month: _month,
            rowHeight: 42,
            dayBuilder: (date, _) {
              final progress = store.dayProgress(date);
              Color bg = Colors.transparent;
              Color fg = AppColors.textLight;
              if (progress != null) {
                fg = AppColors.text;
                if (progress >= 1) {
                  bg = AppColors.green;
                } else if (progress > 0) {
                  bg = AppColors.yellow;
                } else {
                  bg = AppColors.pinkSoft;
                }
              }
              final selected = _selected != null && isSameDay(date, _selected!);
              final isToday = isSameDay(date, today);
              return GestureDetector(
                onTap: () => _select(date),
                child: Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bg,
                    border: selected || isToday
                        ? Border.all(color: AppColors.pink, width: selected ? 2 : 1)
                        : null,
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: progress != null ? FontWeight.w600 : FontWeight.w400,
                      color: fg,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legend(color: AppColors.green, label: '100%'),
              SizedBox(width: 18),
              _Legend(color: AppColors.yellow, label: '1-99%'),
              SizedBox(width: 18),
              _Legend(color: AppColors.pinkSoft, label: '0%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayDetail(DateTime date) {
    final progress = store.dayProgress(date);
    final morning = store.usedProducts(date, Slot.pagi);
    final night = store.usedProducts(date, Slot.malam);
    final saved = store.diaryFor(date) != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(formatFullDate(date), style: AppText.section)),
            if (progress != null)
              Tag(
                '${(progress * 100).round()}%',
                background: AppColors.yellow,
                foreground: AppColors.yellowText,
              ),
          ],
        ),
        const SizedBox(height: 12),
        _UsedProductsCard(slot: Slot.pagi, products: morning),
        const SizedBox(height: 10),
        _UsedProductsCard(slot: Slot.malam, products: night),
        const SizedBox(height: 10),
        RvpaCard(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Catatan diary', style: AppText.label),
                  const Spacer(),
                  IconButton(
                    onPressed: _delete,
                    tooltip: 'Hapus catatan',
                    icon: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: AppColors.pinkSoft, shape: BoxShape.circle),
                      child: const Icon(Icons.close_rounded, size: 14, color: AppColors.pink),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _editing
                    ? TextField(
                        controller: _note,
                        maxLines: 5,
                        minLines: 4,
                        style: AppText.body,
                        decoration: const InputDecoration(
                          hintText: 'Bagaimana kondisi kulitmu hari ini?',
                          hintStyle: TextStyle(fontSize: 13, color: AppColors.textLight),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      )
                    : ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 80),
                        child: Text(store.diaryFor(date) ?? '', style: AppText.body),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _editing
            ? RvpaButton(label: 'Simpan', icon: Icons.edit_outlined, onPressed: _save)
            : RvpaButton(
                label: saved ? 'Edit diary' : 'Tulis diary',
                onPressed: () => setState(() => _editing = true),
              ),
      ],
    );
  }
}

class _UsedProductsCard extends StatelessWidget {
  final Slot slot;
  final List<Product> products;
  const _UsedProductsCard({required this.slot, required this.products});

  @override
  Widget build(BuildContext context) {
    return RvpaCard(
      color: AppColors.pinkLight,
      borderColor: AppColors.pinkSoft,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                slot == Slot.pagi ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
                size: 16,
                color: AppColors.pink,
              ),
              const SizedBox(width: 8),
              Text('${slot.label} hari', style: AppText.label),
            ],
          ),
          const SizedBox(height: 8),
          if (products.isEmpty)
            const Text('•  Belum ada produk dipakai', style: AppText.caption)
          else
            ...products.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    children: [
                      const Text('•  ', style: TextStyle(color: AppColors.pink)),
                      Expanded(child: Text(p.name, style: const TextStyle(fontSize: 12.5))),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: AppText.tiny),
      ],
    );
  }
}
