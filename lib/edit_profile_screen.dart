import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'help_seeker_registration_screen.dart' show kChronicConditions, kLanguages;
import 'supabase_service.dart';

class EditProfileScreen extends StatefulWidget {
  final String role;

  const EditProfileScreen({super.key, required this.role});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _experienceController = TextEditingController();
  final _otherConditionController = TextEditingController();

  String? _condition;
  String? _language;
  bool _loading = false;
  bool _isReady = false;

  bool get _isVolunteer => widget.role == 'volunteer';
  bool get _isOtherCondition => _condition == 'Other';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _experienceController.dispose();
    _otherConditionController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final data = await SupabaseService.loadProfileForEdit(role: widget.role);
    if (!mounted) return;

    final loadedCondition = data['condition'];
    final loadedLanguage = data['preferred_language'];
    final otherCondition = data['other_condition'];

    setState(() {
      _nameController.text = data['full_name'] ?? '';
      _condition = (loadedCondition != null &&
              kChronicConditions.any((item) => item == loadedCondition))
          ? loadedCondition
          : (loadedCondition == null ? null : 'Other');
      _language = loadedLanguage ?? kLanguages.first;
      _descriptionController.text = data['description'] ?? '';
      _experienceController.text = data['experience'] ?? '';
      _otherConditionController.text = otherCondition ??
          (_condition == 'Other' && loadedCondition != null ? loadedCondition : '');
      _isReady = true;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await SupabaseService.updateFullName(_nameController.text.trim());

      if (_isVolunteer) {
        await SupabaseService.updateVolunteerProfile(
          conditionExperience: _isOtherCondition
              ? _otherConditionController.text.trim()
              : (_condition ?? ''),
          preferredLanguage: _language ?? kLanguages.first,
          experienceDescription: _experienceController.text.trim(),
        );
      } else {
        await SupabaseService.updateHelpSeekerProfile(
          chronicCondition: _isOtherCondition
              ? _otherConditionController.text.trim()
              : (_condition ?? ''),
          preferredLanguage: _language ?? kLanguages.first,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
      Navigator.of(context).maybePop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _isReady;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit profile',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: isReady
            ? SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.selectedCardFill,
                        child: Icon(
                          Icons.person,
                          size: 36,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const _FieldLabel('Full name'),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Full name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'Required'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      if (!_isVolunteer) ...[
                        const _FieldLabel('Chronic condition'),
                        DropdownButtonFormField<String>(
                          value: _condition,
                          decoration: const InputDecoration(
                            hintText: 'Select your condition',
                          ),
                          items: kChronicConditions
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _condition = value),
                          validator: (value) => value == null ? 'Required' : null,
                        ),
                        if (_isOtherCondition) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _otherConditionController,
                            decoration: const InputDecoration(
                              hintText: 'Please specify your condition',
                            ),
                            validator: (value) =>
                                (_isOtherCondition &&
                                        (value == null || value.trim().isEmpty))
                                    ? 'Please specify your condition'
                                    : null,
                          ),
                        ],
                        const SizedBox(height: 16),
                        const _FieldLabel('Preferred language'),
                        DropdownButtonFormField<String>(
                          value: _language,
                          decoration: const InputDecoration(
                            hintText: 'Select language',
                          ),
                          items: kLanguages
                              .map((lang) => DropdownMenuItem(
                                    value: lang,
                                    child: Text(lang),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _language = value),
                          validator: (value) => value == null ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        const _FieldLabel('Short description (optional)'),
                        TextFormField(
                          controller: _descriptionController,
                          maxLength: 300,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText:
                                "Tell us a bit about your experience or what kind of support you're looking for...",
                          ),
                        ),
                      ] else ...[
                        const _FieldLabel('Condition experience'),
                        DropdownButtonFormField<String>(
                          value: _condition,
                          decoration: const InputDecoration(
                            hintText: 'Select condition',
                          ),
                          items: kChronicConditions
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _condition = value),
                          validator: (value) => value == null ? 'Required' : null,
                        ),
                        if (_isOtherCondition) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _otherConditionController,
                            decoration: const InputDecoration(
                              hintText: 'Please specify the condition',
                            ),
                            validator: (value) =>
                                (_isOtherCondition &&
                                        (value == null || value.trim().isEmpty))
                                    ? 'Please specify the condition'
                                    : null,
                          ),
                        ],
                        const SizedBox(height: 16),
                        const _FieldLabel('Preferred language'),
                        DropdownButtonFormField<String>(
                          value: _language,
                          decoration: const InputDecoration(
                            hintText: 'Select language',
                          ),
                          items: kLanguages
                              .map((lang) => DropdownMenuItem(
                                    value: lang,
                                    child: Text(lang),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _language = value),
                          validator: (value) => value == null ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        const _FieldLabel('Experience description'),
                        TextFormField(
                          controller: _experienceController,
                          maxLength: 300,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText:
                                'Tell us about your lived experience and how you can support others...',
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                        ),
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Save changes'),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
