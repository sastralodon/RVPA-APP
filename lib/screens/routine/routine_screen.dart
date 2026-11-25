import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_utils.dart';
import '../../widgets/common.dart';

/// Screen 8 - Rutinitas Pagi dan Malam.
/// Dibuka dari kartu rutinitas di Beranda.
class RoutineScreen extends StatefulWidget {
  final Slot initialSlot;
  const RoutineScreen({super.key, this.initialSlot = Slot.pagi});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  late Slot _slot = widget.initialSlot;
  DateTime _date = today;

  /// Tujuh hari (Senin - Minggu) dalam minggu tanggal terpilih.
  List<DateTime> get _week {
    final monday = _date.subtract(Duration(days: _date.weekday - 1));
    return List.generate(7, (i) => DateTime(monday.year, monday.month, monday.day + i));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rutinitas')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final steps = store.routineFor(_date, _slot);
          final done = store.doneCount(_date, _slot);
          final progress = steps.isEmpty ? 0.0 : done / steps.length;
          final isFuture = _date.isAfter(today);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              Row(
                children: [
                  Text(formatMonthYear(_date), style: AppText.section),
                  const Spacer(),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => setState(() => _date = _date.subtract(const Duration(days: 7))),
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => setState(() => _date = _date.add(const Duration(days: 7))),
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildWeekStrip(),
              const SizedBox(height: 18),
              _buildSlotSwitch(),
              const SizedBox(height: 16),
              RvpaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Progress rutinitas ${_slot.lower}', style: AppText.label),
                        const Spacer(),
                        Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(color: AppColors.pink, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                        backgroundColor: AppColors.pinkSoft,
                        color: AppColors.pink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('$done dari ${steps.length} langkah selesai', style: AppText.tiny),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                isSameDay(_date, today) ? 'To-do list hari ini' : 'To-do list ${formatLongDate(_date)}',
                style: AppText.section,
              ),
              const SizedBox(height: 12),
              if (steps.isEmpty)
                const RvpaCard(
                  child: Text('Tidak ada produk terjadwal untuk sesi ini.', style: AppText.caption),
                )
              else
                ...steps.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _StepTile(
                        product: p,
                        done: store.isDone(_date, _slot, p.id),
                        enabled: !isFuture,
                        onTap: () => store.toggleDone(_date, _slot, p.id),
                      ),
                    )),
              const SizedBox(height: 8),
              Text(
                isFuture
                    ? 'Rutinitas di tanggal mendatang belum bisa dicentang.'
                    : 'Hanya produk aktif dengan jadwal hari ini yang tampil.',
                textAlign: TextAlign.center,
                style: AppText.tiny,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWeekStrip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _week.map((d) {
        final selected = isSameDay(d, _date);
        return GestureDetector(
          onTap: () => setState(() => _date = d),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 42,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.pink : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: selected ? AppColors.pink : AppColors.border),
            ),
            child: Column(
              children: [
                Text(
                  shortDayNames[d.weekday - 1],
                  style: TextStyle(fontSize: 10.5, color: selected ? Colors.white : AppColors.textGrey),
                ),
                const SizedBox(height: 4),
                Text(
                  '${d.day}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSlotSwitch() {
    Widget option(Slot slot, IconData icon) {
      final selected = _slot == slot;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _slot = slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: selected ? AppColors.pink : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 17, color: selected ? Colors.white : AppColors.pink),
                const SizedBox(width: 8),
                Text(
                  slot.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.pink,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.pinkSoft, borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          option(Slot.pagi, Icons.wb_sunny_outlined),
          option(Slot.malam, Icons.nightlight_outlined),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final Product product;
  final bool done;
  final bool enabled;
  final VoidCallback onTap;

  const _StepTile({required this.product, required this.done, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return RvpaCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: enabled ? onTap : null,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? AppColors.pink : Colors.white,
              border: Border.all(color: AppColors.pink, width: 1.5),
            ),
            child: done ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.brand, style: const TextStyle(fontSize: 11, color: AppColors.pink)),
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: done ? AppColors.textGrey : AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          Tag(product.category, background: const Color(0xFFF4F1F3), foreground: AppColors.textGrey),
        ],
      ),
    );
  }
}
