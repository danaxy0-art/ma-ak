import 'package:flutter/material.dart';
import '../../backend/models/sample_data.dart';
import '../theme/app_theme.dart';
import 'request_details_screen.dart';
class AvailableRequestsScreen extends StatefulWidget {
  const AvailableRequestsScreen({super.key});

  @override
  State<AvailableRequestsScreen> createState() => _AvailableRequestsScreenState();
}

class _AvailableRequestsScreenState extends State<AvailableRequestsScreen> {
  String _filter = 'All';
  final _filters = const ['All', 'Mental Health', 'Chronic illness'];

  @override
  Widget build(BuildContext context) {
    final requests = kSampleRequests.where((r) {
      if (_filter == 'All') return true;
      if (_filter == 'Mental Health') return r.category == 'Mental health';
      return r.category != 'Mental health';
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Available Requests',
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700, fontSize: 18)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _filters
                    .map((f) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(f),
                            selected: _filter == f,
                            onSelected: (_) => setState(() => _filter = f),
                            selectedColor: AppColors.selectedCardFill,
                            labelStyle: TextStyle(
                              color: _filter == f ? AppColors.primaryNavy : AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: AppColors.fieldBorder),
                            ),
                            backgroundColor: AppColors.fieldFill,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final r = requests[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => RequestDetailsScreen(request: r)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.fieldFill,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.fieldBorder),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.selectedCardFill,
                          child: Icon(Icons.person, color: AppColors.primaryNavy),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700, color: AppColors.textDark)),
                              Text('${r.gender} · ${r.age} years',
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                              Text('${r.distanceKm.toStringAsFixed(0)} km · ${r.hoursPerWeek}',
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
