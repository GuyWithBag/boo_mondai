import 'package:boo_mondai/core/services/uuid.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show ChangeLog, ChangeReviewStatus, ChangeSource, ChangeType;

class ChangeReviewPlan {
  ChangeReviewPlan({
    String? id,
    required this.source,
    required this.title,
    this.status = ChangeReviewStatus.idle,
    this.changes = const [],
    this.progress,
    this.errorMessage,
    DateTime? startedAt,
    this.finishedAt,
  }) : id = id ?? uuid.v7(),
       startedAt = startedAt ?? DateTime.now();

  final String id;
  final ChangeSource source;
  final String title;
  final ChangeReviewStatus status;
  final List<ChangeLog> changes;
  final double? progress;
  final String? errorMessage;
  final DateTime startedAt;
  final DateTime? finishedAt;

  bool get isActive =>
      status == ChangeReviewStatus.previewing ||
      status == ChangeReviewStatus.reviewing ||
      status == ChangeReviewStatus.applying;

  int get addedCount => _count(ChangeType.added);
  int get modifiedCount => _count(ChangeType.modified);
  int get removedCount => _count(ChangeType.removed);

  int _count(ChangeType type) =>
      changes.where((change) => change.type == type).length;

  ChangeReviewPlan copyWith({
    ChangeReviewStatus? status,
    List<ChangeLog>? changes,
    double? progress,
    String? errorMessage,
    bool clearErrorMessage = false,
    DateTime? finishedAt,
  }) {
    return ChangeReviewPlan(
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
