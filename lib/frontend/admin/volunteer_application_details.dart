import 'package:flutter/material.dart';

import '../../backend/services/supabase_service.dart';

/// Full detail view of one volunteer application, with Approve/Reject
/// buttons that only show while the application is still pending.
class VolunteerApplicationDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> application;

  const VolunteerApplicationDetailsScreen({super.key, required this.application});

  @override
  State<VolunteerApplicationDetailsScreen> createState() =>
      _VolunteerApplicationDetailsScreenState();
}

class _VolunteerApplicationDetailsScreenState
    extends State<VolunteerApplicationDetailsScreen> {
  bool _loading = false;

  String get _status => widget.application['status']?.toString() ?? 'pending_review';
  bool get _isPending => _status == 'pending_review';

  Future<void> _approveApplication() async {
    final userId = widget.application['user_id']?.toString();
    if (userId == null) return;

    setState(() => _loading = true);
    try {
      await SupabaseService.approveVolunteerApplication(userId);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Volunteer application approved.')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not approve application: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Shows a small dialog asking the admin to type a reason, then rejects
  // the application with that reason (does nothing if they cancel).
  Future<void> _showRejectDialog() async {
    final reasonController = TextEditingController();

    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reject Application'),
          content: TextField(
            controller: reasonController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Reason for rejection',
              hintText: 'Enter the reason for rejecting this application',
              alignLabelWithHint: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final reason = reasonController.text.trim();
                if (reason.isEmpty) return;
                Navigator.pop(dialogContext, reason);
              },
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );

    reasonController.dispose();
    if (reason == null || reason.isEmpty) return;
    await _rejectApplication(reason);
  }

  Future<void> _rejectApplication(String reason) async {
    final userId = widget.application['user_id']?.toString();
    if (userId == null) return;

    setState(() => _loading = true);
    try {
      await SupabaseService.rejectVolunteerApplication(userId: userId, reason: reason);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Volunteer application rejected.')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not reject application: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final application = widget.application;
    final condition = application['condition_experience']?.toString() ?? 'Not specified';
    final language = application['preferred_language']?.toString() ?? 'Not specified';
    final experience = application['experience_description']?.toString() ?? 'Not provided';
    final documentUrl = application['verification_document_url']?.toString();
    final rejectionReason = application['rejection_reason']?.toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Application Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DetailItem(title: 'Condition Experience', value: condition),
              _DetailItem(title: 'Preferred Language', value: language),
              _DetailItem(title: 'Experience Description', value: experience),
              _DetailItem(
                title: 'Verification Document',
                value: documentUrl == null || documentUrl.isEmpty
                    ? 'No document uploaded'
                    : documentUrl,
              ),
              _DetailItem(title: 'Application Status', value: _formatStatus(_status)),
              if (_status == 'rejected' && rejectionReason != null && rejectionReason.isNotEmpty)
                _DetailItem(title: 'Rejection Reason', value: rejectionReason),
              const SizedBox(height: 24),
              if (_isPending)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _loading ? null : _showRejectDialog,
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _loading ? null : _approveApplication,
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Approve'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A simple "label above value" row, reused for every field on this screen.
class _DetailItem extends StatelessWidget {
  final String title;
  final String value;

  const _DetailItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
