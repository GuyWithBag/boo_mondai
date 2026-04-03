// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/quiz_session_page_controller.dart
// PURPOSE: Orchestrates an active quiz session using the new architecture
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:boo_mondai/services/quiz_service.dart';
import 'package:flutter/foundation.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

class QuizSessionPageController extends ChangeNotifier {
  static const int defaultBatchSize = 20;

  // ── private state ──────────────────────────────────────

  QuizSession? _session;
  List<ReviewCard> _queue = [];
  Map<String, CardTemplate> _templates = {};

  // NEW: A simple local list replaces the TempQuizAnswerRepository
  final List<QuizAnswer> _currentAnswers = [];

  int _currentIndex = 0;
  final Map<String, int> _strikes = {};
  final Map<QuizAnswerType, String> _nextIntervals = {};

  int _batchSize = defaultBatchSize;
  bool _isComplete = false;
  String? _error;

  // ── public getters ─────────────────────────────────────

  QuizSession? get session => _session;

  ReviewCard? get currentReviewCard =>
      _queue.isNotEmpty && _currentIndex < _queue.length
      ? _queue[_currentIndex]
      : null;

  CardTemplate? get currentTemplate => currentReviewCard != null
      ? _templates[currentReviewCard!.templateId]
      : null;

  double get progress =>
      _batchSize == 0 ? 0 : (_currentIndex / _batchSize).clamp(0.0, 1.0);

  // Directly expose the local list
  List<QuizAnswer> get answers => List.unmodifiable(_currentAnswers);

  bool get isComplete => _isComplete;

  // Replaced TempRepo logic with direct list checks
  bool get lastAnswerWrong {
    if (_currentAnswers.isEmpty) return false;
    final lastType = _currentAnswers.last.type;
    return lastType == QuizAnswerType.incorrect ||
        lastType == QuizAnswerType.again;
  }

  // Replaced TempRepo logic with direct list filtering
  int get correctCount {
    return _currentAnswers.where((a) {
      return a.type != QuizAnswerType.incorrect &&
          a.type != QuizAnswerType.again;
    }).length;
  }

  String? get error => _error;

  // ── Anki & Strike getters ──────────────────────────────

  int get currentCardStrikeCount =>
      currentReviewCard != null ? (_strikes[currentReviewCard!.id] ?? 0) : 0;

  int get newCount =>
      _queue.toSet().where((c) => !_strikes.containsKey(c.id)).length;

  int get learningCount =>
      _queue.toSet().where((c) => _strikes.containsKey(c.id)).length;

  int get reviewCount => 0;

  Map<QuizAnswerType, String> get nextIntervals => _nextIntervals;

  // ── session lifecycle ──────────────────────────────────

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // PATH: lib/controllers/quiz_session_page_controller.dart
  // (Replace your existing startSession method with this)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  void startSession(String deckId, {bool previewed = false, int? batchSize}) {
    _error = null;
    _currentAnswers.clear();

    try {
      final userId = Services.auth.currentUser!.id;

      // 1. Fetch all templates and review cards for this deck
      final allTemplates = Repositories.cardTemplate.getByDeckId(deckId);
      _templates = {for (final t in allTemplates) t.id: t};
      final allReviewCards = Repositories.reviewCard.getByDeckId(deckId);

      // 2. NEW: Fetch all FSRS cards for this user to see what they've already studied
      // Assuming you have a standard Hive getAll() or getByUserId() on your fsrsCard repo
      // final enrolledReviewCardIds = Repositories.fsrsCard
      //     .getEnrolledReviewCardIds(userId);

      // 3. Filter the eligible cards
      final eligibleCards = QuizService.getEligibleQuizCards(deckId, userId);

      // 4. Throw an error if they've finished the deck!
      if (eligibleCards.isEmpty) {
        throw Exception(
          allReviewCards.isEmpty
              ? 'No reviewable cards found in this deck.'
              : 'You have already quizzed all the cards in this deck! Head to FSRS Reviews to practice them.',
        );
      }

      final limit = batchSize ?? defaultBatchSize;
      final batch = (eligibleCards..shuffle()).take(limit).toList();
      _batchSize = batch.length;

      _session = QuizSession(
        id: UuidService.uuid.v4(),
        userId: userId,
        deckId: deckId,
        previewed: previewed,
        totalQuestions: batch.length,
        correctCount: 0,
        startedAt: DateTime.now(),
      );

      _queue = batch;
      _currentIndex = 0;
      _strikes.clear();
      _nextIntervals.clear();
      _isComplete = false;
    } on Exception catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  // ── answer submission ──────────────────────────────────

