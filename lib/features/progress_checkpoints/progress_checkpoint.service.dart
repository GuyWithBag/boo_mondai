import 'package:boo_mondai/lib.barrel.dart'
    show
        LocalDB,
        ProgressCheckpoint,
        ProgressCheckpointLocalDB,
        ProgressCheckpointStatus,
        ProgressCheckpointType,
        Service,
        uuid;

class ProgressCheckpointService extends Service {
  ProgressCheckpointService({ProgressCheckpointLocalDB? checkpointDb})
    : _checkpointDb = checkpointDb ?? LocalDB.progressCheckpoint;

  @override
  String get name => 'ProgressCheckpointService';

  final ProgressCheckpointLocalDB _checkpointDb;

  ProgressCheckpoint start({
    String? id,
    required ProgressCheckpointType type,
    required String targetId,
    required String operationDescription,
    required int totalItems,
    Iterable<String> completedTargetItemIds = const [],
    bool preserveCompletedItems = true,
  }) {
    final now = DateTime.now();
    final existing = _checkpointDb.getByTypeAndTargetId(type, targetId);
    final completed = completedTargetItemIds.toSet();
    final checkpoint = ProgressCheckpoint(
      id: id ?? existing?.id ?? uuid.v7(),
      type: type,
      targetId: targetId,
      operationDescription: operationDescription,
      totalItems: totalItems,
      completedTargetItemIds: completed.isEmpty
          ? preserveCompletedItems
                ? existing?.completedTargetItemIds ?? const []
                : const []
          : completed.toList(),
      status: ProgressCheckpointStatus.started,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    _checkpointDb.upsert(checkpoint);
    return checkpoint;
  }

  ProgressCheckpoint? getById(String id) => _checkpointDb.getById(id);

  ProgressCheckpoint? getByTypeAndTargetId(
    ProgressCheckpointType type,
    String targetId,
  ) => _checkpointDb.getByTypeAndTargetId(type, targetId);

  List<ProgressCheckpoint> getActiveByType(ProgressCheckpointType type) =>
      _checkpointDb.getActiveByType(type);

  ProgressCheckpoint markItemsCompleted({
    required String checkpointId,
    required Iterable<String> itemIds,
  }) {
    final checkpoint = _required(checkpointId);
    final completed = checkpoint.completedTargetItemIds.toSet()
      ..addAll(itemIds);
    return _save(
      checkpoint.copyWith(
        completedTargetItemIds: completed.toList(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  ProgressCheckpoint pause(String checkpointId) =>
      _setStatus(checkpointId, ProgressCheckpointStatus.paused);

  ProgressCheckpoint complete(String checkpointId) =>
      _setStatus(checkpointId, ProgressCheckpointStatus.completed);

  ProgressCheckpoint fail(String checkpointId) =>
      _setStatus(checkpointId, ProgressCheckpointStatus.failed);

  ProgressCheckpoint cancel(String checkpointId) =>
      _setStatus(checkpointId, ProgressCheckpointStatus.cancelled);

  Future<void> delete(String checkpointId) =>
      _checkpointDb.deleteByPk({'id': checkpointId});

  ProgressCheckpoint _setStatus(
    String checkpointId,
    ProgressCheckpointStatus status,
  ) {
    final checkpoint = _required(checkpointId);
    return _save(
      checkpoint.copyWith(status: status, updatedAt: DateTime.now()),
    );
  }

  ProgressCheckpoint _required(String checkpointId) {
    final checkpoint = _checkpointDb.getById(checkpointId);
    if (checkpoint == null) {
      throw StateError('Progress checkpoint not found: $checkpointId');
    }
    return checkpoint;
  }

  ProgressCheckpoint _save(ProgressCheckpoint checkpoint) {
    _checkpointDb.upsert(checkpoint);
    return checkpoint;
  }
}
