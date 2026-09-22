import 'package:flutter/material.dart';
import 'backend/services/supabase_service.dart';
import 'frontend/theme/app_theme.dart';
import 'frontend/auth/login_screen.dart';
import 'frontend/auth/auth_gate.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
  runApp(const MaakApp());
}

class MaakApp extends StatelessWidget {
  const MaakApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = SupabaseService.currentUser != null;

    return MaterialApp(
      title: "Ma'ak",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: isLoggedIn ? const AuthGate() : const LoginScreen(),
    );
  }
}
