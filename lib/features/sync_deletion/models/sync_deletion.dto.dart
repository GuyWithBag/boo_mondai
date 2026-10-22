import 'package:boo_mondai/lib.barrel.dart' show uuid;
import 'package:dart_mappable/dart_mappable.dart';

part 'sync_deletion.dto.mapper.dart';

@MappableClass()
class SyncDeletion with SyncDeletionMappable {
  final String id;
  final String entityType;
  final String entityId;
  final String? scopeType;
  final String? scopeId;
  final String profileId;
  final DateTime deletedAt;
  final DateTime createdAt;

  const SyncDeletion({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.profileId,
    required this.deletedAt,
    required this.createdAt,
    this.scopeType,
    this.scopeId,
  });

  factory SyncDeletion.createNow({
    required String entityType,
    required String entityId,
    required String profileId,
    String? scopeType,
    String? scopeId,
    DateTime? deletedAt,
  }) {
    final now = deletedAt ?? DateTime.now();
    return SyncDeletion(
      id: idFor(entityType: entityType, entityId: entityId),
      entityType: entityType,
      entityId: entityId,
      scopeType: scopeType,
      scopeId: scopeId,
      profileId: profileId,
      deletedAt: now,
      createdAt: now,
    );
  }

  static String idFor({required String entityType, required String entityId}) {
    return '$entityType:$entityId';
  }

  static String compositeEntityId(Map<String, Object?> values) {
    final keys = values.keys.toList()..sort();
    return keys.map((key) => '$key=${values[key]}').join(';');
  }

  static String newEntityId() => uuid.v7();
}
