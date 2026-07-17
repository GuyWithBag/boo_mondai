import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangedEntity,
        ChangeDirection,
        ChangeTrackerEntry,
        ChangeTrackerStatus,
        Service;

/// Callback registered by a workflow to apply a reviewed operation.
///
/// The callback is usually captured when a workflow starts planning changes and
/// is invoked later by [ChangeTrackerService.apply] after user confirmation. It
/// must return the [ChangedEntity] list that was actually applied so the final
/// entry reflects the committed result rather than only the original plan.
typedef ChangeTrackerApply<T> = Future<List<ChangedEntity<T>>> Function();
typedef ChangeTrackerDiscard<T> = Future<List<ChangedEntity<T>>> Function();

/// Pure workflow service for tracked change operations.
///
/// The service owns entry state and deferred apply callbacks without depending
/// on Flutter notification APIs. [ChangeTrackerController] wraps this service
/// for Provider/UI consumption.
class ChangeTrackerService extends Service {
  ChangeTrackerService({
    this.inboundLabel = 'inbound',
    this.outboundLabel = 'outbound',
  });

  @override
  String get name => 'ChangeTrackerService';

  /// User-facing label for [ChangeDirection.inbound].
  final String inboundLabel;

  /// User-facing label for [ChangeDirection.outbound].
  final String outboundLabel;

  final Set<void Function()> _onChangedListeners = {};
  final List<ChangeTrackerEntry<Object?>> _entries = [];
  final Map<String, Future<List<ChangedEntity<Object?>>> Function()>
  _applyByEntryId = {};
  final Map<String, Future<List<ChangedEntity<Object?>>> Function()>
  _discardByEntryId = {};

  /// Registers a callback that runs after the service mutates entry state.
  ///
  /// UI adapters can bridge this into their own notification mechanism without
  /// making the service depend on Flutter.
  void addOnChangedListener(void Function() listener) {
    _onChangedListeners.add(listener);
  }

  /// Removes a previously registered mutation callback.
  void removeOnChangedListener(void Function() listener) {
    _onChangedListeners.remove(listener);
  }

  /// All known entries, newest first.
  List<ChangeTrackerEntry<Object?>> get entries => List.unmodifiable(_entries);

  /// Entries that are still planning, reviewing, applying, or paused.
  List<ChangeTrackerEntry<Object?>> get activeEntries =>
      _entries.where((entry) => entry.isActive).toList(growable: false);

  /// Returns the workflow-specific user-facing label for [direction].
  String getDirectionLabel(ChangeDirection direction) {
    return switch (direction) {
      ChangeDirection.inbound => inboundLabel,
      ChangeDirection.outbound => outboundLabel,
    };
  }

  /// Finds an entry by id, returning null when it has been removed.
  ChangeTrackerEntry<Object?>? entryById(String entryId) {
    for (final entry in _entries) {
      if (entry.id == entryId) return entry;
    }
    return null;
  }

  /// Creates an entry and optionally stores the callback that applies it.
  ChangeTrackerEntry<T> start<T>({
    required ChangeTrackerEntry<T> entry,
    ChangeTrackerApply<T>? onChangeApply,
    ChangeTrackerDiscard<T>? onChangeDiscard,
  }) {
    _entries.insert(0, _eraseEntryType(entry));
    if (onChangeApply != null) {
      _applyByEntryId[entry.id] = () async =>
          (await onChangeApply()).cast<ChangedEntity<Object?>>();
    }
    if (onChangeDiscard != null) {
      _discardByEntryId[entry.id] = () async =>
          (await onChangeDiscard()).cast<ChangedEntity<Object?>>();
    }
    _emitChanged();
    return entry;
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
    final current = entryById(entryId);
    if (current?.status == ChangeTrackerStatus.canceled) return;
    _replace(
      entryId,
      (entry) => entry.copyWith(
        status: status,
        progress: progress,
        changes: changes,
        errorMessage: errorMessage,
      ),
    );
    _emitChanged();
  }

  /// Marks an entry completed and optionally replaces its final records.
  void complete(String entryId, {List<ChangedEntity<Object?>>? changes}) {
    final current = entryById(entryId);
    if (current?.status == ChangeTrackerStatus.canceled) return;
    _replace(
      entryId,
      (entry) => entry.copyWith(
        status: ChangeTrackerStatus.completed,
        progress: 1,
        changes: changes,
        finishedAt: DateTime.now(),
      ),
    );
    _emitChanged();
  }

