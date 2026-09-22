import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
class MaakNavItem {
  final IconData icon;
  final String label;
  const MaakNavItem({required this.icon, required this.label});
}

/// A simple, consistently-styled bottom nav bar. Both PatientShell and
/// VolunteerShell reuse this with their own list of tabs so the whole app
/// stays on one visual language (navy blue, no purple).
class MaakBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<MaakNavItem> items;

  const MaakBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.fieldFill,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = i == currentIndex;
              final color =
                  selected ? AppColors.primaryNavy : AppColors.textMuted;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(items[i].icon, color: color, size: 24),
                      const SizedBox(height: 2),
                      Text(
                        items[i].label,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
