import 'package:dart_mappable/dart_mappable.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/user_profile.dart
// PURPOSE: User profile data model with Supabase + Hive serialization
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

part 'cached_profile.mapper.dart';

@MappableClass()
class CachedProfile with CachedProfileMappable {
  final String id;
  final String userName;
  final String? avatarUrl;
  final DateTime createdAt;

  const CachedProfile({
    required this.id,
    required this.userName,
    this.avatarUrl,
    required this.createdAt,
  });
}
