// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/research_code.dart
// PURPOSE: Research code model — unlocks specific study flows
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class ResearchCode {
  final String id;
  final String code;
  final String targetRole;
  final String unlocks;
  final String createdBy;
  final String? usedBy;
  final DateTime? usedAt;
  final DateTime createdAt;

  const ResearchCode({
    required this.id,
    required this.code,
    required this.targetRole,
    required this.unlocks,
    required this.createdBy,
    this.usedBy,
    this.usedAt,
    required this.createdAt,
  });

  bool get isUsed => usedBy != null;

  factory ResearchCode.fromJson(Map<String, dynamic> json) => ResearchCode(
        id: json['id'] as String,
        code: json['code'] as String,
        targetRole: json['target_role'] as String,
        unlocks: json['unlocks'] as String,
        createdBy: json['created_by'] as String,
        usedBy: json['used_by'] as String?,
        usedAt: json['used_at'] != null
            ? DateTime.parse(json['used_at'] as String)
            : null,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'target_role': targetRole,
        'unlocks': unlocks,
        'created_by': createdBy,
        'used_by': usedBy,
        'used_at': usedAt?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResearchCode &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ResearchCode(code: $code, unlocks: $unlocks, isUsed: $isUsed)';
}
