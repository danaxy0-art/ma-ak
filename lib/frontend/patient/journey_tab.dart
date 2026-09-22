import 'package:flutter/material.dart';
import '../../backend/models/sample_data.dart';
import '../theme/app_theme.dart';

class JourneyTab extends StatelessWidget {
  const JourneyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey',
            style: TextStyle(
                color: AppColors.textDark, fontWeight: FontWeight.w700)),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        itemCount: kSampleJourney.length,
        itemBuilder: (context, i) {
          final step = kSampleJourney[i];
          final isLast = i == kSampleJourney.length - 1;

          late final Color dotColor;
          late final Color dotBg;
          late final IconData dotIcon;
          late final String badgeText;
          late final Color badgeColor;
          late final Color badgeBg;

          switch (step.status) {
            case JourneyStatus.completed:
              dotColor = Colors.white;
              dotBg = AppColors.primaryNavy;
              dotIcon = Icons.check;
              badgeText = 'Completed';
              badgeColor = const Color(0xFF2F7A4B);
              badgeBg = const Color(0xFFE5F3E8);
              break;
            case JourneyStatus.inProgress:
              dotColor = Colors.white;
              dotBg = AppColors.primaryNavy;
              dotIcon = Icons.autorenew;
              badgeText = 'In progress';
              badgeColor = const Color(0xFF3E6E8E);
              badgeBg = const Color(0xFFE6F0F5);
              break;
            case JourneyStatus.upcoming:
              dotColor = AppColors.textMuted;
              dotBg = AppColors.fieldFill;
              dotIcon = Icons.circle_outlined;
              badgeText = 'Upcoming';
              badgeColor = AppColors.textMuted;
              badgeBg = AppColors.background;
              break;
          }

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: dotBg,
                        shape: BoxShape.circle,
                        border: step.status == JourneyStatus.upcoming
                            ? Border.all(
                                color: AppColors.fieldBorder, width: 1.4)
                            : null,
                        boxShadow: step.status != JourneyStatus.upcoming
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryNavy
                                      .withValues(alpha: 0.18),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(dotIcon, color: dotColor, size: 16),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: step.status == JourneyStatus.upcoming
                              ? AppColors.divider
                              : AppColors.primaryNavy.withValues(alpha: 0.35),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.fieldFill,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.fieldBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(step.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textDark,
                                        fontSize: 14)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: badgeBg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  badgeText,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: badgeColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(step.subtitle,
                              style: const TextStyle(
                                  color: AppColors.textMuted, fontSize: 12.5)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
