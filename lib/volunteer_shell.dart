import 'package:flutter/material.dart';
import 'maak_bottom_nav.dart';
import 'messages_tab.dart';
import 'schedule_tab.dart';
import 'volunteer_home_tab.dart';
import 'volunteer_profile_tab.dart';

/// Root screen shown after a Volunteer successfully registers/logs in.
/// Hosts the four bottom-nav tabs: Home, Schedule, Chat, Profile.
class VolunteerShell extends StatefulWidget {
  const VolunteerShell({super.key});

  @override
  State<VolunteerShell> createState() => _VolunteerShellState();
}

class _VolunteerShellState extends State<VolunteerShell> {
  int _index = 0;

  static const _tabs = [
    VolunteerHomeTab(),
    ScheduleTab(),
    MessagesTab(),
    VolunteerProfileTab(),
  ];

  static const _items = [
    MaakNavItem(icon: Icons.home_outlined, label: 'Home'),
    MaakNavItem(icon: Icons.calendar_today_outlined, label: 'Schedule'),
    MaakNavItem(icon: Icons.chat_bubble_outline, label: 'Chat'),
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
