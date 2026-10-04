import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonColor,
        FsrsCard,
        LocalDB,
        ProfileService,
        SessionMode,
        StudyRating,
        StudySessionCardStep,
        StudySessionCompletedResults,
        StudySessionSnapshot,
        ViewStudySessionResultAnswer;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';

final class ViewStudySessionResultController {
  ViewStudySessionResultController({required this.sessionId}) {
    load();
  }

  final String sessionId;

  final cardAnswers = signal<List<ViewStudySessionResultAnswer>>(const []);
  final completedResults = signal<StudySessionCompletedResults?>(null);
  final snapshots = signal<List<StudySessionSnapshot>>(const []);

  late final totalCards = computed(() => cardAnswers.value.length);

  late final availableSessionReviewCards = computed<List<FsrsCard>>(() {
    final results = completedResults.value;
    if (results == null) return const [];

    final sessionStudyCardIds = snapshots.value
        .map((snapshot) => snapshot.step)
        .whereType<StudySessionCardStep>()
        .map((step) => step.studyCardId)
        .toSet();
    if (sessionStudyCardIds.isEmpty) return const [];

    return LocalDB.fsrsCard.getEnrolledStudyCardIds(
      ProfileService.currentProfile.value.id,
    );
  });

  late final canReviewNow = computed(
    () =>
        completedResults.value?.mode != SessionMode.review &&
        availableSessionReviewCards.value.isNotEmpty,
  );

  late final backButtonLabel = computed(() {
    return 'Done';
  });

  late final backButtonVariants = computed(
    () => canReviewNow.value
        ? const <ButtonColor>[]
        : const [ButtonColor.primary],
  );

  late final breakdown = computed<Map<StudyRating, int>>(() {
    final result = <StudyRating, int>{
      for (final type in StudyRating.values) type: 0,
    };

    for (final answer in cardAnswers.value) {
      result[answer.type] = (result[answer.type] ?? 0) + 1;
    }

    return result;
  });

  void load() {
    final results = LocalDB.studySessionCompletedResults.getBySessionId(
      sessionId,
    );
    completedResults.value = results;

    final sessionSnapshots =
        (results?.snapshots ??
                LocalDB.studySessionSnapshot.getBySessionId(sessionId))
            .toList()
          ..sort((a, b) => a.sequenceNumber.compareTo(b.sequenceNumber));
    snapshots.value = sessionSnapshots;
    cardAnswers.value = sessionSnapshots
        .where((snapshot) => snapshot.rating != null)
        .map(answerFromSnapshot)
        .toList();
  }

  ViewStudySessionResultAnswer answerFromSnapshot(
    StudySessionSnapshot snapshot,
  ) {
    return ViewStudySessionResultAnswer(
      answerValue: snapshot.answer!.value,
      type: snapshot.rating!,
    );
  }

  void onBackPressed(BuildContext context) {
    goHome(context);
  }

  void goHome(BuildContext context) {
    context.go('/');
  }

  void goReviews(BuildContext context) {
    context.go('/reviews');
  }

  void reviewNow(BuildContext context) {
    if (!canReviewNow.value) return;
    final deckId = completedResults.value?.deckId;
    if (deckId == null) {
      context.go('/review/session');
      return;
    }

    context.go('/review/$deckId/session');
  }

  void dispose() {
    cardAnswers.dispose();
    completedResults.dispose();
    snapshots.dispose();
    availableSessionReviewCards.dispose();
    canReviewNow.dispose();
    backButtonLabel.dispose();
    backButtonVariants.dispose();
    totalCards.dispose();
    breakdown.dispose();
  }
}
