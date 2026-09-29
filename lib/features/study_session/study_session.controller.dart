import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        DrillStudySessionHelper,
        DueFilterThreshold,
        DueFilterExtension,
        FsrsCard,
        FsrsHelper,
        FsrsReviewLog,
        LocalDB,
        NotificationsController,
        Services,
        SessionException,
        SessionMode,
        StudyCard,
        StudySessionAnswer,
        StudyRating,
        StudySessionHelper,
        uuid,
        StudySession,
        StudySessionConfig,
        StudySessionSnapshot,
        StudySessionRule,
        StudySessionStep,
        StudySessionCardStep,
        StudySessionMessageStep,
        StudySessionRules;

import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:signals/signals_flutter.dart';

final class StudySessionController {
  StudySessionController({required this.config, this.notificationsController});

  final StudySessionConfig config;
  final NotificationsController? notificationsController;
  final session = signal<StudySession?>(null);
  final error = signal<Exception?>(null);
  final isLoading = signal(false);
  final isSubmitting = signal(false);
  final cards = signal(<String, StudyCard>{});
  final templates = signal(<String, CardTemplate>{});
  final fsrsCards = signal(<String, FsrsCard>{});

  SessionMode get mode => config.mode;

  late final currentStep = computed<StudySessionStep?>(
    () => session.value?.currentStep,
  );
  late final currentCardStep = computed<StudySessionCardStep?>(() {
    final step = currentStep.value;
    return step is StudySessionCardStep ? step : null;
  });

  late final isFinished = computed(() => session.value?.isFinished);

  late final currentStepIndex = computed(
    () => session.value?.currentIndex ?? 0,
  );
  late final totalStepCount = computed(() => session.value?.steps.length ?? 0);
  late final isComplete = computed(() => session.value?.isSaved ?? false);
  late final currentStudyCard = computed<StudyCard?>(() {
    final step = currentCardStep.value;
    return step == null ? null : cards.value[step.studyCardId];
  });
  late final currentTemplate = computed<CardTemplate?>(() {
    final card = currentStudyCard.value;
    return card == null ? null : templates.value[card.templateId];
  });
  late final currentFsrsCard = computed<FsrsCard?>(() {
    final step = currentCardStep.value;
    return step == null ? null : fsrsCards.value[step.studyCardId];
  });
  late final nextIntervals = computed<Map<StudyRating, String>>(() {
    final state =
        currentFsrsCard.value?.state ??
        fsrs.Card(cardId: DateTime.now().millisecondsSinceEpoch);
    return StudySessionHelper.generateIntervalsForState(state);
  });

  late final stepProgressPercentage = computed(() {
    final total = totalStepCount.value;
    if (total == 0) return 0.0;
    return ((currentStepIndex.value + 1) / total).clamp(0.0, 1.0);
  });

