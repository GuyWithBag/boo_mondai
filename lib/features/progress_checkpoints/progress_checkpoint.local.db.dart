import 'package:boo_mondai/features/progress_checkpoints/models/progress_checkpoint.dto.dart';
import 'package:boo_mondai/lib.barrel.dart' show HiveLocalDB;

class ProgressCheckpointLocalDB extends HiveLocalDB<ProgressCheckpoint> {
  @override
  String get boxName => 'progress_checkpoints';

  @override
  Map<String, Object?> primaryKeyFromItem(ProgressCheckpoint item) => {
    'id': item.id,
  };

  ProgressCheckpoint? getById(String id) => selectByPk({'id': id});

  ProgressCheckpoint? getByTypeAndTargetId(
    ProgressCheckpointType type,
    String targetId,
  ) {
    final matches = selectMany(
      where: (checkpoint) =>
          checkpoint.type == type && checkpoint.targetId == targetId,
      limit: 1,
    );
    return matches.isEmpty ? null : matches.first;
  }

  List<ProgressCheckpoint> getByStatus(ProgressCheckpointStatus status) =>
      selectMany(where: (checkpoint) => checkpoint.status == status);

  List<ProgressCheckpoint> getActiveByType(ProgressCheckpointType type) =>
      selectMany(
        where: (checkpoint) =>
            checkpoint.type == type &&
            !checkpoint.isComplete &&
            (checkpoint.status == ProgressCheckpointStatus.started ||
                checkpoint.status == ProgressCheckpointStatus.paused),
      );
}
