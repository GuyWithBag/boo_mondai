// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/quiz_provider.dart
// PURPOSE: Manages quiz session — queue, answer checking, self-rating, FSRS enrollment
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:boo_mondai/controllers/controllers.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';

/// Manages the full quiz flow: start → answer → rate → complete → FSRS enroll.
///
/// Local-first: no Supabase writes during the quiz session. All writes
/// (session row + answer rows + FSRS states) are batched in [_completeSession].
class QuizProvider extends ChangeNotifier {
  final SupabaseService _supabaseService;
  final HiveService _hiveService;
  final FsrsService _fsrsService;
  final QuizQueueController _queueController;
  static const _uuid = Uuid();

  QuizProvider({
    required SupabaseService supabaseService,
    required HiveService hiveService,
    required FsrsService fsrsService,
    required QuizQueueController queueController,
  }) : _supabaseService = supabaseService,
       _hiveService = hiveService,
       _fsrsService = fsrsService,
       _queueController = queueController;

  static const _earlyReviewWindow = Duration(hours: 1);

  QuizSession? _session;
  DeckCard? _currentCard;
  final List<QuizAnswer> _answers = [];
  final Set<String> _ejectedCardIds = {};
  final List<FsrsCardState> _enrolledCards = [];
  bool _awaitingRating = false;
  String? _lastUserAnswer;
  bool _isLoading = false;
  String? _error;
  bool _isComplete = false;
  bool _lastAnswerWrong = false;
  bool _showingFirstPassComplete = false;

  /// FSRS state per card in this session: 0=New, 1=Learning, 2=Review, 3=Relearning.
  /// Populated from Hive when the session starts; cards with no entry = 0 (New).
  Map<String, int> _fsrsStates = {};

  QuizSession? get session => _session;
  DeckCard? get currentCard => _currentCard;
  List<QuizAnswer> get answers => List.unmodifiable(_answers);
  Set<String> get ejectedCardIds => Set.unmodifiable(_ejectedCardIds);
  List<FsrsCardState> get enrolledCards => List.unmodifiable(_enrolledCards);

  /// Cards enrolled this session that are due within the next hour — reviewable now.
  int get reviewableNowCount => _enrolledCards.where((fs) {
    final dueIn = fs.due.difference(DateTime.now());
    return dueIn <= _earlyReviewWindow;
  }).length;

  /// Cards enrolled this session due more than an hour away.
  int get reviewLaterCount => _enrolledCards.length - reviewableNowCount;

  int get queueLength => _queueController.length;
  bool get awaitingRating => _awaitingRating;
  bool get isLoading => _isLoading;
  bool get isComplete => _isComplete;
  String? get error => _error;
  bool get lastAnswerWrong => _lastAnswerWrong;
  bool get firstPassComplete => _queueController.firstPassComplete;
  bool get showingFirstPassComplete => _showingFirstPassComplete;

  /// Strike count for the card currently on screen.
  int get currentCardStrikeCount =>
      _currentCard == null ? 0 : _queueController.strikeCount(_currentCard!.id);

  // ── Anki-style FSRS counters ─────────────────────────────────────────────
  /// Cards in this session that have never been reviewed (FSRS state 0).
  int get newCount => _fsrsStates.values.where((s) => s == 0).length;

  /// Cards in this session in the learning or relearning phase (state 1 or 3).
  int get learningCount =>
      _fsrsStates.values.where((s) => s == 1 || s == 3).length;

  /// Cards in this session in the review phase (state 2).
  int get reviewCount => _fsrsStates.values.where((s) => s == 2).length;

  double get progress {
    final total = _queueController.totalCount;
    if (total == 0) return 0;
    return (total - _queueController.length) / total;
  }

