import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonColor,
        ChangeDirection,
        ChangeTrackerApply,
        ChangeTrackerDiscard,
        ChangeTrackerEntry,
        ChangeTrackerRouteArgs,
        ChangeTrackerService,
        ChangeTrackerStatus,
        ChangedEntity,
        ModalAction,
        showModal;
import 'package:boo_mondai/core/services/service_registry.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_hooks/signals_hooks.dart';

/// Flutter-facing adapter for [ChangeTrackerService].
///
/// Workflows call [start] to create a [ChangeTrackerEntry], then call [update],
/// [complete], or [fail] as planning/applying progresses. UI
/// surfaces watch this controller through Provider and render entries as
/// review pages, sync summaries, or download progress rows.
///
/// The underlying service stores entries only for the lifetime of the app
/// process. Durable workflow state, such as resumable deck download
/// checkpoints, belongs to the owning feature service.
class ChangeTrackerController {
  /// Creates a UI adapter around [service].
  ChangeTrackerController({
    ChangeTrackerService? service,
    required this.pageArgs,
  }) : service = ServiceRegistry.add(service ?? ChangeTrackerService()) {
    entries.value = this.service.entries;
    this.service.addOnChangedListener(refreshEntries);
  }

  final ChangeTrackerService service;
  final entries = signal<List<ChangeTrackerEntry<Object?>>>(const []);
  final error = signal<Exception?>(null);

  final Signal<ChangeTrackerRouteArgs> pageArgs;
  late final entry = computed(() {
    return entryById(pageArgs.value.entryId);
  });
  late final isReviewing = computed(
    () => entry.value?.status == ChangeTrackerStatus.reviewing,
  );

  late final activeEntries = computed(
    () =>
        entries.value.where((entry) => entry.isActive).toList(growable: false),
  );

  /// Returns the workflow-specific user-facing label for [direction].
  String getDirectionLabel(ChangeDirection direction) =>
      service.getDirectionLabel(direction);

  /// Finds an entry by id, returning null when it has been removed.
  ChangeTrackerEntry<Object?>? entryById(String entryId) =>
      service.entryById(entryId);

  void refreshEntries() {
    entries.value = service.entries;
  }

  /// Creates an entry and optionally stores the callback that applies it.
  ChangeTrackerEntry<T> start<T>({
    required ChangeTrackerEntry<T> entry,
    ChangeTrackerApply<T>? onChangeApply,
    ChangeTrackerDiscard<T>? onChangeDiscard,
  }) {
    return service.start(
      entry: entry,
      onChangeApply: onChangeApply,
      onChangeDiscard: onChangeDiscard,
    );
  }

  /// Updates lifecycle fields for an entry unless it has already been canceled.
  void update(
    String entryId, {
    ChangeTrackerStatus? status,
    double? progress,
    List<ChangedEntity<Object?>>? changes,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    service.update(
      entryId,
      status: status,
      progress: progress,
      changes: changes,
      errorMessage: errorMessage,
      clearErrorMessage: clearErrorMessage,
    );
  }

  /// Marks an entry completed and optionally replaces its final records.
  void complete(String entryId, {List<ChangedEntity<Object?>>? changes}) {
    service.complete(entryId, changes: changes);
  }

  /// Runs the registered apply callback and completes or fails the entry.
  ///
  /// When no apply callback is registered, the entry is simply marked complete.
  /// This supports workflows that already performed their mutation while still
  /// using the change tracker to display status.
  Future<void> apply(String entryId) async {
    final result = await service.apply(entryId);
    if (result != null) {
      error.value = result is Exception ? result : Exception(result.toString());
    }
  }

  Future<void> discard(String entryId) async {
    final result = await service.discard(entryId);
    if (result != null) {
      error.value = result is Exception ? result : Exception(result.toString());
    }
  }

  /// Marks the entry as paused. The caller owns the real pause signal.
  void pause(String entryId) {
    service.pause(entryId);
  }

  /// Marks the entry as applying again so the UI reflects resuming.
  void resume(String entryId) {
    service.resume(entryId);
  }

  /// Marks an entry failed and stores a user-visible error message.
  void fail(String entryId, Object value) {
    error.value = value is Exception ? value : Exception(value.toString());
    service.fail(entryId, value);
  }

  /// Cancels an entry and removes any pending apply callback.
  void cancel(String entryId) {
    service.cancel(entryId);
  }

  /// Removes an entry from memory.
  void remove(String entryId) {
    service.remove(entryId);
  }

  /// Drops all non-active entries and their stale apply callbacks.
  void clearFinished() {
    service.clearFinished();
  }

  void dispose() {
    service.removeOnChangedListener(refreshEntries);
    entries.dispose();
    error.dispose();
    entry.dispose();
    isReviewing.dispose();
    activeEntries.dispose();
  }

  void popToFirstRoute(BuildContext context) {
    while (context.canPop()) {
      context.pop();
    }
  }

  Future<void> onDiscardRemoteChanges(BuildContext context) async {
    final confirmed = await showModal<bool>(
      context: context,
      title: 'Discard remote changes?',
      subtitle:
          'This keeps your local data and makes the remote account match it. Remote edits will be overwritten, and rows that only exist remotely will be deleted from the account.',
      leading: const Icon(Icons.warning_amber_rounded),
      actions: const [
        ModalAction<bool>(value: false, label: 'Cancel'),
        ModalAction<bool>(
          value: true,
          label: 'Discard remote',
          color: ButtonColor.error,
        ),
      ],
    );
    if (confirmed != true) return;

    await discard(entry.value!.id);
    if (context.mounted) {
      popToFirstRoute(context);
    }
  }
}
