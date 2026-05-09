// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/user_profile.dart
// PURPOSE: User profile data model with Supabase + Hive serialization
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'profile.dto.mapper.dart';

@MappableClass()
class Profile with ProfileMappable implements DTO {
  @override
  final String id;
  final String userId;
  final String username;
  final String? role;
  final String? avatarUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final bool isAnonymous;

  const Profile({
    required this.id,
    required this.username,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
    required this.userId,
    required this.updatedAt,
    this.isAnonymous = true,
  });
}
