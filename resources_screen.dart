import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.favorite_border, 'Mental Health Support', 'Take care of your mind'),
      (Icons.restaurant_outlined, 'Nutrition Guide', 'Healthy eating tips'),
      (Icons.fitness_center_outlined, 'Exercise & Activity', 'Safe exercises for you'),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Resources',
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final (icon, title, subtitle) = items[i];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.selectedCardFill,
                  child: Icon(icon, color: AppColors.primaryNavy),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ],
            ),
          );
        },
      ),
    );
  }
}
