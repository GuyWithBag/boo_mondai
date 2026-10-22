import 'dart:async';

import 'package:boo_mondai/lib.barrel.dart'
    show
        ImmediateSchedule,
        LocalDB,
        NotificationIds,
        Notifications,
        NotificationsController,
        ProfileRole,
        ResearchParticipantChineseSetAData,
        ResearchParticipantChineseSetBData,
        ResearchParticipantJapaneseSetAData,
        ResearchParticipantJapaneseSetBData,
        StudySessionCompletedResults;

class ResearchPariticipantPortalStore {
  static final instance = ResearchPariticipantPortalStore();

  StreamSubscription<dynamic>? _completedResultsSubscription;

  void init() {
    _completedResultsSubscription ??= LocalDB.studySessionCompletedResults
        .watch()
        .listen((event) {
          if (event.deleted) return;

          final result = event.value;
          if (result is StudySessionCompletedResults) {
            _handleCompletedResult(result);
          }
        });
  }

  Future<void> dispose() async {
    await _completedResultsSubscription?.cancel();
    _completedResultsSubscription = null;
  }

  Future<void> _handleCompletedResult(
    StudySessionCompletedResults result,
  ) async {
    final profile = LocalDB.currentProfile.getOrCreate();
    if (result.profileId != profile.id) return;
    if (!_isResearchParticipantDeck(result.deckId)) return;
    if (!_isParticipantDeckForRole(deckId: result.deckId, role: profile.role)) {
      return;
    }
    if (result.deckId case final deckId?) {
      final remainingEligibleCards = LocalDB.studyCard.getEligibleDrillCards(
        deckId,
        profile.id,
      );
      if (remainingEligibleCards.isNotEmpty) return;
    }

    final existingNotification = LocalDB.notifications.selectByPk({
      'id': NotificationIds.finalDrillBatchSurvey,
    }, includeDeleted: true);
    if (existingNotification != null &&
        existingNotification.profileId == profile.id) {
      return;
    }

    await NotificationsController.instance.notify(
      Notifications.finalDrillBatchSurvey(),
      const ImmediateSchedule.now(),
    );
  }

  bool _isResearchParticipantDeck(String? deckId) {
    return deckId == ResearchParticipantChineseSetAData.dataDeckId ||
        deckId == ResearchParticipantChineseSetBData.dataDeckId ||
        deckId == ResearchParticipantJapaneseSetAData.dataDeckId ||
        deckId == ResearchParticipantJapaneseSetBData.dataDeckId;
  }

  bool _isParticipantDeckForRole({
    required String? deckId,
    required ProfileRole role,
  }) {
    return switch (role) {
      ProfileRole.participantChineseA =>
        deckId == ResearchParticipantChineseSetAData.dataDeckId,
      ProfileRole.participantChineseB =>
        deckId == ResearchParticipantChineseSetBData.dataDeckId,
      ProfileRole.participantJapaneseA =>
        deckId == ResearchParticipantJapaneseSetAData.dataDeckId,
      ProfileRole.participantJapaneseB =>
        deckId == ResearchParticipantJapaneseSetBData.dataDeckId,
      _ => false,
    };
  }
}
