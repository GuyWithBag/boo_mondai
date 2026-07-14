import 'package:boo_mondai/features/change_tracker/models/change_source.dart';
import 'package:boo_mondai/features/change_tracker/models/change_type.dart';
import 'package:boo_mondai/features/change_tracker/models/changed_property.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'changed_entity.mapper.dart';

/// A single human-readable record of one entity-level change within a
/// [PreviewedChangePlan] or a completed [ChangeTrackerEntry].
///
/// Each record describes what happened to one entity (a deck, a card template,
/// etc.) and optionally holds [ChangedProperty] entries for field-level detail.
/// Records are display-oriented, not persistence models; snapshots are kept as
/// [Object] values and [toJson] is intended for diagnostics.
@MappableClass()
class ChangedEntity<T> with ChangedEntityMappable<T> {
  /// Creates a record for one entity-level operation.
  const ChangedEntity({
    required this.source,
    required this.changeType,
    required this.id,
    this.beforeChange,
    required this.afterChange,
    this.changedProperties = const [],
    this.localId,
    this.remoteId,
    this.localUpdatedAt,
    this.remoteUpdatedAt,
  });

  /// Operation type: added, modified, removed, or skipped.
  final ChangeType changeType;

  /// Workflow that produced the change.
  final ChangeSource source;

  /// Storage or domain entity name, such as `deck` or `card_template`.
  String get typeName =>
      (afterChange ?? beforeChange)?.runtimeType.toString() ?? 'unknown';

  /// Identifier of the affected entity in the source workflow.
  final String id;

  /// Entity snapshot before the change.
  ///
  /// Usually present for modified or removed records.
  final T? beforeChange;

  /// Entity snapshot after the change.
  ///
  /// Usually present for added or modified records.
  final T afterChange;

  /// Property-level diffs for modified entities.
  final List<ChangedProperty<Object?>> changedProperties;

  /// Local identifier when the change compares local and remote records.
  final String? localId;

  /// Remote identifier when the change compares local and remote records.
  final String? remoteId;

  /// Local record timestamp used for conflict/change explanations.
  final DateTime? localUpdatedAt;

  /// Remote record timestamp used for conflict/change explanations.
  final DateTime? remoteUpdatedAt;
}
