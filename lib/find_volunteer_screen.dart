import 'package:flutter/material.dart';
import 'sample_data.dart';
import 'app_theme.dart';
import 'volunteer_profile_view_screen.dart';

class FindVolunteerScreen extends StatefulWidget {
  const FindVolunteerScreen({super.key});

  @override
  State<FindVolunteerScreen> createState() => _FindVolunteerScreenState();
}

class _FindVolunteerScreenState extends State<FindVolunteerScreen> {
  String _filter = 'All';
  final _filters = const ['All', 'Mental Health', 'Chronic illness'];

  @override
  Widget build(BuildContext context) {
    final volunteers = kSampleVolunteers.where((v) {
      if (_filter == 'All') return true;
      if (_filter == 'Mental Health') return v.specialty == 'Mental Health';
      return v.specialty != 'Mental Health';
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Find a Volunteer',
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700, fontSize: 18)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Choose someone who fits your needs and interests.',
                    style: TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by name, specialty or language',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
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
                                  color: _filter == f
                                      ? AppColors.primaryNavy
                                      : AppColors.textMuted,
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
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: volunteers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final v = volunteers[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => VolunteerProfileViewScreen(volunteer: v)),
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
                          radius: 24,
                          backgroundColor: AppColors.selectedCardFill,
                          child: Icon(Icons.person, color: AppColors.primaryNavy),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(v.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700, color: AppColors.textDark)),
                              Text('${v.specialty} · ${v.experience}',
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 14, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text('${v.rating} (${v.reviewCount})',
                                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => VolunteerProfileViewScreen(volunteer: v)),
                          ),
                          child: const Text('View'),
                        ),
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
