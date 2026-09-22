import 'package:flutter/material.dart';
import '../../backend/models/sample_data.dart';
import '../theme/app_theme.dart';
class ScheduleTab extends StatelessWidget {
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const dates = [7, 8, 9, 10, 11, 12, 13];
    const todayIndex = 1; // Monday highlighted, matching the mockup.

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedule',
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700)),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('September 2026',
              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (i) {
              final selected = i == todayIndex;
              return Column(
                children: [
                  Text(days[i], style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor:
                        selected ? AppColors.primaryNavy : Colors.transparent,
                    child: Text(
                      '${dates[i]}',
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.textDark,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 24),
          const Text('Today',
              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 12),
          ...kSampleSchedule.map((a) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.fieldFill,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.fieldBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.time,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, color: AppColors.textDark, fontSize: 13)),
                          Text(a.title, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: a.status == 'Confirmed'
                            ? AppColors.selectedCardFill
                            : const Color(0xFFF3EAD3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        a.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: a.status == 'Confirmed'
                              ? AppColors.primaryNavy
                              : const Color(0xFF8A6D1D),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
