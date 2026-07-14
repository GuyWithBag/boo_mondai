import 'package:boo_mondai/lib.barrel.dart'
    show
        AppException,
        ChangeSource,
        ChangeTrackerController,
        ChangeTrackerEntry,
        ChangeTrackerService,
        ChangeTrackerStatus,
        Controller,
        LocalDB,
        RemoteDB,
        SyncWorkflowController,
        DeckSyncService,
        DeckSyncSession;
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DeckSyncController extends Controller implements SyncWorkflowController {
  DeckSyncController({
    required this.userId,
    required this.onSynced,
    this.deckId,
    this.beforeSync,
  });

  final String Function() userId;
  final String? deckId;
  final VoidCallback onSynced;
  final Future<void> Function()? beforeSync;

  bool _isSyncing = false;
  String? _syncError;
  ChangeTrackerController? _changeTrackerController;

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
      await DeckSyncService.sync(
        session: DeckSyncSession(
          userId: userId(),
          deckId: deckId,
          changeTrackerController: changeTrackerController,
          decks: LocalDB.deck,
          remoteDecks: RemoteDB.deck,
          deckListings: LocalDB.deckListing,
          remoteDeckListings: RemoteDB.deckListing,
          cardTemplates: LocalDB.cardTemplate,
          remoteCardTemplates: RemoteDB.card,
          studyCards: LocalDB.studyCard,
          remoteStudyCards: RemoteDB.studyCard,
          fsrsCards: LocalDB.fsrsCard,
          remoteFsrsCards: RemoteDB.fsrsSync,
          reviewLogs: LocalDB.reviewLog,
          remoteReviewLogs: RemoteDB.reviewLog,
          syncDeletions: LocalDB.syncDeletion,
          tags: LocalDB.tag,
          remoteTags: RemoteDB.tag,
          deckTags: LocalDB.deckTag,
          remoteDeckTags: RemoteDB.deckTag,
          cardTemplateTags: LocalDB.cardTemplateTag,
          remoteCardTemplateTags: RemoteDB.cardTemplateTag,
          userStudyCardTags: LocalDB.userStudyCardTag,
          remoteUserStudyCardTags: RemoteDB.userStudyCardTag,
          remoteStorage: RemoteDB.publicBucket,
        ),
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

DeckSyncController useDeckSyncController({
  required String Function() userId,
  required VoidCallback onSynced,
  String? deckId,
  Future<void> Function()? beforeSync,
}) {
  final onSyncedRef = useRef(onSynced);
  final userIdRef = useRef(userId);
  final beforeSyncRef = useRef(beforeSync);

  onSyncedRef.value = onSynced;
  userIdRef.value = userId;
  beforeSyncRef.value = beforeSync;

  final controller = useMemoized(
    () => DeckSyncController(
      userId: () => userIdRef.value(),
      deckId: deckId,
      onSynced: () => onSyncedRef.value(),
      beforeSync: () => beforeSyncRef.value?.call() ?? Future.value(),
    ),
    [deckId],
  );

  useEffect(() => controller.dispose, [controller]);
  useListenable(controller);

  return controller;
}

Future<void> adoptLegacyDeckOwnerForSync() async {
  final profile = LocalDB.profile.getOrCreate();
  await LocalDB.deck.adoptLegacyOwnerId(
    legacyUserId: profile.userId,
    currentProfileId: profile.id,
  );
}
