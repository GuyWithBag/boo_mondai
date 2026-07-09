import 'dart:async';

import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/cupertino.dart' show protected;
import 'package:flutter_hooks/flutter_hooks.dart'
    show useEffect, useListenable, useMemoized;

ReviewSessionController useReviewSessionController({
  required String? deckId,
  required DueFilterThreshold filter,
}) {
  final controller = useMemoized(ReviewSessionController.new);
  useListenable(controller);
  useEffect(() {
    unawaited(controller.startSession(deckId: deckId, filter: filter));
    return controller.dispose;
  }, [controller, deckId, filter]);
  return controller;
}

final class ReviewSessionController
    extends StudySessionController<ReviewSession> {
  final Map<String, StudyCard> _studyCards = {};
  final Map<String, FsrsCard> _fsrsCards = {};
  final List<StudyRating> _ratings = [];

  @override
  SessionMode get mode => SessionMode.review;

  @override
  List<StudyRating> get submittedRatings => List.unmodifiable(_ratings);

  @override
  StudyCard? get currentStudyCard {
    final step = currentCardStep;
    return step == null ? null : _studyCards[step.studyCardId];
  }

  FsrsCard? get currentFsrsCard {
    final step = currentCardStep;
    return step == null ? null : _fsrsCards[step.studyCardId];
  }

  int get remainingCount {
    final activeRuntime = runtime;
    if (activeRuntime == null) return 0;
    return activeRuntime.snapshot.steps
        .skip(activeRuntime.currentStepIndex)
        .whereType<CardSessionStep>()
        .length;
  }

  Future<void> startSession({
    String? deckId,
    required DueFilterThreshold filter,
  }) async {
    reset(notify: false);
    try {
      final userId = LocalDB.profile.getOrCreate().id;
      final resumable = LocalDB.reviewSession.selectMany(
        where: (value) =>
            value.userId == userId &&
            value.deckId == deckId &&
            !value.isComplete,
      );
      if (resumable.isNotEmpty && restoreFlow(resumable.last.id)) {
        session = resumable.last;
        _loadReferencedCards();
        _ratings.addAll(
          LocalDB.studySessionStepRecord
              .getBySessionId(session!.id)
              .map((record) => record.rating),
        );
        final pending = runtime!.snapshot.pendingSubmission;
        if (pending != null) {
          await submitAnswer(pending.userAnswer, pending.rating);
        }
        notifyListeners();
        return;
      }

      final now = DateTime.now();
      final studyCards = LocalDB.studyCard.selectMany();
      _studyCards.addEntries(studyCards.map((card) => MapEntry(card.id, card)));
      templates = {
        for (final template in LocalDB.cardTemplate.selectMany())
          template.id: template,
      };
      final cardDecks = {for (final card in studyCards) card.id: card.deckId};
      final dueCards =
          LocalDB.fsrsCard
              .getByUserId(userId)
              .where(
                (card) =>
                    (deckId == null || cardDecks[card.studyCardId] == deckId) &&
                    filter.isCardDue(card.state.due, now),
              )
              .toList()
            ..shuffle();
      _fsrsCards.addEntries(
        dueCards.map((card) => MapEntry(card.studyCardId, card)),
      );
      final cards = dueCards
          .map((card) => _studyCards[card.studyCardId])
          .whereType<StudyCard>()
          .toList();
      session = ReviewSession(
        id: uuid.v7(),
        userId: userId,
        deckId: deckId,
        totalCards: cards.length,
        startedAt: now,
      );
      await LocalDB.reviewSession.upsert(session!);
      await createFlow(sessionId: session!.id, cards: cards, now: now);
      if (isComplete) await completeSession();
      notifyListeners();
    } catch (error, stackTrace) {
      setError(
        error is SessionException
            ? error
            : SessionException(
                'Failed to start review session.',
                code: 'REVIEW_INIT_FAILED',
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
    _studyCards.addEntries(cards.map((card) => MapEntry(card.id, card)));
    final fsrsCards = LocalDB.fsrsCard.selectMany(
      where: (card) => ids.contains(card.studyCardId),
    );
    _fsrsCards.addEntries(
      fsrsCards.map((card) => MapEntry(card.studyCardId, card)),
    );
    templates = {
      for (final template in LocalDB.cardTemplate.selectMany())
        template.id: template,
    };
  }

  @override
  Future<void> calculateNextIntervals() async {
    final card = currentFsrsCard;
    if (card == null) return;
    nextIntervals = StudySessionHelper.generateIntervalsForState(card.state);
    notifyListeners();
  }

  @override
  Future<void> submitAnswer(String userAnswer, StudyRating rating) async {
    final card = currentStudyCard;
    final fsrsCard = currentFsrsCard;
    final step = currentCardStep;
    final activeSession = session;
    if (card == null ||
        fsrsCard == null ||
        step == null ||
        activeSession == null) {
      failSession('No review card is active.', code: 'REVIEW_CARD_MISSING');
    }

    final now = DateTime.now();
    await beginSubmission(userAnswer, rating, now);
    final wasRecorded =
        LocalDB.studySessionStepRecord.getByStepId(activeSession.id, step.id) !=
        null;
    final outcome = await ReviewSessionPolicy.processSubmission(
      session: activeSession,
      step: step,
      card: card,
      fsrsCard: fsrsCard,
      userAnswer: userAnswer,
      rating: rating,
      sequenceNumber: currentIndex,
      now: now,
    );
    _fsrsCards[card.id] = outcome.updatedCard;
    await finishSubmission(
      rating: rating,
      startedAt: activeSession.startedAt,
      policyCommands: outcome.commands,
      now: now,
    );
    if (!wasRecorded) {
      _ratings.add(rating);
    }
    session = activeSession.copyWith(
      cardsReviewed: activeSession.cardsReviewed + 1,
      totalCards: runtime!.snapshot.steps.whereType<CardSessionStep>().length,
    );
    await LocalDB.reviewSession.upsert(session!);
    await Services.streak.refreshFromReviewLogs();
    nextIntervals.clear();
    if (isComplete) {
      await completeSession();
    } else {
      notifyListeners();
    }
  }

  @override
  @protected
  Future<void> completeSession() async {
    final activeSession = session;
    if (activeSession == null) return;
    session = activeSession.copyWith(completedAt: DateTime.now());
    await LocalDB.reviewSession.upsert(session!);
    notifyListeners();
  }

  @override
  void reset({bool notify = true}) {
    session = null;
    runtime = null;
    templates.clear();
    _studyCards.clear();
    _fsrsCards.clear();
    _ratings.clear();
    nextIntervals.clear();
    setError(null);
    if (notify) notifyListeners();
  }
}
