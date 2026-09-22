import 'package:flutter/material.dart';

import '../../backend/services/supabase_service.dart';
import '../theme/app_theme.dart';
import 'volunteer_application_details.dart';

/// Shows every row from the `volunteer_profiles` table so the admin can
/// see who applied and open each one to approve/reject it.
class VolunteerApplicationsScreen extends StatefulWidget {
  const VolunteerApplicationsScreen({super.key});

  @override
  State<VolunteerApplicationsScreen> createState() => _VolunteerApplicationsScreenState();
}

class _VolunteerApplicationsScreenState extends State<VolunteerApplicationsScreen> {
  // A Future that resolves to the list of applications. Rebuilt whenever we
  // need fresh data (first load, pull-to-refresh, or coming back from the
  // details screen after approving/rejecting one).
  late Future<List<Map<String, dynamic>>> _applications;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  void _loadApplications() {
    _applications = SupabaseService.getVolunteerApplications();
  }

  Future<void> _refreshApplications() async {
    setState(() => _loadApplications());
    await _applications;
  }

  String _formatStatus(String? status) {
    switch (status) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'pending_review':
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Volunteer Applications')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _applications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load volunteer applications.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final applications = snapshot.data ?? [];

          if (applications.isEmpty) {
            return const Center(
              child: Text('No volunteer applications yet.',
                  style: TextStyle(color: AppColors.textMuted)),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshApplications,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: applications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final application = applications[index];
                final status = _formatStatus(application['status']?.toString());
                final condition =
                    application['condition_experience']?.toString() ?? 'Not specified';

                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                    title: Text(condition, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text('Status: $status'),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      // Wait for the details screen to close, then reload —
                      // the admin may have approved or rejected it there.
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              VolunteerApplicationDetailsScreen(application: application),
                        ),
                      );
                      if (mounted) setState(() => _loadApplications());
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
