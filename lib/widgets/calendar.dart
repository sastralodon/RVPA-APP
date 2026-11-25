import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/date_utils.dart';

/// Header bulan dengan tombol sebelumnya / berikutnya.
class MonthHeader extends StatelessWidget {
  final DateTime month;
  final ValueChanged<DateTime> onChanged;

  const MonthHeader({super.key, required this.month, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => onChanged(DateTime(month.year, month.month - 1)),
          icon: const Icon(Icons.chevron_left_rounded),
          visualDensity: VisualDensity.compact,
        ),
        Expanded(
          child: Text(
            formatMonthYear(month),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        IconButton(
          onPressed: () => onChanged(DateTime(month.year, month.month + 1)),
          icon: const Icon(Icons.chevron_right_rounded),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

/// Grid tanggal satu bulan (Senin sebagai awal minggu).
///
/// [dayBuilder] menggambar setiap tanggal. Tanggal dari bulan lain
/// dikirim dengan `inMonth = false`.
class MonthGrid extends StatelessWidget {
  final DateTime month;
  final Widget Function(DateTime date, bool inMonth) dayBuilder;
  final bool showOtherMonthDays;
  final double rowHeight;

  const MonthGrid({
    super.key,
    required this.month,
    required this.dayBuilder,
    this.showOtherMonthDays = false,
    this.rowHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final start = first.subtract(Duration(days: first.weekday - 1));
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final cells = ((first.weekday - 1 + daysInMonth) / 7).ceil() * 7;

    return Column(
      children: [
        Row(
          children: shortDayNames
              .map((d) => Expanded(
                    child: Center(
                      child: Text(d, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 6),
        for (var row = 0; row < cells / 7; row++)
          SizedBox(
            height: rowHeight,
            child: Row(
              children: List.generate(7, (col) {
                final date = DateTime(start.year, start.month, start.day + row * 7 + col);
                final inMonth = date.month == month.month;
                return Expanded(
                  child: Center(
                    child: inMonth || showOtherMonthDays ? dayBuilder(date, inMonth) : const SizedBox.shrink(),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

/// Dialog pemilih tanggal bergaya RVPA (sesuai frame "Kalender terbuka").
Future<DateTime?> showRvpaDatePicker(
  BuildContext context, {
  required String title,
  required DateTime initialDate,
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (_) => _DatePickerDialog(title: title, initialDate: initialDate),
  );
}

class _DatePickerDialog extends StatefulWidget {
  final String title;
  final DateTime initialDate;
  const _DatePickerDialog({required this.title, required this.initialDate});

  @override
  State<_DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<_DatePickerDialog> {
  late DateTime _selected = dateOnly(widget.initialDate);
  late DateTime _month = DateTime(widget.initialDate.year, widget.initialDate.month);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: AppText.label),
            const SizedBox(height: 6),
            Text(formatLongDate(_selected), style: AppText.serif(size: 24, color: AppColors.pinkDark)),
            const SizedBox(height: 12),
            MonthHeader(month: _month, onChanged: (m) => setState(() => _month = m)),
            MonthGrid(
              month: _month,
              showOtherMonthDays: true,
              dayBuilder: (date, inMonth) {
                final selected = isSameDay(date, _selected);
                return GestureDetector(
                  onTap: () => setState(() {
                    _selected = date;
                    if (!inMonth) _month = DateTime(date.year, date.month);
                  }),
                  child: Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? AppColors.pinkDark : Colors.transparent,
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                        color: selected
                            ? Colors.white
                            : inMonth
                                ? AppColors.text
                                : AppColors.textLight,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal', style: TextStyle(color: AppColors.pinkDark, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, _selected),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Pilih tanggal', style: TextStyle(fontWeight: FontWeight.w600)),
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
