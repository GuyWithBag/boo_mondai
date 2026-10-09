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

    return LocalDB.fsrsCard.selectManyByProfileIdAndStudyCardIds(
      profileId: ProfileService.currentProfile.value.id,
      studyCardIds: sessionStudyCardIds,
    );
  });

  late final canReviewNow = computed(
    () =>
        completedResults.value?.mode != SessionMode.review &&
        availableSessionReviewCards.value.isNotEmpty,
  );

  late final remainingDrillCardCount = computed(() {
    final results = completedResults.value;
    final deckId = results?.deckId;
    if (results == null ||
        results.mode != SessionMode.drill ||
        deckId == null) {
      return 0;
    }

    return LocalDB.studyCard
        .getEligibleDrillCards(deckId, results.profileId)
        .length;
  });

  late final canContinueNextBatch = computed(
    () => remainingDrillCardCount.value > 0,
  );

  late final hasPrimaryAction = computed(
    () => canContinueNextBatch.value || canReviewNow.value,
  );

  late final primaryActionLabel = computed(() {
    final remaining = remainingDrillCardCount.value;
    if (remaining > 0) return 'Continue Next Batch ($remaining)';
    return 'Review Now';
  });

  late final primaryActionTooltip = computed(() {
    if (canContinueNextBatch.value) {
      return 'Study the next batch of new cards in this deck.';
    }

    return 'Start spaced repetition for the cards you just drilled.';
  });

  late final backButtonLabel = computed(() {
    return 'Done';
  });

  late final backButtonVariants = computed(
    () => hasPrimaryAction.value
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

  void primaryAction(BuildContext context) {
    final deckId = completedResults.value?.deckId;

    if (canContinueNextBatch.value && deckId != null) {
      context.push('/drill/$deckId/session');
      return;
    }

    if (!canReviewNow.value) return;
    if (deckId == null) {
      context.push('/review/session');
      return;
    }

    context.push('/review/$deckId/session');
  }

  void dispose() {
    cardAnswers.dispose();
    completedResults.dispose();
    snapshots.dispose();
    availableSessionReviewCards.dispose();
    canReviewNow.dispose();
    remainingDrillCardCount.dispose();
    canContinueNextBatch.dispose();
    hasPrimaryAction.dispose();
    primaryActionLabel.dispose();
    primaryActionTooltip.dispose();
    backButtonLabel.dispose();
    backButtonVariants.dispose();
    totalCards.dispose();
    breakdown.dispose();
  }
}
