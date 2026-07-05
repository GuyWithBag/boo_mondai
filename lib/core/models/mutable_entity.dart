// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dto.dart
// PURPOSE: Base classes for syncable models
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'mutable_entity.mapper.dart';

/// Mutable model — synced via SyncService using updatedAt for conflict resolution.
@MappableClass()
abstract class MutableEntity {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MutableEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
}
