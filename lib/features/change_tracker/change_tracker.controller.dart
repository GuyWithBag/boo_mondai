import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangedEntity,
        ChangeTrackerEntry,
        ChangeTrackerApply,
        ChangeTrackerService,
        ChangeTrackerStatus,
        Controller;
import 'package:flutter_hooks/flutter_hooks.dart';

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
class ChangeTrackerController extends Controller {
  /// Creates a UI adapter around [service].
  ChangeTrackerController({ChangeTrackerService? service})
    : _service = service ?? ChangeTrackerService() {
    _service.onChanged = notifyListeners;
  }

  final ChangeTrackerService _service;

  /// Service layer used by workflows that should not depend on UI controller
  /// behavior.
  ChangeTrackerService get service => _service;

  /// All known entries, newest first.
  List<ChangeTrackerEntry<Object?>> get entries => _service.entries;

  /// Entries that are still planning, reviewing, applying, or paused.
  List<ChangeTrackerEntry<Object?>> get activeEntries => _service.activeEntries;

  /// Finds an entry by id, returning null when it has been removed.
  ChangeTrackerEntry<Object?>? entryById(String entryId) =>
      _service.entryById(entryId);

  /// Creates an entry and optionally stores the callback that applies it.
  ChangeTrackerEntry<T> start<T>({
    required ChangeTrackerEntry<T> entry,
    ChangeTrackerApply<T>? onApply,
  }) {
    return _service.start(entry: entry, onApply: onApply);
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
    _service.update(
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
    _service.complete(entryId, changes: changes);
  }

  /// Runs the registered apply callback and completes or fails the entry.
  ///
  /// When no apply callback is registered, the entry is simply marked complete.
  /// This supports workflows that already performed their mutation while still
  /// using the change tracker to display status.
  Future<void> apply(String entryId) async {
    final error = await _service.apply(entryId);
    if (error != null) {
      setError(error is Exception ? error : Exception(error.toString()));
      notifyListeners();
    }
  }

  /// Marks the entry as paused. The caller owns the real pause signal.
  void pause(String entryId) {
    _service.pause(entryId);
    notifyListeners();
  }

  /// Marks the entry as applying again so the UI reflects resuming.
  void resume(String entryId) {
    _service.resume(entryId);
    notifyListeners();
  }

  /// Marks an entry failed and stores a user-visible error message.
  void fail(String entryId, Object error) {
    setError(error is Exception ? error : Exception(error.toString()));
    _service.fail(entryId, error);
    notifyListeners();
  }

  /// Cancels an entry and removes any pending apply callback.
  void cancel(String entryId) {
    _service.cancel(entryId);
    notifyListeners();
  }

  /// Removes an entry from memory.
  void remove(String entryId) {
    _service.remove(entryId);
    notifyListeners();
  }

  /// Drops all non-active entries and their stale apply callbacks.
  void clearFinished() {
    _service.clearFinished();
    notifyListeners();
  }
}

ChangeTrackerController useChangeTrackerController({
  ChangeTrackerService? service,
}) {
  final controller = useMemoized(
    () => ChangeTrackerController(service: service),
    [service],
  );
  useListenable(controller);
  return controller;
}
