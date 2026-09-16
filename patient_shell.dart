import 'package:flutter/material.dart';
import '../../widgets/maak_bottom_nav.dart';
import '../shared/messages_tab.dart';
import 'journey_tab.dart';
import 'patient_home_tab.dart';
import 'patient_profile_tab.dart';

/// Root screen shown after a Help Seeker successfully registers/logs in.
/// Hosts the four bottom-nav tabs: Home, Journey, Messages, Profile.
class PatientShell extends StatefulWidget {
  const PatientShell({super.key});

  @override
  State<PatientShell> createState() => _PatientShellState();
}

class _PatientShellState extends State<PatientShell> {
  int _index = 0;

  static const _tabs = [
    PatientHomeTab(),
    JourneyTab(),
    MessagesTab(),
    PatientProfileTab(),
  ];

  static const _items = [
    MaakNavItem(icon: Icons.home_outlined, label: 'Home'),
    MaakNavItem(icon: Icons.timeline_outlined, label: 'Journey'),
    MaakNavItem(icon: Icons.chat_bubble_outline, label: 'Messages'),
    MaakNavItem(icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: MaakBottomNav(
        currentIndex: _index,
        items: _items,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
