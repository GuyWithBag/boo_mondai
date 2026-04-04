// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/research_code.dart
// PURPOSE: Research code model — unlocks specific study flows
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'research_code.mapper.dart';

@MappableClass()
class ResearchCode with ResearchCodeMappable {
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
}
