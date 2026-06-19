import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangeRecord,
        ChangeSource,
        ChangeTrackerEntry,
        ChangeTrackerReporter,
        ChangeTrackerStatus,
        Controller;

/// Callback registered by a workflow to apply a reviewed operation.
///
/// Must return the [ChangeRecord] list that was actually applied. Called by
/// [ChangeTrackerController.apply] when the user confirms the operation.
typedef ChangeTrackerApply = Future<List<ChangeRecord>> Function();

/// Tracks preview/apply entries that need user review before mutation.
class ChangeTrackerController extends Controller
    implements ChangeTrackerReporter {
  final List<ChangeTrackerEntry> _entries = [];
  final Map<String, ChangeTrackerApply> _applyByEntryId = {};

  /// All known entries, newest first.
  List<ChangeTrackerEntry> get entries => List.unmodifiable(_entries);

  /// Entries that are still previewing, reviewing, applying, or paused.
  List<ChangeTrackerEntry> get activeEntries =>
      _entries.where((entry) => entry.isActive).toList(growable: false);

  /// Finds an entry by id, returning null when it has been removed.
  @override
  ChangeTrackerEntry? entryById(String entryId) {
    for (final entry in _entries) {
      if (entry.id == entryId) return entry;
    }
    return null;
  }

  /// Creates an entry and optionally stores the callback that applies it.
  @override
  ChangeTrackerEntry start({
    required ChangeSource source,
    required String title,
    ChangeTrackerStatus status = ChangeTrackerStatus.previewing,
    double? progress,
    List<ChangeRecord> changes = const [],
    ChangeTrackerApply? onApply,
  }) {
    final entry = ChangeTrackerEntry(
      source: source,
      title: title,
      status: status,
      progress: progress,
      changes: changes,
    );
    _entries.insert(0, entry);
    if (onApply != null) {
      _applyByEntryId[entry.id] = onApply;
    }
    notifyListeners();
    return entry;
  }

  /// Updates lifecycle fields for an entry unless it has already been canceled.
  @override
  void update(
    String entryId, {
    ChangeTrackerStatus? status,
    double? progress,
    List<ChangeRecord>? changes,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    final current = entryById(entryId);
    if (current?.status == ChangeTrackerStatus.canceled) return;
    _replace(
      entryId,
      (entry) => entry.copyWith(
        status: status,
        progress: progress,
        changes: changes,
        errorMessage: errorMessage,
        clearErrorMessage: clearErrorMessage,
      ),
    );
  }

  /// Marks an entry completed and optionally replaces its final records.
  @override
  void complete(String entryId, {List<ChangeRecord>? changes}) {
    final current = entryById(entryId);
    if (current?.status == ChangeTrackerStatus.canceled) return;
    _replace(
      entryId,
      (entry) => entry.copyWith(
        status: ChangeTrackerStatus.completed,
        progress: 1,
        changes: changes,
        clearErrorMessage: true,
        finishedAt: DateTime.now(),
      ),
    );
  }

  /// Runs the registered apply callback and completes or fails the entry.
  Future<void> apply(String entryId) async {
    final applyFn = _applyByEntryId[entryId];
    if (applyFn == null) {
      complete(entryId);
      return;
    }

    update(entryId, status: ChangeTrackerStatus.applying, progress: 0);
    try {
      final changes = await applyFn();
      complete(entryId, changes: changes);
    } catch (e) {
      fail(entryId, e);
    } finally {
      _applyByEntryId.remove(entryId);
    }
  }

  /// Marks the entry as paused. The caller owns the real pause signal.
  @override
  void pause(String entryId) {
    final current = entryById(entryId);
    if (current == null) return;
    if (current.status == ChangeTrackerStatus.canceled ||
        current.status == ChangeTrackerStatus.completed ||
        current.status == ChangeTrackerStatus.failed) {
      return;
    }
    _replace(
      entryId,
      (entry) => entry.copyWith(status: ChangeTrackerStatus.paused),
    );
  }

  /// Marks the entry as applying again so the UI reflects resuming.
  @override
  void resume(String entryId) {
    final current = entryById(entryId);
    if (current?.status != ChangeTrackerStatus.paused) return;
    _replace(
      entryId,
      (entry) => entry.copyWith(status: ChangeTrackerStatus.applying),
    );
  }

  /// Marks an entry failed and stores a user-visible error message.
  @override
  void fail(String entryId, Object error) {
    final current = entryById(entryId);
    if (current?.status == ChangeTrackerStatus.canceled) return;
    setError(error is Exception ? error : Exception(error.toString()));
    _replace(
      entryId,
      (entry) => entry.copyWith(
        status: ChangeTrackerStatus.failed,
        errorMessage: error.toString(),
        finishedAt: DateTime.now(),
      ),
    );
  }

  /// Cancels an entry and removes any pending apply callback.
  void cancel(String entryId) {
    _applyByEntryId.remove(entryId);
    _replace(
      entryId,
      (entry) => entry.copyWith(
        status: ChangeTrackerStatus.canceled,
        finishedAt: DateTime.now(),
      ),
    );
  }

  /// Removes an entry from memory.
  void remove(String entryId) {
    final index = _entries.indexWhere((entry) => entry.id == entryId);
    if (index == -1) return;
    _applyByEntryId.remove(entryId);
    _entries.removeAt(index);
    notifyListeners();
  }

  /// Drops all non-active entries and their stale apply callbacks.
  void clearFinished() {
    for (final entry in _entries.where((entry) => !entry.isActive)) {
      _applyByEntryId.remove(entry.id);
    }
    _entries.removeWhere((entry) => !entry.isActive);
    notifyListeners();
  }

  void _replace(
    String entryId,
    ChangeTrackerEntry Function(ChangeTrackerEntry) edit,
  ) {
    final index = _entries.indexWhere((entry) => entry.id == entryId);
    if (index == -1) return;
    _entries[index] = edit(_entries[index]);
    notifyListeners();
  }
}
