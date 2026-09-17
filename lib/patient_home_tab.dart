import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'find_volunteer_screen.dart';
import 'journey_tab.dart';
import 'resources_screen.dart';
import 'messages_tab.dart';
import 'patient_profile_tab.dart';

class PatientHomeTab extends StatelessWidget {
  final String patientName;
  const PatientHomeTab({super.key, this.patientName = 'Rana'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text('Hello $patientName',
                style: const TextStyle(
                    color: AppColors.textDark, fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(width: 6),
            const Icon(Icons.favorite, color: AppColors.primaryNavy, size: 18),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.selectedCardFill,
              child: Icon(Icons.person, color: AppColors.primaryNavy, size: 18),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("You're not alone. We're here with you.",
              style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.selectedCardFill,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Find the right volunteer\nfor your journey',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const SizedBox(height: 6),
                const Text('Get matched with someone who understands you.',
                    style: TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 14),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(160, 44)),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FindVolunteerScreen()),
                  ),
                  child: const Text('Find a volunteer'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _QuickAction(
                icon: Icons.timeline_outlined,
                title: 'My Journey',
                subtitle: 'Track your progress',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const JourneyTab()),
                ),
              ),
              _QuickAction(
                icon: Icons.chat_bubble_outline,
                title: 'Messages',
                subtitle: 'Chat with your volunteer',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MessagesTab()),
                ),
              ),
              _QuickAction(
                icon: Icons.menu_book_outlined,
                title: 'Resources',
                subtitle: 'Helpful articles & tips',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ResourcesScreen()),
                ),
              ),
              _QuickAction(
                icon: Icons.person_outline,
                title: 'Profile',
                subtitle: 'Your account',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PatientProfileTab()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Upcoming',
              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.selectedCardFill,
                  child: Icon(Icons.chat_bubble_outline, color: AppColors.primaryNavy),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chat with your volunteer',
                          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                      Text('Today · 4:00 PM', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryNavy),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark)),
            Text(subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
