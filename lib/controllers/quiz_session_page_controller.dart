// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/quiz_session_page_controller.dart
// PURPOSE: Orchestrates an active quiz session — queue, answer checking,
//          self-rating, FSRS enrolment, streak update
// PROVIDERS: QuizSessionPageController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/repositories/repositories.dart';
import 'package:boo_mondai/services/services.dart';
import 'package:boo_mondai/services/uuid_service.dart';
import 'package:flutter/foundation.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

/// Drives the quiz session page — manages the card queue, answer flow,
/// self-rating, FSRS enrolment on completion, and streak increment.
class QuizSessionPageController extends ChangeNotifier {
  static const int defaultBatchSize = 20;

  // ── private state ──────────────────────────────────────

  QuizSession? _session;
  List<DeckCard> _queue = [];
  int _currentIndex = 0;
  final List<QuizAnswer> _answers = [];
  int _batchSize = defaultBatchSize;
  bool _isComplete = false;
  bool _awaitingRating = false;
  bool _lastAnswerWrong = false;
  bool _isLoading = false;
  String? _error;

  // ── public getters ─────────────────────────────────────

  QuizSession? get session => _session;

  DeckCard? get currentCard =>
      _queue.isNotEmpty && _currentIndex < _queue.length
      ? _queue[_currentIndex]
      : null;

  double get progress => _batchSize == 0 ? 0 : _currentIndex / _batchSize;

  List<QuizAnswer> get answers => List.unmodifiable(_answers);
  bool get isComplete => _isComplete;
  bool get awaitingRating => _awaitingRating;
  bool get lastAnswerWrong => _lastAnswerWrong;
  int get correctCount => _answers.where((a) => a.isCorrect).length;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ── session lifecycle ──────────────────────────────────

  /// Starts a new session for [deckId], shuffling up to [batchSize] cards.
  /// wordScramble and matchMadness question types are excluded in v1.
  Future<void> startSession(
    String deckId, {
    bool previewed = false,
    int? batchSize,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final allCards = Repositories.deckCard.getByDeckId(deckId);

      final eligible = allCards.where((c) {
        return c.questionType != QuestionType.wordScramble &&
            c.questionType != QuestionType.matchMadness;
      }).toList();

      final limit = batchSize ?? defaultBatchSize;
      final batch = (eligible..shuffle()).take(limit).toList();
      _batchSize = batch.length;

      _session = QuizSession(
        id: UuidService.uuid.v4(),
        userId: 'local',
        deckId: deckId,
        previewed: previewed,
        totalQuestions: batch.length,
        correctCount: 0,
        startedAt: DateTime.now(),
      );
      _queue = batch;
      _currentIndex = 0;
      _answers.clear();
      _isComplete = false;
      _awaitingRating = false;
      _lastAnswerWrong = false;
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── answer submission ──────────────────────────────────

  /// Records the user's answer for the current card.
  ///
  /// - Incorrect: requeues the card at the end and advances.
  /// - Correct: sets [awaitingRating] = true and waits for [rateSelfAndAdvance].
  void submitAnswer(String userAnswer, bool isCorrect) {
    final card = currentCard;
    if (card == null || _session == null) return;

    _lastAnswerWrong = !isCorrect;

    _answers.add(
      QuizAnswer(
        id: UuidService.uuid.v4(),
        sessionId: _session!.id,
        cardId: card.id,
        userAnswer: userAnswer,
        isCorrect: isCorrect,
        answeredAt: DateTime.now(),
      ),
    );

    if (!isCorrect) {
      _queue = [..._queue, card];
      _currentIndex++;
      notifyListeners();
    } else {
      _awaitingRating = true;
      notifyListeners();
    }
  }

  /// For flashcard and matchMadness: skips answer checking and transitions
  /// directly to the self-rating phase.
  void revealAnswer() {
    if (currentCard == null || _session == null) return;
    _awaitingRating = true;
    _lastAnswerWrong = false;
    notifyListeners();
  }

  /// Processes the user's self-rating (1=Again, 2=Hard, 3=Good, 4=Easy).
  ///
  /// Must only be called when [awaitingRating] is true. Rating 1 requeues
  /// the card; ratings 2–4 advance normally.
  Future<void> rateSelfAndAdvance(int rating) async {
    if (!_awaitingRating || _session == null) return;

    // Attach self-rating to the last recorded answer.
    if (_answers.isNotEmpty) {
      final last = _answers.last;
      _answers[_answers.length - 1] = last.copyWith(selfRating: rating);
    }

    if (rating == 1) {
      final card = currentCard;
      if (card != null) {
        _queue = [..._queue, card];
      }
    }

    _currentIndex++;
    _awaitingRating = false;

    if (_currentIndex >= _queue.length) {
      await _completeSession();
    } else {
      notifyListeners();
    }
  }

  // ── session completion ─────────────────────────────────

  Future<void> _completeSession() async {
    if (_session == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _session = _session!.copyWith(
        completedAt: DateTime.now(),
        correctCount: correctCount,
      );
      _isComplete = true;

      await Repositories.quizSession.save(_session!);
      await Repositories.quizSession.saveAnswers(_answers);

      // Enroll correctly-rated cards (rating 2/3/4) into FSRS.
      final ratedAnswers = _answers.where(
        (a) => a.isCorrect && (a.selfRating ?? 0) >= 2,
      );
      for (final answer in ratedAnswers) {
        final fsrsCard = await FsrsCard.create(answer.cardId);
        Services.fsrs.enrollCard(
          card: fsrsCard,
          rating: fsrs.Rating.values[answer.selfRating!],
        );
      }

      await Repositories.streak.incrementStreak('local', DateTime.now());
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── cleanup ────────────────────────────────────────────

  void reset() {
    _session = null;
    _queue = [];
    _currentIndex = 0;
    _answers.clear();
    _batchSize = defaultBatchSize;
    _isComplete = false;
    _awaitingRating = false;
    _lastAnswerWrong = false;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
