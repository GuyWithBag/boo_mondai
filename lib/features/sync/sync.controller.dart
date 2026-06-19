import 'package:boo_mondai/core/controllers/controller.dart';
import 'package:boo_mondai/core/database/hive.local.db.dart';
import 'package:boo_mondai/core/database/supabase.remote.db.dart';
import 'package:boo_mondai/core/exceptions/app_exception.dart';
import 'package:boo_mondai/core/models/dto.dart';
import 'package:boo_mondai/features/sync/models/sync_plan_payload.dart';
import 'package:boo_mondai/features/sync/sync.service.dart';
import 'package:boo_mondai/features/change_tracker/change_tracker.controller.dart';
import 'package:boo_mondai/features/change_tracker/models/change_preview.dart';
import 'package:boo_mondai/features/change_tracker/models/change_source.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SyncController<T extends DTO> extends Controller {
  SyncController({
    required this.localDb,
    required this.remoteDb,
    required this.userId,
    required this.onSynced,
    this.localWhere,
    this.beforeSync,
  });

  final HiveLocalDB<T> localDb;
  final SupabaseRemoteDB<T> remoteDb;
  final String Function() userId;
  final VoidCallback onSynced;
  final bool Function(T item)? localWhere;
  final Future<void> Function()? beforeSync;

  bool _isSyncing = false;
  String? _syncError;
  ChangePreview<SyncPlanPayload<T>>? changePlan;

  bool get isSyncing => _isSyncing;
  String? get syncError => _syncError;

  void clearSyncError() {
    _syncError = null;
    notifyListeners();
  }

  void clearChangePreview() {
    changePlan = null;
    notifyListeners();
  }

  void clearSyncing() {
    _isSyncing = false;
    notifyListeners();
  }

  void dismissSyncReview(
    ChangeTrackerController reviewController,
    String entryId,
  ) {
    _isSyncing = false;
    _syncError = null;
    reviewController.cancel(entryId);
    reviewController.remove(entryId);
    notifyListeners();
  }

  Future<void> sync(ChangeTrackerController reviewController) async {
    final alreadyActive = reviewController.activeEntries.any(
      (plan) => plan.source == ChangeSource.sync,
    );
    if (alreadyActive) return;

    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      await beforeSync?.call();
      changePlan = await SyncService.sync<T>(
        localDb: localDb,
        remoteDb: remoteDb,
        userId: userId(),
        reviewController: reviewController,
        localWhere: localWhere,
      );

      onSynced();
    } on AppException catch (e) {
      if (_isSyncing) {
        _syncError = e.message;
      }
      _isSyncing = false;
    } finally {
      notifyListeners();
    }
  }
}

SyncController<T> useSyncController<T extends DTO>({
  required HiveLocalDB<T> localDb,
  required SupabaseRemoteDB<T> remoteDb,
  required String Function() userId,
  required VoidCallback onSynced,
  bool Function(T item)? localWhere,
  Future<void> Function()? beforeSync,
}) {
  final onSyncedRef = useRef(onSynced);
  final userIdRef = useRef(userId);
  final localWhereRef = useRef(localWhere);
  final beforeSyncRef = useRef(beforeSync);

  onSyncedRef.value = onSynced;
  userIdRef.value = userId;
  localWhereRef.value = localWhere;
  beforeSyncRef.value = beforeSync;

  final controller = useMemoized(
    () => SyncController<T>(
      localDb: localDb,
      remoteDb: remoteDb,
      userId: () => userIdRef.value(),
      onSynced: () => onSyncedRef.value(),
      localWhere: (item) => localWhereRef.value?.call(item) ?? true,
      beforeSync: () => beforeSyncRef.value?.call() ?? Future.value(),
    ),
    [localDb, remoteDb],
  );

  useEffect(() => controller.dispose, [controller]);
  useListenable(controller);

  return controller;
}
