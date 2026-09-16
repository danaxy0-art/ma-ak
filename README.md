# Ma'ak — Flutter + Supabase

Screens included (matching the mockups):

- `lib/screens/login_screen.dart` — Welcome back / Log in
- `lib/screens/create_account_screen.dart` — Create your account
- `lib/screens/choose_role_screen.dart` — Choose your role (Help Seeker / Volunteer)
- `lib/screens/help_seeker_registration_screen.dart` — Help Seeker Registration
- `lib/screens/volunteer_registration_screen.dart` — Volunteer Registration (with file upload)
- `lib/screens/reset_password_screen.dart` — Reset your password
- `lib/screens/check_email_screen.dart` — Check your email
- `lib/widgets/logged_out_dialog.dart` — "You're logged out" modal

## Setup

0. This folder has the Dart source (`lib/`), `pubspec.yaml`, and the SQL
   schema, but not the native `android/`, `ios/`, `web/` platform folders
   (those need your local Flutter SDK to generate). After extracting the
   folder, run this once inside it to add them:
   ```bash
   flutter create .
   ```
   This will not overwrite your existing `lib/` or `pubspec.yaml`.
1. Create a Supabase project at supabase.com.
2. In the SQL editor, run `supabase_schema.sql` (creates tables, storage
   bucket, and Row Level Security policies).
3. In `lib/services/supabase_service.dart`, replace:
   ```dart
   url: 'https://YOUR_PROJECT_REF.supabase.co',
   anonKey: 'YOUR_SUPABASE_ANON_KEY',
   ```
   with your project's values (Project Settings → API).
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run:
   ```bash
   flutter run
   ```

## Using the "logged out" dialog

Call it wherever you sign the user out, e.g. from a profile/settings screen:

```dart
await SupabaseService.signOut();
if (context.mounted) {
  showLoggedOutDialog(
    context,
    onBackToLogin: () => Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    ),
  );
}
```

## Notes

- The logo is a placeholder `Icon` widget in `lib/widgets/maak_logo.dart` —
  swap in your real logo asset when you have it.
- Chronic condition / language lists live in
  `lib/screens/help_seeker_registration_screen.dart` as `kChronicConditions`
  and `kLanguages` — edit these to match your real taxonomy.
- Volunteer document uploads go to the `verification-documents` storage
  bucket, one folder per user id, so RLS can restrict access correctly.
