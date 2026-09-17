import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'maak_logo.dart';
import 'help_seeker_registration_screen.dart';
import 'volunteer_registration_screen.dart';

enum MaakRole { helpSeeker, volunteer }

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  // Tapping a role card navigates straight to that role's registration
  // screen — no separate "Continue" step. The account itself (name/email/
  // password) and the chosen role are only created once the user finishes
  // the registration form on the next screen.
  void _selectRole(BuildContext context, MaakRole role) {
    if (role == MaakRole.helpSeeker) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const HelpSeekerRegistrationScreen()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const VolunteerRegistrationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const MaakLogo(),
              const SizedBox(height: 24),
              const Text(
                'Choose your role',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Select how you would like to use Ma'ak",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              _RoleCard(
                icon: Icons.person_outline,
                title: 'Help Seeker',
                description:
                    "I am living with a chronic condition and I'm looking for peer support.",
                onTap: () => _selectRole(context, MaakRole.helpSeeker),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.groups_outlined,
                title: 'Volunteer',
                description:
                    'I have lived experience with a chronic condition and I want to support others.',
                onTap: () => _selectRole(context, MaakRole.volunteer),
              ),
              const SizedBox(height: 16),
              const Text(
                'You can change this later in your profile.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: AppColors.primaryNavy),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