  Future<void> submitAnswer(String userAnswer, QuizAnswerType type) async {
    final reviewCard = currentReviewCard;
    if (reviewCard == null || _session == null) return;

    _strikes[reviewCard.id] = (_strikes[reviewCard.id] ?? 0) + 1;

    final newAnswer = QuizAnswer.create(
      sessionId: _session!.id,
      cardId: reviewCard.id,
      userAnswer: userAnswer,
      type: type,
    );

    // Add directly to local list
    _currentAnswers.add(newAnswer);

    if (type == QuizAnswerType.incorrect) {
      _queue.add(reviewCard);
    }

    _currentIndex++;
    _nextIntervals.clear();

    if (_currentIndex >= _queue.length) {
      await _completeSession();
    } else {
      notifyListeners();
    }
  }

  // ── interval forecasting ───────────────────────────────

  Future<void> calculateNextIntervals(String reviewCardId) async {
    _nextIntervals.clear();

    final scheduler = fsrs.Scheduler();
    final fsrsCard = await fsrs.Card.create();
    final now = DateTime.now();

    final again = scheduler.reviewCard(fsrsCard, fsrs.Rating.again);
    final hard = scheduler.reviewCard(fsrsCard, fsrs.Rating.hard);
    final good = scheduler.reviewCard(fsrsCard, fsrs.Rating.good);
    final easy = scheduler.reviewCard(fsrsCard, fsrs.Rating.easy);

    _nextIntervals[QuizAnswerType.again] = _formatInterval(now, again.card.due);
    _nextIntervals[QuizAnswerType.hard] = _formatInterval(now, hard.card.due);
    _nextIntervals[QuizAnswerType.good] = _formatInterval(now, good.card.due);
    _nextIntervals[QuizAnswerType.easy] = _formatInterval(now, easy.card.due);

    notifyListeners();
  }

  String _formatInterval(DateTime now, DateTime nextReview) {
    final diff = nextReview.difference(now);
    if (diff.inMinutes < 1) return '< 1m';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';

    final days = diff.inDays;
    if (days < 30) return '${days}d';
    if (days < 365) {
      final months = (days / 30).toStringAsFixed(1);
      return '${months.endsWith('.0') ? months.substring(0, months.length - 2) : months}mo';
    }

    final years = (days / 365).toStringAsFixed(1);
    return '${years.endsWith('.0') ? years.substring(0, years.length - 2) : years}y';
  }

  // ── session completion ─────────────────────────────────

  Future<void> _completeSession() async {
    if (_session == null) return;

    try {
      _session = _session!.copyWith(
        completedAt: DateTime.now(),
        correctCount: correctCount,
      );
      _isComplete = true;

      // Save directly from the local list to the permanent Hive box
      await Repositories.quizSession.save(_session!);
      await Repositories.quizAnswer.saveAll(
        _currentAnswers,
      ); // Use the new repo!

      final fsrsEligibleAnswers = _currentAnswers.where(
        (a) => a.type != QuizAnswerType.incorrect,
      );

      for (final answer in fsrsEligibleAnswers) {
        final fsrsCard = await FsrsCard.create(
          reviewCardId: answer.cardId,
          userId: _session!.userId,
        );

        Services.fsrs.enrollCard(
          card: fsrsCard,
          rating: _mapToFsrsRating(answer.type),
        );
      }
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  fsrs.Rating _mapToFsrsRating(QuizAnswerType type) {
    switch (type) {
      case QuizAnswerType.again:
        return fsrs.Rating.again;
      case QuizAnswerType.hard:
        return fsrs.Rating.hard;
      case QuizAnswerType.good:
        return fsrs.Rating.good;
      case QuizAnswerType.easy:
        return fsrs.Rating.easy;
      case QuizAnswerType.incorrect:
        return fsrs.Rating.again;
    }
  }

  // ── cleanup ────────────────────────────────────────────

  void reset() {
    _session = null;
    _queue = [];
    _templates.clear();
    _currentAnswers.clear(); // Clear the local list
    _currentIndex = 0;
    _strikes.clear();
    _nextIntervals.clear();
    _batchSize = defaultBatchSize;
    _isComplete = false;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
