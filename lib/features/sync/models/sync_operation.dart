import 'package:boo_mondai/lib.barrel.dart'
    show SyncOperationStatus, SyncOperationType, SyncChangeLog, uuid;

class SyncOperationProgress {
  const SyncOperationProgress({
    required this.completed,
    required this.total,
    required this.label,
  });

  const SyncOperationProgress.indeterminate({this.label = ''})
    : completed = 0,
      total = 0;

  final int completed;
  final int total;
  final String label;

  bool get isIndeterminate => total <= 0;

  double? get fraction => isIndeterminate ? null : completed / total;
}

class SyncOperation {
  SyncOperation({
    String? id,
    required this.kind,
    required this.subjectId,
    required this.subjectTitle,
    this.status = SyncOperationStatus.queued,
    this.progress = const SyncOperationProgress.indeterminate(),
    this.changes = const [],
    this.errorMessage,
    DateTime? startedAt,
    this.finishedAt,
  }) : id = id ?? uuid.v7(),
       startedAt = startedAt ?? DateTime.now();

  final String id;
  final SyncOperationType kind;
  final String subjectId;
  final String subjectTitle;
  final SyncOperationStatus status;
  final SyncOperationProgress progress;
  final List<SyncChangeLog> changes;
  final String? errorMessage;
  final DateTime startedAt;
  final DateTime? finishedAt;

  bool get isActive =>
      status == SyncOperationStatus.queued ||
      status == SyncOperationStatus.running;

  SyncOperation copyWith({
    SyncOperationStatus? status,
    SyncOperationProgress? progress,
    List<SyncChangeLog>? changes,
    String? errorMessage,
    bool clearErrorMessage = false,
    DateTime? finishedAt,
  }) {
    return SyncOperation(
      id: id,
      kind: kind,
      subjectId: subjectId,
      subjectTitle: subjectTitle,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      changes: changes ?? this.changes,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      startedAt: startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }
}
