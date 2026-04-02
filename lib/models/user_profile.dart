// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/user_profile.dart
// PURPOSE: User profile data model with Supabase + Hive serialization
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'user_profile.mapper.dart';

@MappableClass()
class UserProfile with UserProfileMappable {
  final String id;
  final String? userId;
  final String userName;
  final String role;
  final String? avatarUrl;
  final String? targetLanguage;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.userName,
    required this.role,
    this.avatarUrl,
    this.targetLanguage,
    required this.createdAt,
    this.userId,
  });
}
