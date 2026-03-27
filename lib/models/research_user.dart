// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/research_user.dart
// PURPOSE: Links a platform user to the research study with role assignment
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class ResearchUser {
  final String id;
  final String userId;
  final String? displayName;
  final String role;
  final String targetLanguage;
  final DateTime createdAt;

  const ResearchUser({
    required this.id,
    required this.userId,
    this.displayName,
    required this.role,
    required this.targetLanguage,
    required this.createdAt,
  });

  factory ResearchUser.fromJson(Map<String, dynamic> json) => ResearchUser(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        displayName: (json['profiles'] as Map<String, dynamic>?)?['display_name']
            as String?,
        role: json['role'] as String,
        targetLanguage: json['target_language'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'role': role,
        'target_language': targetLanguage,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResearchUser &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ResearchUser(userId: $userId, role: $role, lang: $targetLanguage)';
}
