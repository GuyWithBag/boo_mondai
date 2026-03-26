// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/user_profile.dart
// PURPOSE: User profile data model with Supabase + Hive serialization
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class UserProfile {
  final String id;
  final String email;
  final String displayName;
  final String role;
  final String? avatarUrl;
  final String? targetLanguage;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    this.avatarUrl,
    this.targetLanguage,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        email: json['email'] as String,
        displayName: json['display_name'] as String,
        role: json['role'] as String,
        avatarUrl: json['avatar_url'] as String?,
        targetLanguage: json['target_language'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'display_name': displayName,
        'role': role,
        'avatar_url': avatarUrl,
        'target_language': targetLanguage,
        'created_at': createdAt.toIso8601String(),
      };

  UserProfile copyWith({
    String? id,
    String? email,
    String? displayName,
    String? role,
    String? avatarUrl,
    String? targetLanguage,
    DateTime? createdAt,
  }) =>
      UserProfile(
        id: id ?? this.id,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        role: role ?? this.role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        targetLanguage: targetLanguage ?? this.targetLanguage,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          displayName == other.displayName &&
          role == other.role &&
          avatarUrl == other.avatarUrl &&
          targetLanguage == other.targetLanguage &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        email,
        displayName,
        role,
        avatarUrl,
        targetLanguage,
        createdAt,
      );

  @override
  String toString() =>
      'UserProfile(id: $id, email: $email, displayName: $displayName, role: $role)';
}
