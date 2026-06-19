import 'package:boo_mondai/core/services/uuid.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show ChangeRecord, ChangeSource, ChangeType, ChangeTrackerStatus;

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
class ChangeTrackerEntry {
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
  final List<ChangeRecord> changes;

  /// Optional progress value from `0.0` to `1.0`.
  final double? progress;

  /// Human-readable error text when the plan fails.
  final String? errorMessage;

  /// Time when the entry was created.
  final DateTime startedAt;

  /// Time when the entry reached a terminal state.
  final DateTime? finishedAt;

  /// Whether the entry should still be treated as active by UI surfaces.
  bool get isActive =>
      status == ChangeTrackerStatus.previewing ||
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

  /// Returns a new entry with selected lifecycle fields changed.
  ChangeTrackerEntry copyWith({
    ChangeTrackerStatus? status,
    List<ChangeRecord>? changes,
    double? progress,
    String? errorMessage,
    bool clearErrorMessage = false,
    DateTime? finishedAt,
  }) {
    return ChangeTrackerEntry(
      id: id,
      source: source,
      title: title,
      status: status ?? this.status,
      changes: changes ?? this.changes,
      progress: progress ?? this.progress,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      startedAt: startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }
}
