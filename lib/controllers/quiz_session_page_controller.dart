// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/quiz_session_page_controller.dart
// PURPOSE: Orchestrates an active quiz session — queue management, answer
//          submission, FSRS enrolment, and streak updates
// PROVIDERS: QuizSessionPageController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/deck_card.dart';
import '../models/question_type.dart';
import '../models/quiz_session.dart';
import '../models/quiz_answer.dart';
import '../repositories/deck_card_repository.dart';
import '../repositories/quiz_session_repository.dart';
import '../repositories/fsrs_card_state_repository.dart';
import '../repositories/review_log_repository.dart';
import '../repositories/streak_repository.dart';
import '../services/fsrs_service.dart';
import '../shared/env.dart';

/// Drives the Quiz Session page — manages the card queue, answer flow,
/// self-rating, FSRS enrolment on completion, and streak increment.
class QuizSessionPageController extends ChangeNotifier {
  QuizSessionPageController({
    required DeckCardRepository deckCardRepository,
    required QuizSessionRepository quizSessionRepository,
    required FsrsService fsrsService,
    required FsrsCardStateRepository fsrsCardStateRepository,
    required ReviewLogRepository reviewLogRepository,
    required StreakRepository streakRepository,
  })  : _deckCardRepository = deckCardRepository,
        _quizSessionRepository = quizSessionRepository,
        _fsrsService = fsrsService,
        _fsrsCardStateRepository = fsrsCardStateRepository,
        _reviewLogRepository = reviewLogRepository,
        _streakRepository = streakRepository;

  final DeckCardRepository _deckCardRepository;
  final QuizSessionRepository _quizSessionRepository;
  final FsrsService _fsrsService;
  final FsrsCardStateRepository _fsrsCardStateRepository;
  final ReviewLogRepository _reviewLogRepository;
  final StreakRepository _streakRepository;
  static const _uuid = Uuid();

  // ── private state ────────────────────────────────────────

  QuizSession? _session;
  List<DeckCard> _queue = [];
  int _currentIndex = 0;
  List<QuizAnswer> _answers = [];
  int _batchSize = Env.defaultQuizBatchSize;
  bool _isComplete = false;
  bool _awaitingRating = false;
  bool _isLoading = false;
  String? _error;

  // ── public getters ───────────────────────────────────────

  QuizSession? get session => _session;

  /// The card currently being presented, or null when the queue is exhausted.
  DeckCard? get currentCard =>
      _queue.isNotEmpty && _currentIndex < _queue.length
          ? _queue[_currentIndex]
          : null;

  /// Fraction of cards answered relative to the batch size (0.0 – 1.0).
  double get progress =>
      _batchSize == 0 ? 0 : _currentIndex / _batchSize;

  List<QuizAnswer> get answers => List.unmodifiable(_answers);
  bool get isComplete => _isComplete;

  /// True when a correct answer is waiting for the user's self-rating.
  bool get awaitingRating => _awaitingRating;

  int get correctCount => _answers.where((a) => a.isCorrect).length;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ── methods ──────────────────────────────────────────────

  /// Starts a new session for [deckId], shuffling up to [batchSize] cards.
  /// [wordScramble] and [matchMadness] question types are excluded in v1.
  Future<void> startSession(
    String deckId, {
    bool previewed = false,
    int? batchSize,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final allCards = _deckCardRepository.getByDeckId(deckId);

      // Exclude question types not implemented in v1.
      final eligible = allCards.where((c) {
        return c.questionType != QuestionType.wordScramble &&
            c.questionType != QuestionType.matchMadness;
      }).toList();

      final limit = batchSize ?? Env.defaultQuizBatchSize;
      final batch = (eligible..shuffle()).take(limit).toList();
      _batchSize = batch.length;

      _session = QuizSession(
        id: _uuid.v4(),
        userId: 'local',
        deckId: deckId,
        previewed: previewed,
        totalQuestions: batch.length,
        correctCount: 0,
        batchSize: batch.length,
        startedAt: DateTime.now(),
        completedAt: null,
      );
      _queue = batch;
      _currentIndex = 0;
      _answers = [];
      _isComplete = false;
      _awaitingRating = false;
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Records the user's answer for the current card.
  ///
  /// - Incorrect: requeues the card at the end of [_queue] and advances.
  /// - Correct: sets [awaitingRating] = true and waits for [rateSelfAndAdvance].
  void submitAnswer(String userAnswer, bool isCorrect) {
    final card = currentCard;
    if (card == null || _session == null) return;

    final answer = QuizAnswer(
      id: _uuid.v4(),
      sessionId: _session!.id,
      cardId: card.id,
      userAnswer: userAnswer,
      isCorrect: isCorrect,
      selfRating: null,
      answeredAt: DateTime.now(),
    );
    _answers = [..._answers, answer];

    if (!isCorrect) {
      // Requeue the card so the user must answer it again.
      _queue = [..._queue, card];
      _currentIndex++;
      notifyListeners();
    } else {
      // Pause and wait for self-rating before advancing.
      _awaitingRating = true;
      notifyListeners();
    }
  }

  /// Processes the user's self-rating (1=Again, 2=Hard, 3=Good, 4=Easy).
  ///
  /// Must only be called when [awaitingRating] is true (i.e. after a correct
  /// answer). Rating 1 requeues the card; ratings 2–4 advance normally.
  Future<void> rateSelfAndAdvance(int rating) async {
    if (!_awaitingRating || _session == null) return;

    // Attach the self-rating to the last recorded answer.
    if (_answers.isNotEmpty) {
      final last = _answers.last;
      _answers = [
        ..._answers.sublist(0, _answers.length - 1),
        last.copyWith(selfRating: rating),
      ];
    }

    if (rating == 1) {
      // Again — requeue the card and advance.
      final card = currentCard;
      if (card != null) {
        _queue = [..._queue, card];
      }
    }
    // Ratings 2/3/4 simply advance without requeueing.

    _currentIndex++;
    _awaitingRating = false;

    if (_currentIndex >= _queue.length) {
      await completeSession();
    } else {
      notifyListeners();
    }
  }

  /// Finalises the session: persists answers and session, enrolls correctly-
  /// rated cards into FSRS, and increments the streak.
  Future<void> completeSession() async {
    if (_session == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final completedSession = _session!.copyWith(
        completedAt: DateTime.now(),
        correctCount: correctCount,
      );
      _session = completedSession;
      _isComplete = true;

      await _quizSessionRepository.save(completedSession);
      await _quizSessionRepository.saveAnswers(_answers);

      // Enroll correctly rated cards (rating 2/3/4) into FSRS.
      final ratedAnswers = _answers.where(
        (a) => a.isCorrect && (a.selfRating ?? 0) >= 2,
      );
      for (final answer in ratedAnswers) {
        final state = _fsrsService.enrollCard(
          cardId: answer.cardId,
          userId: 'local',
          rating: answer.selfRating!,
        );
        await _fsrsCardStateRepository.save(state);
      }

      await _streakRepository.incrementStreak('local', DateTime.now());
    } on Exception catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Resets all session state. Call this when navigating away from the page.
  void reset() {
    _session = null;
    _queue = [];
    _currentIndex = 0;
    _answers = [];
    _batchSize = Env.defaultQuizBatchSize;
    _isComplete = false;
    _awaitingRating = false;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  /// Clears any active error message and notifies listeners.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
