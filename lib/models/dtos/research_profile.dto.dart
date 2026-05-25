// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/research_user.dart
// PURPOSE: Links a platform user to the research study with role assignment
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'research_profile.dto.mapper.dart';

@MappableClass()
class ResearchProfile with ResearchProfileMappable {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final int age;
  final String role;
  final String goal;
  final DateTime createdAt;
  final CachedProfile? userProfile;

  const ResearchProfile({
    required this.id,
    required this.userId,
    required this.role,
    required this.goal,
    required this.createdAt,
    required this.firstName,
    required this.lastName,
    required this.age,
    this.userProfile,
  });
}
