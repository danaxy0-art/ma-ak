import 'package:flutter/material.dart';
import 'services/supabase_service.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/auth_gate.dart';

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
