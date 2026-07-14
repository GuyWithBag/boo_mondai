import 'package:boo_mondai/lib.barrel.dart'
    show
        MutableEntity,
        Controller,
        HiveLocalDB,
        SupabaseRemoteDB,
        ChangeTrackerController,
        SyncPlanPayload,
        PreviewedChangePlan,
        ChangeTrackerService,
        ChangeTrackerEntry,
        AppException,
        ChangeSource,
        ChangeTrackerStatus,
        SyncService,
        SyncWorkflowController;
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SyncController<T extends MutableEntity> extends Controller
    implements SyncWorkflowController {
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
  ChangeTrackerController? _changeTrackerController;
  PreviewedChangePlan<SyncPlanPayload<T>, T>? changePlan;

  @override
  bool get isSyncing => _isSyncing;
  @override
  String? get syncError => _syncError;
  @override
  ChangeTrackerService? get changeTrackerService =>
      _changeTrackerController?.service;

  @override
  ChangeTrackerEntry? get currentEntry {
    final changeTrackerController = _changeTrackerController;
    if (changeTrackerController == null) return null;

    for (final entry in changeTrackerController.entries) {
      if (entry.source != ChangeSource.sync) continue;
      if (entry.status == ChangeTrackerStatus.canceled ||
          entry.status == ChangeTrackerStatus.idle) {
        continue;
      }
      return entry;
    }
    return null;
  }

  @override
  bool get isAlreadyUpToDate =>
      currentEntry?.status == ChangeTrackerStatus.alreadyUpToDate;

  @override
  bool get shouldShowSyncPage {
    return switch (currentEntry?.status) {
      ChangeTrackerStatus.reviewing ||
      ChangeTrackerStatus.applying ||
      ChangeTrackerStatus.completed ||
      ChangeTrackerStatus.paused ||
      ChangeTrackerStatus.failed => !isAlreadyUpToDate,
      _ => false,
    };
  }

  void _bindChangeTracker(ChangeTrackerController changeTrackerController) {
    if (identical(_changeTrackerController, changeTrackerController)) return;
    _changeTrackerController?.removeListener(_handleChangeTrackerChanged);
    _changeTrackerController = changeTrackerController;
    _changeTrackerController?.addListener(_handleChangeTrackerChanged);
  }

  void _handleChangeTrackerChanged() {
    notifyListeners();
  }

  @override
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

  @override
  void applyCurrentEntry() {
    final entry = currentEntry;
    final changeTrackerController = _changeTrackerController;
    if (entry == null || changeTrackerController == null) return;
    _isSyncing = false;
    notifyListeners();
    changeTrackerController.apply(entry.id);
  }

  @override
  void dismissCurrentEntry() {
    final entry = currentEntry;
    final changeTrackerController = _changeTrackerController;
    _isSyncing = false;
    _syncError = null;
    changePlan = null;
    if (entry != null && changeTrackerController != null) {
      changeTrackerController.cancel(entry.id);
      changeTrackerController.remove(entry.id);
    }
    notifyListeners();
  }

  @override
  void clearAlreadyUpToDate() {
    final entry = currentEntry;
    final changeTrackerController = _changeTrackerController;
    _isSyncing = false;
    changePlan = null;
    if (entry != null && changeTrackerController != null) {
      changeTrackerController.remove(entry.id);
    }
    notifyListeners();
  }

  Future<void> sync(ChangeTrackerController changeTrackerController) async {
    _bindChangeTracker(changeTrackerController);
    final alreadyActive = changeTrackerController.activeEntries.any(
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
        changeTrackerController: changeTrackerController,
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

  @override
  void dispose() {
    _changeTrackerController?.removeListener(_handleChangeTrackerChanged);
    super.dispose();
  }
}

SyncController<T> useSyncController<T extends MutableEntity>({
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
