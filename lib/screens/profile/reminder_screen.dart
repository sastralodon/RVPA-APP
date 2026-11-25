import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_utils.dart';
import '../../widgets/common.dart';
import 'alarm_form_screen.dart';

/// Screen 11 - Reminder (daftar alarm pengingat rutinitas).
class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  void _openForm(BuildContext context, [Alarm? alarm]) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AlarmFormScreen(alarm: alarm)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminder')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              const Text('Alarm rutinitas', style: AppText.section),
              const SizedBox(height: 4),
              const Text('Atur jam dan catatan pengingat skincare.', style: AppText.caption),
              const SizedBox(height: 16),
              ...store.alarms.map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AlarmCard(alarm: a, onTap: () => _openForm(context, a)),
                  )),
              DashedBox(
                height: 52,
                radius: 26,
                onTap: () => _openForm(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, color: AppColors.pink, size: 20),
                    SizedBox(width: 8),
                    Text('Tambah alarm', style: TextStyle(color: AppColors.pink, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final VoidCallback onTap;
  const _AlarmCard({required this.alarm, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final on = alarm.enabled;
    final main = on ? AppColors.text : AppColors.textLight;
    return RvpaCard(
      onTap: onTap,
      color: on ? Colors.white : const Color(0xFFF7F5F6),
      padding: const EdgeInsets.fromLTRB(18, 14, 10, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatTime(alarm.hour, alarm.minute),
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: main, letterSpacing: 1),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      alarm.isNight ? Icons.nightlight_outlined : Icons.wb_sunny_outlined,
                      size: 15,
                      color: on ? AppColors.pink : AppColors.textLight,
                    ),
                    const SizedBox(width: 6),
                    Text(alarm.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: main)),
                  ],
                ),
                if (alarm.note.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(alarm.note, style: AppText.caption),
                ],
              ],
            ),
          ),
          Switch(value: on, onChanged: (v) => store.toggleAlarm(alarm.id, v)),
        ],
      ),
    );
  }
}