  /// Starts a new quiz session entirely in memory.
  /// No Supabase call is made here — the session row is inserted at completion.
  Future<void> startSession(
    String deckId,
    String userId,
    List<DeckCard> cards,
    bool previewed,
  ) async {
    _isLoading = true;
    _error = null;
    _isComplete = false;
    _answers.clear();
    _ejectedCardIds.clear();
    notifyListeners();

    try {
      _queueController.initialize(cards);
      final now = DateTime.now();
      _session = QuizSession(
        id: _uuid.v4(),
        userId: userId,
        deckId: deckId,
        previewed: previewed,
        totalQuestions: cards.length,
        correctCount: 0,
        startedAt: now,
      );

      // Load FSRS states from Hive for the Anki counter.
      // Cards with no entry are treated as New (state 0).
      _fsrsStates = {
        for (final card in cards)
          card.id: _hiveService.getFsrsCard('${userId}_${card.id}')?.state ?? 0,
      };

      _currentCard = _queueController.dequeue();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// For **flashcard** and **matchMadness**: skips answer checking and
  /// transitions directly to the self-rating phase.
  void revealAnswer() {
    if (_currentCard == null || _session == null) return;
    _awaitingRating = true;
    _lastAnswerWrong = false;
    _lastUserAnswer = '';
    notifyListeners();
  }

  /// For **identification**: wrong answer requeues with strike tracking
  /// (3-strike ejection applies). Correct answer transitions to self-rating.
  Future<void> submitIdentificationAnswer(String userAnswer) async {
    if (_currentCard == null || _session == null) return;
    final isCorrect = _currentCard!.checkAnswer(userAnswer);

    if (!isCorrect) {
      _lastAnswerWrong = true;
      final ejected = _queueController.recordWrong(_currentCard!.id);

      if (ejected) {
        _ejectedCardIds.add(_currentCard!.id);
        _answers.add(
          QuizAnswer(
            id: _uuid.v4(),
            sessionId: _session!.id,
            cardId: _currentCard!.id,
            userAnswer: userAnswer,
            isCorrect: false,
            selfRating: 1,
            answeredAt: DateTime.now(),
          ),
        );

        if (_queueController.isEmpty) {
          notifyListeners();
          await _completeSession();
          return;
        }
        _currentCard = _queueController.dequeue();
      } else {
        _queueController.requeue(_currentCard!);
        _currentCard = _queueController.dequeue();
      }
      notifyListeners();
    } else {
      _lastAnswerWrong = false;
      _awaitingRating = true;
      _lastUserAnswer = userAnswer;
      notifyListeners();
    }
  }

  /// For **fillInTheBlanks**: checks every segment answer independently.
  /// All blanks must be correct to advance; any failure requeues with strike
  /// tracking (3-strike ejection applies).
  Future<void> submitFitbAnswers(List<String> answers) async {
    if (_currentCard == null || _session == null) return;
    final segments = _currentCard!.segments;
    final allCorrect =
        answers.length == segments.length &&
        List.generate(
          segments.length,
          (i) => segments[i].checkAnswer(answers[i]),
        ).every((ok) => ok);

    if (!allCorrect) {
      _lastAnswerWrong = true;
      final ejected = _queueController.recordWrong(_currentCard!.id);
      if (ejected) {
        _ejectedCardIds.add(_currentCard!.id);
        _answers.add(
          QuizAnswer(
            id: _uuid.v4(),
            sessionId: _session!.id,
            cardId: _currentCard!.id,
            userAnswer: answers.join('|'),
            isCorrect: false,
            selfRating: 1,
            answeredAt: DateTime.now(),
          ),
        );
        if (_queueController.isEmpty) {
          notifyListeners();
          await _completeSession();
          return;
        }
        _currentCard = _queueController.dequeue();
      } else {
        _queueController.requeue(_currentCard!);
        _currentCard = _queueController.dequeue();
      }
      notifyListeners();
    } else {
      _lastAnswerWrong = false;
      _awaitingRating = true;
      _lastUserAnswer = answers.join(', ');
      notifyListeners();
    }
  }

  /// Checks [userAnswer] against the current card.
  ///
  /// Wrong answer: increments the strike counter. On the third strike the card
  /// is ejected (QuizAnswer recorded with isCorrect=false, selfRating=1) instead
  /// of being requeued. Correct answer: transitions to self-rating state.
  Future<void> submitAnswer(String userAnswer) async {
    if (_currentCard == null) return;

    final isCorrect = _currentCard!.checkAnswer(userAnswer);

    if (!isCorrect) {
      _lastAnswerWrong = true;
      final ejected = _queueController.recordWrong(_currentCard!.id);

      if (ejected) {
        _ejectedCardIds.add(_currentCard!.id);
        _answers.add(
          QuizAnswer(
            id: _uuid.v4(),
            sessionId: _session!.id,
            cardId: _currentCard!.id,
            userAnswer: userAnswer,
            isCorrect: false,
            selfRating: 1,
            answeredAt: DateTime.now(),
          ),
        );

        if (_queueController.isEmpty) {
          notifyListeners();
          await _completeSession();
          return;
        }
        _currentCard = _queueController.dequeue();
      } else {
        _queueController.requeue(_currentCard!);
        _currentCard = _queueController.dequeue();
      }
      notifyListeners();
    } else {
      _lastAnswerWrong = false;
      _awaitingRating = true;
      _lastUserAnswer = userAnswer;
      notifyListeners();
    }
  }

  /// Called after the "Nice try!" intermediate screen is dismissed.
  void acknowledgeFirstPass() {
    _showingFirstPassComplete = false;
    notifyListeners();
  }

  Future<void> submitSelfRating(int rating) async {
    if (_currentCard == null || _session == null) return;

    _awaitingRating = false;

    // All ratings record an answer and advance — Again (1) is not a requeue,
    // it just enrolls the card in FSRS with a low rating so it comes back soon.
    _answers.add(
      QuizAnswer(
        id: _uuid.v4(),
        sessionId: _session!.id,
        cardId: _currentCard!.id,
        userAnswer: _lastUserAnswer ?? '',
        isCorrect: rating != 1,
        selfRating: rating,
        answeredAt: DateTime.now(),
      ),
    );

    if (_queueController.isEmpty) {
      await _completeSession();
    } else {
      final wasFirstPassJustComplete = _queueController.firstPassComplete;
      _currentCard = _queueController.dequeue();
      if (wasFirstPassJustComplete && _queueController.length > 0) {
        _showingFirstPassComplete = true;
      }
      notifyListeners();
    }
  }

  Future<void> _completeSession() async {
    if (_session == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final correctCount = _answers.where((a) => a.isCorrect).length;
      _session = _session!.copyWith(
        completedAt: DateTime.now(),
        correctCount: correctCount,
      );

      // Batch: insert session row + all answers in two round-trips
      await _supabaseService.insertQuizSession({
        'id': _session!.id,
        'user_id': _session!.userId,
        'deck_id': _session!.deckId,
        'previewed': _session!.previewed,
        'total_questions': _session!.totalQuestions,
        'correct_count': correctCount,
        'started_at': _session!.startedAt.toIso8601String(),
        'completed_at': _session!.completedAt!.toIso8601String(),
      });

      if (_answers.isNotEmpty) {
        await _supabaseService.batchInsertQuizAnswers(
          _answers.map((a) => a.toJson()).toList(),
        );
      }

      // Enroll all answered cards in FSRS.
      // Correct cards use their self-rating; ejected cards use Rating.again (1).
      _enrolledCards.clear();
      for (final answer in _answers) {
        if (answer.selfRating != null) {
          final fsrsState = _fsrsService.enrollCard(
            _session!.userId,
            answer.cardId,
            answer.selfRating!,
          );
          await _hiveService.saveFsrsCard(fsrsState);
          await _supabaseService.upsertFsrsCard(fsrsState.toJson());
          _enrolledCards.add(fsrsState);
        }
      }

      _isComplete = true;
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _session = null;
    _currentCard = null;
    _answers.clear();
    _ejectedCardIds.clear();
    _enrolledCards.clear();
    _awaitingRating = false;
    _lastUserAnswer = null;
    _isComplete = false;
    _error = null;
    _lastAnswerWrong = false;
    _showingFirstPassComplete = false;
    _fsrsStates = {};
    _queueController.clear();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