  Future<void> startSession({
    String? deckId,
    DueFilterThreshold? filter,
    int batchSize = 20,
  }) async {
    reset();
    isLoading.value = true;
    try {
      final profileId = LocalDB.currentProfile.getOrCreate().id;
      final now = DateTime.now();
      final selected = <StudyCard>[];
      if (mode == SessionMode.drill) {
        if (deckId == null) {
          throw SessionException(
            'A deck is required for drill.',
            code: 'DRILL_DECK_MISSING',
          );
        }
        selected.addAll(
          (DrillStudySessionHelper.getEligibleDrillCards(
            deckId,
            profileId,
          )..shuffle()).take(batchSize),
        );
        if (selected.isEmpty) {
          throw SessionException(
            'No eligible cards in this deck.',
            code: 'DRILL_NO_ELIGIBLE_CARDS',
          );
        }
      } else {
        if (filter == null) {
          throw SessionException(
            'A due filter is required.',
            code: 'REVIEW_FILTER_MISSING',
          );
        }
        final available = LocalDB.studyCard.selectMany();
        final byId = {for (final card in available) card.id: card};
        final due = LocalDB.fsrsCard.getByProfileId(profileId).where((
          fsrsCard,
        ) {
          final card = byId[fsrsCard.studyCardId];
          return card != null &&
              (deckId == null || card.deckId == deckId) &&
              filter.isCardDue(fsrsCard.state.due, now);
        }).toList()..shuffle();
        selected.addAll(due.map((card) => byId[card.studyCardId]!));
        fsrsCards.value = {for (final card in due) card.studyCardId: card};
        if (selected.isEmpty) {
          throw SessionException(
            'No cards are due for review.',
            code: 'REVIEW_NO_DUE_CARDS',
          );
        }
      }
      cards.value = {for (final card in selected) card.id: card};
      final allTemplates = deckId == null
          ? LocalDB.cardTemplate.selectMany()
          : LocalDB.cardTemplate.getByDeckId(deckId);
      templates.value = {
        for (final template in allTemplates) template.id: template,
      };
      for (final card in selected) {
        if (!templates.value.containsKey(card.templateId)) {
          throw SessionException(
            'A card template is missing.',
            code: 'SESSION_TEMPLATE_MISSING',
          );
        }
      }
      session.value = StudySession(
        id: uuid.v7(),
        profileId: profileId,
        deckId: deckId,
        mode: mode,
        startedAt: now,
        steps: [
          for (final card in selected)
            StudySessionCardStep(id: uuid.v7(), studyCardId: card.id),
        ],
      );
    } catch (cause, trace) {
      error.value = cause is SessionException
          ? cause
          : SessionException(
              'Failed to start study session.',
              code: 'SESSION_INIT_FAILED',
              originalError: cause,
              stackTrace: trace,
            );
      throw error.value!;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAnswer(
    StudySessionAnswer answer,
    StudyRating rating,
  ) async {
    if (isSubmitting.value) {
      throw SessionException(
        'Submission already in progress.',
        code: 'SESSION_BUSY',
      );
    }
    isSubmitting.value = true;
    try {
      final active = session.value;
      final step = currentCardStep.value;
      final card = currentStudyCard.value;
      final template = currentTemplate.value;
      if (active == null || step == null || card == null || template == null) {
        throw SessionException(
          'No card is active.',
          code: 'SESSION_CARD_MISSING',
        );
      }
      final now = DateTime.now();
      FsrsCard? before = currentFsrsCard.value;
      if (mode == SessionMode.review && before == null) {
        throw SessionException(
          'Review card state is missing.',
          code: 'REVIEW_STATE_MISSING',
        );
      }
      FsrsCard? after;
      FsrsReviewLog? log;
      DateTime? reviewTime;
      if (mode == SessionMode.review ||
          (rating != StudyRating.incorrect && rating != StudyRating.again)) {
        before ??= await FsrsCard.create(
          studyCardId: card.id,
          profileId: active.profileId,
        );
        reviewTime = before.state.due.isAfter(now) ? before.state.due : now;
        final result = fsrs.Scheduler().reviewCard(
          before.state,
          FsrsHelper.studyRatingToFSRSRating(rating),
          reviewDateTime: reviewTime.toUtc(),
        );
        after = before.copyWith(state: result.card);
        log = FsrsReviewLog(
          id: step.id,
          createdAt: now,
          fsrsCardId: before.id,
          log: result.reviewLog,
        );
      }
      final snapshot = StudySessionSnapshot.card(
        sessionId: active.id,
        sequenceNumber: active.history.length,
        step: step,
        studyCard: card,
        cardTemplate: template,
        answer: answer,
        rating: rating,
        completedAt: now,
        fsrsCardBefore: before,
        fsrsCardAfter: after,
        fsrsReviewLog: log,
      );
      final requeue = _shouldRequeue(
        rating: rating,
        reviewTime: reviewTime,
        fsrsCardAfter: after,
      );
      final attempts = active.steps
          .whereType<StudySessionCardStep>()
          .where((candidate) => candidate.studyCardId == card.id)
          .length;
      _applyStep(
        snapshot,
        StudySessionRules.rules,
        appended: [
          if (requeue)
            StudySessionCardStep(
              id: uuid.v7(),
              studyCardId: card.id,
              attemptNumber: attempts + 1,
              insertionReason: 'Incorrect answer',
            ),
        ],
      );
      if (after != null) fsrsCards.value = {...fsrsCards.value, card.id: after};
      if (session.value!.isFinished) await completeSession();
    } catch (cause, trace) {
      error.value = cause is SessionException
          ? cause
          : SessionException(
              'Could not submit answer.',
              code: 'SESSION_SUBMIT_FAILED',
              originalError: cause,
              stackTrace: trace,
            );
      throw error.value!;
    } finally {
      isSubmitting.value = false;
    }
  }

  bool _shouldRequeue({
    required StudyRating rating,
    required DateTime? reviewTime,
    required FsrsCard? fsrsCardAfter,
  }) {
    if (rating == StudyRating.incorrect && config.requeueIncorrectAnswers) {
      return true;
    }

    if (rating != StudyRating.again) {
      return false;
    }

    if (config.requeueIncorrectAnswers) {
      return true;
    }

    final threshold = config.requeueAgainWhenIntervalLessThan;
    if (threshold == null || reviewTime == null || fsrsCardAfter == null) {
      return false;
    }

    return fsrsCardAfter.state.due.difference(reviewTime) < threshold;
  }

  Future<void> advancePresentationStep() async {
    final active = session.value;
    final step = currentStep.value;
    if (active == null || step is! StudySessionMessageStep) {
      throw SessionException(
        'No message step is active.',
        code: 'SESSION_MESSAGE_MISSING',
      );
    }
    _applyStep(
      StudySessionSnapshot.message(
        sessionId: active.id,
        sequenceNumber: active.history.length,
        step: step,
        completedAt: DateTime.now(),
      ),
      const [],
    );
    if (session.value!.isFinished) await completeSession();
  }

  /// Validates that [snapshot] answers the currently active step, then
  /// produces the next [StudySession] value: appends the snapshot to
  /// history, runs [rules] against the updated history to decide which
  /// steps (if any) to insert, appends [appended], and advances
  /// `currentIndex`. Replaces `session.value` only once the whole
  /// transition has succeeded, so a failed transition leaves the
  /// current session untouched.
  void _applyStep(
    StudySessionSnapshot snapshot,
    List<StudySessionRule> rules, {
    List<StudySessionStep> appended = const [],
  }) {
    final active = session.value;
    final current = active?.currentStep;

    final hasActiveSession = active != null && !active.isSaved;
    final hasCurrentStep = current != null;
    final matchesCurrentStep =
        hasActiveSession &&
        hasCurrentStep &&
        current.id == snapshot.step.id &&
        snapshot.sessionId == active.id &&
        snapshot.sequenceNumber == active.history.length;

    final hasCardAnswer =
        current is! StudySessionCardStep ||
        (snapshot.rating != null && snapshot.answer != null);
    final hasMessageAnswer =
        current is! StudySessionMessageStep ||
        (snapshot.rating == null && snapshot.answer == null);
    final hasReviewState =
        current is! StudySessionCardStep ||
        mode != SessionMode.review ||
        (snapshot.fsrsCardBefore != null &&
            snapshot.fsrsCardAfter != null &&
            snapshot.fsrsReviewLog != null);

    if (!hasActiveSession ||
        !hasCurrentStep ||
        !matchesCurrentStep ||
        !hasCardAnswer ||
        !hasMessageAnswer ||
        !hasReviewState) {
      throw SessionException(
        'The active step has changed.',
        code: 'SESSION_STEP_INVALID',
      );
    }

    // Rules see the history *including* this snapshot, matching the
    // original behaviour where history was mutated before rules ran.
    final withHistory = active.copyWith(
      history: List.unmodifiable([...active.history, snapshot]),
    );

    final inserted = <StudySessionStep>[
      if (snapshot.step is StudySessionCardStep)
        for (final rule in rules)
          if (rule.when(withHistory)) rule.build(withHistory),
    ];

    final existingIds = withHistory.steps.map((step) => step.id).toSet();
    for (final step in [...inserted, ...appended]) {
      if (!existingIds.add(step.id)) {
        throw SessionException(
          'Duplicate session step.',
          code: 'SESSION_DUPLICATE_STEP',
        );
      }
    }

    final nextSteps = [...withHistory.steps];
    nextSteps.insertAll(withHistory.currentIndex + 1, inserted);
    nextSteps.addAll(appended);

    session.value = withHistory.copyWith(
      steps: List.unmodifiable(nextSteps),
      currentIndex: withHistory.currentIndex + 1,
    );
  }

  Future<void> completeSession() async {
    final active = session.value;
    if (active == null || !active.isFinished) {
      throw SessionException(
        'Session is not finished.',
        code: 'SESSION_NOT_FINISHED',
      );
    }
    if (active.isSaved) return;
    try {
      final results = active.completedResults;
      for (final log in results.fsrsLogs) {
        await LocalDB.reviewLogs.upsert(log);
      }
      for (final card in results.fsrsCards) {
        await LocalDB.fsrsCard.upsert(card);
      }
      for (final snapshot in active.history) {
        await LocalDB.studySessionSnapshot.upsert(snapshot);
      }
      session.value = active.copyWith(isSaved: true);
      error.value = null;
    } catch (cause, trace) {
      error.value = cause is SessionException
          ? cause
          : SessionException(
              'Could not save completed session.',
              code: 'SESSION_SAVE_FAILED',
              originalError: cause,
              stackTrace: trace,
            );
      throw error.value!;
    }
    if (mode == SessionMode.review) {
      await Services.streak.refreshFromReviewLogs();
    }
  }

  void reset() {
    session.value = null;
    cards.value = {};
    templates.value = {};
    fsrsCards.value = {};
    error.value = null;
  }

  void dispose() {
    reset();
    session.dispose();
    error.dispose();
    isLoading.dispose();
    isSubmitting.dispose();
    nextIntervals.dispose();
    cards.dispose();
    templates.dispose();
    fsrsCards.dispose();
    currentStep.dispose();
    currentCardStep.dispose();
    currentStepIndex.dispose();
    totalStepCount.dispose();
    isComplete.dispose();
    currentStudyCard.dispose();
    currentTemplate.dispose();
    currentFsrsCard.dispose();
    stepProgressPercentage.dispose();
  }
}
