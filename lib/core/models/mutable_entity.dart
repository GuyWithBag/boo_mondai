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
abstract class MutableEntity with MutableEntityMappable {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? purgeAfter;

  const MutableEntity({
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.purgeAfter,
  });
}
