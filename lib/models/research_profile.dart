// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/research_user.dart
// PURPOSE: Links a platform user to the research study with role assignment
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'research_profile.mapper.dart';

@MappableClass()
class ResearchProfile with ResearchProfileMappable {
  final String id;
  final String userId;
  final String? userName;
  final String firstName;
  final String lastName;
  final int age;
  final String role;
  final String targetLanguage;
  final DateTime createdAt;

  const ResearchProfile({
    required this.id,
    required this.userId,
    this.userName,
    required this.role,
    required this.targetLanguage,
    required this.createdAt,
    required this.firstName,
    required this.lastName,
    required this.age,
  });
}
