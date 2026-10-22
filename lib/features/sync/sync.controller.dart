import 'package:boo_mondai/lib.barrel.dart'
    show
        AppException,
        ChangeSource,
        ChangeTrackerController,
        ChangeTrackerStatus,
        SyncService,
        SyncTable;
import 'package:flutter/foundation.dart';
import 'package:signals/signals_flutter.dart';

class SyncController {
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

  final isSyncing = signal(false);
  final error = signal<Exception?>(null);
  final changeTrackerController = signal<ChangeTrackerController?>(null);
  final changeTrackerRevision = signal(0);

  late final changeTrackerService = computed(
    () => changeTrackerController.value?.service,
  );

  late final currentEntry = computed(() {
    final controller = changeTrackerController.value;
    changeTrackerRevision.value;
    if (controller == null) return null;

    for (final entry in controller.entries.value) {
      if (entry.source != ChangeSource.sync) continue;
      if (entry.status == ChangeTrackerStatus.canceled ||
          entry.status == ChangeTrackerStatus.idle) {
        continue;
      }
      return entry;
    }
    return null;
  });

  late final isAlreadyUpToDate = computed(
    () => currentEntry.value?.status == ChangeTrackerStatus.alreadyUpToDate,
  );

  late final shouldShowSyncPage = computed(() {
    return switch (currentEntry.value?.status) {
      ChangeTrackerStatus.reviewing ||
      ChangeTrackerStatus.applying ||
      ChangeTrackerStatus.completed ||
      ChangeTrackerStatus.paused ||
      ChangeTrackerStatus.failed => !isAlreadyUpToDate.value,
      _ => false,
    };
  });

  ChangeTrackerController? _boundChangeTrackerController;

  void bindChangeTracker(ChangeTrackerController controller) {
    if (identical(_boundChangeTrackerController, controller)) return;
    _boundChangeTrackerController?.service.removeOnChangedListener(
      _handleChangeTrackerChanged,
    );
    _boundChangeTrackerController = controller;
    changeTrackerController.value = controller;
    controller.service.addOnChangedListener(_handleChangeTrackerChanged);
    changeTrackerRevision.value++;
  }

  void _handleChangeTrackerChanged() {
    changeTrackerRevision.value++;
  }

  void clearError() {
    error.value = null;
  }

  void applyCurrentEntry() {
    final entry = currentEntry.value;
    final controller = changeTrackerController.value;
    if (entry == null || controller == null) return;
    isSyncing.value = false;
    controller.apply(entry.id);
  }

  void dismissCurrentEntry() {
    final entry = currentEntry.value;
    final controller = changeTrackerController.value;
    isSyncing.value = false;
    error.value = null;
    if (entry != null && controller != null) {
      controller.cancel(entry.id);
      controller.remove(entry.id);
    }
  }

  void discardRemoteChangesForCurrentEntry() {
    final entry = currentEntry.value;
    final controller = changeTrackerController.value;
    if (entry == null || controller == null) return;
    isSyncing.value = false;
    controller.discard(entry.id);
  }

  void clearAlreadyUpToDate() {
    final entry = currentEntry.value;
    final controller = changeTrackerController.value;
    isSyncing.value = false;
    if (entry != null && controller != null) {
      controller.remove(entry.id);
    }
  }

  Future<void> sync(ChangeTrackerController controller) async {
    bindChangeTracker(controller);
    final alreadyActive = controller.activeEntries.value.any(
      (plan) => plan.source == ChangeSource.sync,
    );
    if (alreadyActive) return;

    isSyncing.value = true;
    error.value = null;

    try {
      await beforeSync?.call();
      await SyncService.sync(
        title: title,
        profileId: profileId(),
        tables: getTables(),
        changeTrackerController: controller,
      );
      onSynced();
      isSyncing.value = false;
    } on AppException catch (e) {
      error.value = e;
      isSyncing.value = false;
    } finally {
      changeTrackerRevision.value++;
    }
  }

  void dispose() {
    _boundChangeTrackerController?.service.removeOnChangedListener(
      _handleChangeTrackerChanged,
    );
    isSyncing.dispose();
    error.dispose();
    changeTrackerController.dispose();
    changeTrackerRevision.dispose();
    changeTrackerService.dispose();
    currentEntry.dispose();
    isAlreadyUpToDate.dispose();
    shouldShowSyncPage.dispose();
  }
}
