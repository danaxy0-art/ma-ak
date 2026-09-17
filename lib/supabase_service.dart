import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper around the Supabase client used across the app.
/// Call [SupabaseService.init] once in main() before runApp().
class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://sldjrjmlvboqqnzpsxsy.supabase.co',
      anonKey: 'sb_publishable_goilsZcRhU8rzLowAmIbaQ_iSFm1ZPS',
    );
  }

  // ---------------- Auth ----------------

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  static Future<AuthResponse> signUp({
    required String fullName,
    required String email,
    required String password,
  }) {
    return client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  static Future<void> sendPasswordReset(String email) {
    return client.auth.resetPasswordForEmail(email);
  }

  static Future<void> signOut() {
    return client.auth.signOut();
  }

  static Future<void> updateFullName(String fullName) async {
    final userId = currentUser!.id;
    await client.from('profiles').upsert({
      'id': userId,
      'full_name': fullName,
    });
  }

  static User? get currentUser => client.auth.currentUser;

  // ---------------- Profiles / role ----------------

  /// Saves the chosen role ('help_seeker' or 'volunteer') on the profiles row.
  static Future<void> setRole(String role) async {
    final userId = currentUser!.id;
    await client.from('profiles').upsert({
      'id': userId,
      'role': role,
    });
  }

  /// Reads back the current user's role ('help_seeker' or 'volunteer'),
  /// or null if no profile row / role has been set yet.
  static Future<String?> getMyRole() async {
    final userId = currentUser?.id;
    if (userId == null) return null;
    final row = await client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .maybeSingle();
    return row?['role'] as String?;
  }

  static Future<Map<String, dynamic>> loadProfileForEdit({
    required String role,
  }) async {
    final userId = currentUser?.id;
    if (userId == null) return {};

    final profileRow = await client
        .from('profiles')
        .select('full_name')
        .eq('id', userId)
        .maybeSingle();

    Map<String, dynamic> data = {
      'full_name': profileRow?['full_name'] as String?,
    };

    if (role == 'help_seeker') {
      final row = await client
          .from('help_seeker_profiles')
          .select('chronic_condition, preferred_language, description')
          .eq('user_id', userId)
          .maybeSingle();
      data = {
        ...data,
        'condition': row?['chronic_condition'] as String?,
        'preferred_language': row?['preferred_language'] as String?,
        'description': row?['description'] as String?,
      };
    } else {
      final row = await client
          .from('volunteer_profiles')
          .select('condition_experience, preferred_language, experience_description')
          .eq('user_id', userId)
          .maybeSingle();
      data = {
        ...data,
        'condition': row?['condition_experience'] as String?,
        'preferred_language': row?['preferred_language'] as String?,
        'experience': row?['experience_description'] as String?,
      };
    }

    return data;
  }

  /// Completes the Help Seeker registration form.
  static Future<void> submitHelpSeekerRegistration({
    required String chronicCondition,
    required String preferredLanguage,
    String? description,
  }) async {
    final userId = currentUser!.id;
    await client.from('help_seeker_profiles').upsert({
      'user_id': userId,
      'chronic_condition': chronicCondition,
      'preferred_language': preferredLanguage,
      'description': description,
    });
  }

  static Future<void> updateHelpSeekerProfile({
    required String chronicCondition,
    required String preferredLanguage,
    String? description,
  }) async {
    final userId = currentUser!.id;
    await client.from('help_seeker_profiles').upsert({
      'user_id': userId,
      'chronic_condition': chronicCondition,
      'preferred_language': preferredLanguage,
      'description': description,
    });
  }

  static Future<void> updateVolunteerProfile({
    required String conditionExperience,
    required String preferredLanguage,
    required String experienceDescription,
  }) async {
    final userId = currentUser!.id;
    await client.from('volunteer_profiles').upsert({
      'user_id': userId,
      'condition_experience': conditionExperience,
      'preferred_language': preferredLanguage,
      'experience_description': experienceDescription,
    });
  }

  /// Uploads a verification document (as raw bytes, which works on every
  /// platform including web) and returns its public URL.
  static Future<String> uploadVerificationDocument({
    required List<int> fileBytes,
    required String fileName,
  }) async {
    final userId = currentUser!.id;
    final path =
        '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    await client.storage.from('verification-documents').uploadBinary(
          path,
          Uint8List.fromList(fileBytes),
        );
    return client.storage.from('verification-documents').getPublicUrl(path);
  }

  /// Completes the Volunteer registration form. Pass [verificationDocumentUrl]
  /// from [uploadVerificationDocument] if the user attached a file.
  static Future<void> submitVolunteerRegistration({
    required String conditionExperience,
    required String preferredLanguage,
    required String experienceDescription,
    String? verificationDocumentUrl,
  }) async {
    final userId = currentUser!.id;
    await client.from('volunteer_profiles').upsert({
      'user_id': userId,
      'condition_experience': conditionExperience,
      'preferred_language': preferredLanguage,
      'experience_description': experienceDescription,
      'verification_document_url': verificationDocumentUrl,
      'status': 'pending_review',
    });
  }
}
