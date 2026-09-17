import 'package:flutter/material.dart';
import 'supabase_service.dart';
import 'app_theme.dart';
import 'edit_profile_screen.dart';
import 'logged_out_dialog.dart';
import 'login_screen.dart';
import 'settings_screen.dart';

class VolunteerProfileTab extends StatelessWidget {
  const VolunteerProfileTab({super.key});

  Future<void> _logout(BuildContext context) async {
    await SupabaseService.signOut();
    if (!context.mounted) return;
    showLoggedOutDialog(
      context,
      onBackToLogin: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = SupabaseService.currentUser?.email ?? '';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile',
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          const CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.selectedCardFill,
            child: Icon(Icons.person, size: 36, color: AppColors.primaryNavy),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(email,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.edit_outlined, color: AppColors.primaryNavy),
            title: const Text('Edit profile', style: TextStyle(color: AppColors.textDark)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const EditProfileScreen(role: 'volunteer'),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined, color: AppColors.primaryNavy),
            title: const Text('My availability', style: TextStyle(color: AppColors.textDark)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events_outlined, color: AppColors.primaryNavy),
            title: const Text('Your impact', style: TextStyle(color: AppColors.textDark)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: AppColors.primaryNavy),
            title: const Text('Settings', style: TextStyle(color: AppColors.textDark)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: AppColors.primaryNavy),
            title: const Text('Help & support', style: TextStyle(color: AppColors.textDark)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log out', style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
