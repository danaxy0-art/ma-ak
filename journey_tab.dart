import 'package:flutter/material.dart';
import '../../models/sample_data.dart';
import '../../theme/app_theme.dart';

class JourneyTab extends StatelessWidget {
  const JourneyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey',
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700)),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: kSampleJourney.length,
        itemBuilder: (context, i) {
          final step = kSampleJourney[i];
          final isLast = i == kSampleJourney.length - 1;
          Color dotColor;
          IconData dotIcon;
          switch (step.status) {
            case JourneyStatus.completed:
              dotColor = AppColors.primaryNavy;
              dotIcon = Icons.check;
              break;
            case JourneyStatus.inProgress:
              dotColor = AppColors.primaryNavy;
              dotIcon = Icons.autorenew;
              break;
            case JourneyStatus.upcoming:
              dotColor = AppColors.textMuted;
              dotIcon = Icons.circle_outlined;
              break;
          }
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                      child: Icon(dotIcon, color: Colors.white, size: 16),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(width: 2, color: AppColors.divider),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, color: AppColors.textDark)),
                        Text(step.subtitle,
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ],
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
