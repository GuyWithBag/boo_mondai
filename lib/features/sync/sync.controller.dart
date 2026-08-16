import 'package:boo_mondai/lib.barrel.dart'
    show
        AppException,
        ChangeSource,
        ChangeTrackerController,
        ChangeTrackerEntry,
        ChangeTrackerService,
        ChangeTrackerStatus,
        Controller,
        SyncService,
        SyncTable;
import 'package:flutter/foundation.dart';

class SyncController extends Controller {
  SyncController({
    required this.title,
    required this.profileId,
    required this.getTables,
    required this.onSynced,
    this.beforeSync,
  });

  final String title;
  final String Function() profileId;
  final List<SyncTable<dynamic>> Function() getTables;
  final VoidCallback onSynced;
  final Future<void> Function()? beforeSync;

  bool _isSyncing = false;
  String? _syncError;
  ChangeTrackerController? _changeTrackerController;

  bool get isSyncing => _isSyncing;

  String? get syncError => _syncError;

  ChangeTrackerService? get changeTrackerService =>
      _changeTrackerController?.service;

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

  bool get isAlreadyUpToDate =>
      currentEntry?.status == ChangeTrackerStatus.alreadyUpToDate;

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

  void clearSyncError() {
    _syncError = null;
    notifyListeners();
  }

  void applyCurrentEntry() {
    final entry = currentEntry;
    final changeTrackerController = _changeTrackerController;
    if (entry == null || changeTrackerController == null) return;
    _isSyncing = false;
    notifyListeners();
    changeTrackerController.apply(entry.id);
  }

  void dismissCurrentEntry() {
    final entry = currentEntry;
    final changeTrackerController = _changeTrackerController;
    _isSyncing = false;
    _syncError = null;
    if (entry != null && changeTrackerController != null) {
      changeTrackerController.cancel(entry.id);
      changeTrackerController.remove(entry.id);
    }
    notifyListeners();
  }

  void discardRemoteChangesForCurrentEntry() {
    final entry = currentEntry;
    final changeTrackerController = _changeTrackerController;
    if (entry == null || changeTrackerController == null) return;
    _isSyncing = false;
    notifyListeners();
    changeTrackerController.discard(entry.id);
  }

  void clearAlreadyUpToDate() {
    final entry = currentEntry;
    final changeTrackerController = _changeTrackerController;
    _isSyncing = false;
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
      await SyncService.sync(
        title: title,
        profileId: profileId(),
        tables: getTables(),
        changeTrackerController: changeTrackerController,
      );
      onSynced();
      _isSyncing = false;
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
