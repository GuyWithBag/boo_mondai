// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/user_profile.dart
// PURPOSE: User profile data model with Supabase + Hive serialization
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show MutableEntity, MutableEntityCopyWith, MutableEntityMapper;
import 'package:dart_mappable/dart_mappable.dart';

part 'profile.dto.mapper.dart';

@MappableClass()
class Profile with ProfileMappable implements MutableEntity {
  final String id;
  final String userId;
  final String username;
  final String displayName;
  final String? role;
  final String? avatarUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  final DateTime? purgeAfter;
  final bool isAnonymous;

  const Profile({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
    required this.userId,
    required this.updatedAt,
    this.deletedAt,
    this.purgeAfter,
    this.isAnonymous = true,
  });
}