  /// Runs the registered apply callback and completes or fails the entry.
  ///
  /// Returns the error object when applying fails so a UI adapter can mirror the
  /// failure through its own error handling hooks.
  Future<Object?> apply(String entryId) async {
    final applyFn = _applyByEntryId[entryId];
    if (applyFn == null) {
      complete(entryId);
      return null;
    }

    update(entryId, status: ChangeTrackerStatus.applying, progress: 0);
    try {
      final changes = await applyFn();
      complete(entryId, changes: changes);
      return null;
    } catch (e) {
      fail(entryId, e);
      return e;
    } finally {
      _applyByEntryId.remove(entryId);
      _discardByEntryId.remove(entryId);
    }
  }

  Future<Object?> discard(String entryId) async {
    final discardFn = _discardByEntryId[entryId];
    if (discardFn == null) {
      cancel(entryId);
      return null;
    }

    update(entryId, status: ChangeTrackerStatus.applying, progress: 0);
    try {
      final changes = await discardFn();
      complete(entryId, changes: changes);
      return null;
    } catch (e) {
      fail(entryId, e);
      return e;
    } finally {
      _applyByEntryId.remove(entryId);
      _discardByEntryId.remove(entryId);
    }
  }

  /// Marks the entry as paused. The caller owns the real pause signal.
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
    _emitChanged();
  }

  /// Marks the entry as applying again so the UI reflects resuming.
  void resume(String entryId) {
    final current = entryById(entryId);
    if (current?.status != ChangeTrackerStatus.paused) return;
    _replace(
      entryId,
      (entry) => entry.copyWith(status: ChangeTrackerStatus.applying),
    );
    _emitChanged();
  }

  /// Marks an entry failed and stores a user-visible error message.
  void fail(String entryId, Object error) {
    final current = entryById(entryId);
    if (current?.status == ChangeTrackerStatus.canceled) return;
    _replace(
      entryId,
      (entry) => entry.copyWith(
        status: ChangeTrackerStatus.failed,
        errorMessage: error.toString(),
        finishedAt: DateTime.now(),
      ),
    );
    _emitChanged();
  }

  /// Cancels an entry and removes any pending apply callback.
  void cancel(String entryId) {
    _applyByEntryId.remove(entryId);
    _discardByEntryId.remove(entryId);
    _replace(
      entryId,
      (entry) => entry.copyWith(
        status: ChangeTrackerStatus.canceled,
        finishedAt: DateTime.now(),
      ),
    );
    _emitChanged();
  }

  /// Removes an entry from memory.
  void remove(String entryId) {
    final index = _entries.indexWhere((entry) => entry.id == entryId);
    if (index == -1) return;
    _applyByEntryId.remove(entryId);
    _discardByEntryId.remove(entryId);
    _entries.removeAt(index);
    _emitChanged();
  }

  /// Drops all non-active entries and their stale apply callbacks.
  void clearFinished() {
    for (final entry in _entries.where((entry) => !entry.isActive)) {
      _applyByEntryId.remove(entry.id);
      _discardByEntryId.remove(entry.id);
    }
    _entries.removeWhere((entry) => !entry.isActive);
    _emitChanged();
  }

  void _replace(
    String entryId,
    ChangeTrackerEntry<Object?> Function(ChangeTrackerEntry<Object?>) edit,
  ) {
    final index = _entries.indexWhere((entry) => entry.id == entryId);
    if (index == -1) return;
    _entries[index] = edit(_entries[index]);
  }

  void _emitChanged() {
    for (final listener in List.of(_onChangedListeners)) {
      listener();
    }
  }

  ChangeTrackerEntry<Object?> _eraseEntryType<T>(ChangeTrackerEntry<T> entry) {
    return ChangeTrackerEntry<Object?>(
      id: entry.id,
      source: entry.source,
      title: entry.title,
      status: entry.status,
      changes: entry.changes.cast<ChangedEntity<Object?>>(),
      progress: entry.progress,
      errorMessage: entry.errorMessage,
      startedAt: entry.startedAt,
      finishedAt: entry.finishedAt,
    );
  }
}
