import 'package:boo_mondai/models/models.dart';
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/helpers/fake_user_profile.dart
// PURPOSE: Provides fake UserProfile instances for unit and widget tests
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

UserProfile fakeUserProfile({String? id, String? role}) => UserProfile(
      id: id ?? '00000000-0000-0000-0000-000000000002',
      email: 'alice@test.com',
      displayName: 'Alice',
      role: role ?? 'group_a_participant',
      avatarUrl: null,
      targetLanguage: 'japanese',
      createdAt: DateTime(2026, 1, 1),
    );
