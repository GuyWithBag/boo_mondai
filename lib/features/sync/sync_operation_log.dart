import 'package:boo_mondai/lib.barrel.dart'
    show
        SyncOperation,
        SyncOperationType,
        SyncOperationProgress,
        SyncChangeLog,
        SyncOperationStatus;
import 'package:flutter/material.dart' show ChangeNotifier;

/// In-memory operation history for download and sync UI.
///
/// Keeping this out of Hive for now lets the workflow stabilize before the app
/// commits to a persisted activity-log schema.
class SyncOperationLog extends ChangeNotifier {
  SyncOperationLog._();

  static final SyncOperationLog instance = SyncOperationLog._();

  final List<SyncOperation> _operations = [];

  List<SyncOperation> get operations => List.unmodifiable(_operations);

  List<SyncOperation> get activeOperations =>
      _operations.where((operation) => operation.isActive).toList();

  List<SyncOperation> operationsForSubject(String subjectId) => _operations
      .where((operation) => operation.subjectId == subjectId)
      .toList(growable: false);

  SyncOperation start({
    required SyncOperationType kind,
    required String subjectId,
    required String subjectTitle,
    SyncOperationProgress progress =
        const SyncOperationProgress.indeterminate(),
  }) {
    final operation = SyncOperation(
      kind: kind,
      subjectId: subjectId,
      subjectTitle: subjectTitle,
      status: SyncOperationStatus.running,
      progress: progress,
    );
    _operations.insert(0, operation);
    notifyListeners();
    return operation;
  }

  void update(
    String operationId, {
    SyncOperationProgress? progress,
    List<SyncChangeLog>? changes,
  }) {
    _replace(
      operationId,
      (operation) => operation.copyWith(progress: progress, changes: changes),
    );
  }

  void succeed(
    String operationId, {
    SyncOperationProgress? progress,
    List<SyncChangeLog>? changes,
  }) {
    _replace(
      operationId,
      (operation) => operation.copyWith(
        status: SyncOperationStatus.succeeded,
        progress: progress,
        changes: changes,
        clearErrorMessage: true,
        finishedAt: DateTime.now(),
      ),
    );
  }

  void fail(String operationId, Object error) {
    _replace(
      operationId,
      (operation) => operation.copyWith(
        status: SyncOperationStatus.failed,
        errorMessage: error.toString(),
        finishedAt: DateTime.now(),
      ),
    );
  }

  void clearFinished() {
    _operations.removeWhere((operation) => !operation.isActive);
    notifyListeners();
  }

  void _replace(
    String operationId,
    SyncOperation Function(SyncOperation) edit,
  ) {
    final index = _operations.indexWhere(
      (operation) => operation.id == operationId,
    );
    if (index == -1) return;
    _operations[index] = edit(_operations[index]);
    notifyListeners();
  }
}
