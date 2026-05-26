// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dto.dart
// PURPOSE: Base classes for syncable models
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Mutable model — synced via SyncService using updatedAt for conflict resolution.
abstract class DTO {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DTO({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
}

/// Immutable model — written once, never modified. Synced by existence check only.
abstract class WriteOnceDTO {
  final String id;
  final DateTime createdAt;

  const WriteOnceDTO({required this.id, required this.createdAt});
}
