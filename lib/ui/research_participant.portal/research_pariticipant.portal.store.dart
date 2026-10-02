import 'dart:async';

import 'package:boo_mondai/lib.barrel.dart'
    show
        ImmediateSchedule,
        LocalDB,
        NotificationIds,
        Notifications,
        NotificationsController,
        ProfileRole,
        ResearchParticipantSetAData,
        ResearchParticipantSetBData,
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

    final existingNotification = LocalDB.notifications.selectByPk({
      'id': NotificationIds.firstDrillSurvey,
    }, includeDeleted: true);
    if (existingNotification != null &&
        existingNotification.profileId == profile.id) {
      return;
    }

    await NotificationsController.instance.notify(
      Notifications.firstDrillSurvey(),
      const ImmediateSchedule.now(),
    );
  }

  bool _isResearchParticipantDeck(String? deckId) {
    return deckId == ResearchParticipantSetAData.dataDeckId ||
        deckId == ResearchParticipantSetBData.dataDeckId;
  }

  bool _isParticipantDeckForRole({
    required String? deckId,
    required ProfileRole role,
  }) {
    return switch (role) {
      ProfileRole.participantA =>
        deckId == ResearchParticipantSetAData.dataDeckId,
      ProfileRole.participantB =>
        deckId == ResearchParticipantSetBData.dataDeckId,
      _ => false,
    };
  }
}
