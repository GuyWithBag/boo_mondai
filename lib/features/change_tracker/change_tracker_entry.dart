import 'package:boo_mondai/core/services/uuid.dart';
import 'package:boo_mondai/features/change_tracker/models/changed_entity.dart';
import 'package:boo_mondai/features/change_tracker/models/change_source.dart';
import 'package:boo_mondai/features/change_tracker/models/change_tracker_status.dart';
import 'package:boo_mondai/features/change_tracker/models/change_type.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'change_tracker_entry.mapper.dart';

/// The runtime state of one tracked change operation managed by
/// [ChangeTrackerController].
///
/// An entry is created by [ChangeTrackerController.start] and mutated
/// via [ChangeTrackerController.update], [ChangeTrackerController.complete],
/// [ChangeTrackerController.fail], [ChangeTrackerController.pause], and
/// [ChangeTrackerController.cancel]. It is immutable between mutations;
/// all state transitions produce a new instance via [copyWith].
///
/// Entries are identified by [id] and may be looked up via
/// [ChangeTrackerController.entryById].
@MappableClass()
class ChangeTrackerEntry<T> with ChangeTrackerEntryMappable<T> {
  /// Creates a tracked entry, generating an id and start time when omitted.
  ChangeTrackerEntry({
    String? id,
    required this.source,
    required this.title,
    this.status = ChangeTrackerStatus.idle,
    this.changes = const [],
    this.progress,
    this.errorMessage,
    DateTime? startedAt,
    this.finishedAt,
  }) : id = id ?? uuid.v7(),
       startedAt = startedAt ?? DateTime.now();

  /// Stable entry id used for routing, lookup, and apply callbacks.
  final String id;

  /// Workflow that owns this entry.
  final ChangeSource source;

  /// User-facing title shown on review screens.
  final String title;

  /// Current lifecycle state of the entry.
  final ChangeTrackerStatus status;

  /// Changes shown to the user before or after applying.
  final List<ChangedEntity<T>> changes;

  /// Optional progress value from `0.0` to `1.0`.
  ///
  /// A null value means progress is indeterminate. Callers should clamp values
  /// before passing them in; the entry preserves the value it receives.
  final double? progress;

  /// Human-readable error text when the plan fails.
  final String? errorMessage;

  /// Time when the entry was created.
  final DateTime startedAt;

  /// Time when the entry reached a terminal state.
  final DateTime? finishedAt;

  /// Whether the entry should still be treated as active by UI surfaces.
  ///
  /// Active entries represent work that may still change state or need user
  /// attention. Terminal entries can be removed with
  /// [ChangeTrackerController.clearFinished].
  bool get isActive =>
      status == ChangeTrackerStatus.planning ||
      status == ChangeTrackerStatus.fetching ||
      status == ChangeTrackerStatus.reviewing ||
      status == ChangeTrackerStatus.applying ||
      status == ChangeTrackerStatus.paused;

  /// Number of added changes in [changes].
  int get addedCount => _count(ChangeType.added);

  /// Number of modified changes in [changes].
  int get modifiedCount => _count(ChangeType.modified);

  /// Number of removed changes in [changes].
  int get removedCount => _count(ChangeType.removed);

  int _count(ChangeType type) =>
      changes.where((change) => change.type == type).length;
}
