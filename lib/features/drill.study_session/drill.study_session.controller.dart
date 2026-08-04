import 'dart:async';

import 'package:boo_mondai/lib.barrel.dart'
    show
        DrillAnswer,
        DrillSession,
        DrillSessionPolicy,
        CardSessionStep,
        LocalDB,
        FirstDrillSurvey,
        Notifications,
        NotificationsController,
        SessionException,
        SessionMode,
        StudyCard,
        StudyRating,
        StudySessionController,
        StudySessionHelper,
        uuid;
import 'package:flutter/material.dart' show protected;
import 'package:flutter_hooks/flutter_hooks.dart'
    show useEffect, useListenable, useMemoized;
import 'package:fsrs/fsrs.dart' as fsrs;

DrillSessionController useDrillSessionController({
  required String deckId,
  NotificationsController? notificationsController,
  bool previewed = false,
  int? batchSize,
}) {
  final controller = useMemoized(
    () => DrillSessionController(notificationsController),
    [notificationsController],
  );
  useListenable(controller);
  useEffect(() {
    unawaited(
      controller.startSession(
        deckId,
        previewed: previewed,
        batchSize: batchSize,
      ),
    );
    return controller.dispose;
  }, [controller, deckId, previewed, batchSize]);
  return controller;
}

final class DrillSessionController
    extends StudySessionController<DrillSession> {
  DrillSessionController([this._notificationsController]);

  static const int defaultBatchSize = 20;

  final NotificationsController? _notificationsController;
  final Map<String, StudyCard> _cards = {};
  final List<DrillAnswer> _answers = [];

  @override
  SessionMode get mode => SessionMode.drill;

  @override
  StudyCard? get currentStudyCard {
    final step = currentCardStep;
    return step == null ? null : _cards[step.studyCardId];
  }

  List<DrillAnswer> get answers => List.unmodifiable(_answers);

  @override
  List<StudyRating> get submittedRatings => [
    for (final answer in _answers) answer.type,
  ];

  int get correctCount => _answers
      .where(
        (answer) =>
            answer.type != StudyRating.incorrect &&
            answer.type != StudyRating.again,
      )
      .length;

  Future<void> startSession(
    String deckId, {
    bool previewed = false,
    int? batchSize,
  }) async {
    reset(notify: false);
    try {
      final profileId = LocalDB.profile.getOrCreate().id;
      final resumable = LocalDB.drillSession.selectMany(
        where: (value) =>
            value.profileId == profileId &&
            value.deckId == deckId &&
            !value.isComplete,
      );
      if (resumable.isNotEmpty && restoreFlow(resumable.last.id)) {
        session = resumable.last;
        _loadReferencedCards();
        _answers.addAll(LocalDB.drillAnswer.getBySessionId(session!.id));
        final pending = runtime!.snapshot.pendingSubmission;
        if (pending != null) {
          await submitAnswer(pending.userAnswer, pending.rating);
        }
        notifyListeners();
        return;
      }

      templates = {
        for (final template in LocalDB.cardTemplate.getByDeckId(deckId))
          template.id: template,
      };
      final allCards = LocalDB.studyCard.getByDeckId(deckId);
      final eligible = DrillSessionPolicy.selectCards(
        deckId: deckId,
        profileId: profileId,
        limit: batchSize ?? defaultBatchSize,
      );
      if (eligible.isEmpty) {
        throw SessionException(
          allCards.isEmpty
              ? 'No reviewable cards found in this deck.'
              : 'All cards in this deck are already enrolled in review.',
          code: 'DRILL_NO_ELIGIBLE_CARDS',
        );
      }

      final cards = eligible;
      _cards.addEntries(cards.map((card) => MapEntry(card.id, card)));
      final now = DateTime.now();
      session = DrillSession(
        id: uuid.v7(),
        profileId: profileId,
        deckId: deckId,
        previewed: previewed,
        totalQuestions: cards.length,
        startedAt: now,
      );
      await LocalDB.drillSession.upsert(session!);
      await createFlow(sessionId: session!.id, cards: cards, now: now);
      notifyListeners();
    } catch (error, stackTrace) {
      setError(
        error is SessionException
            ? error
            : SessionException(
                'Failed to start drill session.',
                code: 'DRILL_INIT_FAILED',
                originalError: error,
                stackTrace: stackTrace,
              ),
      );
    }
  }

  void _loadReferencedCards() {
    final ids = runtime!.snapshot.steps
        .whereType<CardSessionStep>()
        .map((step) => step.studyCardId)
        .toSet();
    final cards = LocalDB.studyCard.selectMany(
      where: (card) => ids.contains(card.id),
    );
    _cards.addEntries(cards.map((card) => MapEntry(card.id, card)));
    templates = {
      for (final template in LocalDB.cardTemplate.selectMany())
        template.id: template,
    };
  }

  @override
  Future<void> submitAnswer(String userAnswer, StudyRating rating) async {
    final card = currentStudyCard;
    final step = currentCardStep;
    final activeSession = session;
    if (card == null || step == null || activeSession == null) {
      failSession('No drill card is active.', code: 'DRILL_CARD_MISSING');
    }

    final now = DateTime.now();
    await beginSubmission(userAnswer, rating, now);
    final outcome = await DrillSessionPolicy.processSubmission(
      session: activeSession,
      step: step,
      card: card,
      userAnswer: userAnswer,
      rating: rating,
      sequenceNumber: currentIndex,
      now: now,
    );
    await finishSubmission(
      rating: rating,
      startedAt: activeSession.startedAt,
      policyCommands: outcome.commands,
      now: now,
    );
    if (!_answers.any((answer) => answer.id == outcome.answer.id)) {
      _answers.add(outcome.answer);
    }
    session = activeSession.copyWith(
      correctCount: correctCount,
      totalQuestions: runtime!.snapshot.steps
          .whereType<CardSessionStep>()
          .length,
    );
    await LocalDB.drillSession.upsert(session!);
    nextIntervals.clear();
    if (isComplete) {
      await completeSession();
    } else {
      notifyListeners();
    }
  }

  @override
  Future<void> calculateNextIntervals() async {
    final state = await fsrs.Card.create();
    nextIntervals = StudySessionHelper.generateIntervalsForState(state);
    notifyListeners();
  }

  @override
  @protected
  Future<void> completeSession() async {
    final activeSession = session;
    if (activeSession == null) return;
    session = activeSession.copyWith(
      completedAt: DateTime.now(),
      correctCount: correctCount,
    );
    await LocalDB.drillSession.upsert(session!);
    await _notifyFirstDrillSurveyIfNeeded(session!);
    notifyListeners();
  }

  Future<void> _notifyFirstDrillSurveyIfNeeded(DrillSession completed) async {
    final notificationsController = _notificationsController;
    if (notificationsController == null || completed.previewed) return;

    final completedDrills = LocalDB.drillSession.selectMany(
      where: (session) =>
          session.profileId == completed.profileId &&
          session.completedAt != null &&
          !session.previewed,
    );
    if (completedDrills.length != 1) return;

    await notificationsController.notify(
      Notifications.firstDrillSurvey(surveyId: FirstDrillSurvey.id),
    );
  }

  @override
  void reset({bool notify = true}) {
    session = null;
    runtime = null;
    templates.clear();
    _cards.clear();
    _answers.clear();
    nextIntervals.clear();
    setError(null);
    if (notify) notifyListeners();
  }
}
