import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'choose_role_screen.dart';
import 'patient/patient_shell.dart';
import 'volunteer/volunteer_shell.dart';

/// Shown at app start when a session already exists (the user closed the
/// app without logging out). Looks up their saved role and routes them
/// straight to the matching shell instead of making them log in again.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SupabaseService.getMyRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        switch (snapshot.data) {
          case 'help_seeker':
            return const PatientShell();
          case 'volunteer':
            return const VolunteerShell();
          default:
            return const ChooseRoleScreen();
        }
      },
    );
  }
}
