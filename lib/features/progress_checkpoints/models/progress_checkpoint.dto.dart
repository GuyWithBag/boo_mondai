import 'package:dart_mappable/dart_mappable.dart';

part 'progress_checkpoint.dto.mapper.dart';

/// Durable resumable-work phases.
enum ProgressCheckpointType { deckDownloadFetch, syncFetch, syncApply }

/// Lifecycle state for a resumable progress checkpoint.
enum ProgressCheckpointStatus { started, paused, completed, failed, cancelled }

/// Durable progress record for a resumable operation.
///
/// A checkpoint tracks the job target plus the target item ids that have already
/// been completed. It intentionally stores ids rather than typed entities so it
/// can be reused by downloads, sync, and import workflows.
@MappableClass()
class ProgressCheckpoint with ProgressCheckpointMappable {
  const ProgressCheckpoint({
    required this.id,
    required this.type,
    required this.targetId,
    required this.operationDescription,
    required this.totalItems,
    required this.completedTargetItemIds,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Stable checkpoint/job id.
  final String id;

  /// Kind of resumable workflow this checkpoint belongs to.
  final ProgressCheckpointType type;

  /// Id of the main thing this job is acting on.
  final String targetId;

  /// User-readable description of the operation represented by this checkpoint.
  final String operationDescription;

  /// Number of target items expected to be completed.
  final int totalItems;

  /// Ids of target items already completed for this job.
  final List<String> completedTargetItemIds;

  /// Current durable progress state.
  final ProgressCheckpointStatus status;

  /// Time this checkpoint was first created.
  final DateTime createdAt;

  /// Time this checkpoint was last changed.
  final DateTime updatedAt;

  int get completedCount => completedTargetItemIds.length;

  bool get isComplete => completedCount >= totalItems && totalItems > 0;

  double get progress =>
      totalItems == 0 ? 0 : (completedCount / totalItems).clamp(0.0, 1.0);
}
