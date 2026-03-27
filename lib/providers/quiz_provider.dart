// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/providers/quiz_provider.dart
// PURPOSE: Manages quiz session — queue, answer checking, self-rating, FSRS enrollment
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:boo_mondai/controllers/controllers.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/services/services.dart';

/// Manages the full quiz flow: start → answer → rate → complete → FSRS enroll.
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
  })  : _supabaseService = supabaseService,
        _hiveService = hiveService,
        _fsrsService = fsrsService,
        _queueController = queueController;

  QuizSession? _session;
  DeckCard? _currentCard;
  final List<QuizAnswer> _answers = [];
  bool _awaitingRating = false;
  String? _lastUserAnswer;
  bool _isLoading = false;
  String? _error;
  bool _isComplete = false;

  QuizSession? get session => _session;
  DeckCard? get currentCard => _currentCard;
  List<QuizAnswer> get answers => List.unmodifiable(_answers);
  int get queueLength => _queueController.length;
  bool get awaitingRating => _awaitingRating;
  bool get isLoading => _isLoading;
  bool get isComplete => _isComplete;
  String? get error => _error;

  double get progress {
    final total = _queueController.totalCount;
    if (total == 0) return 0;
    return (total - _queueController.length) / total;
  }

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
    notifyListeners();

    try {
      _queueController.initialize(cards);
      final now = DateTime.now();
      final sessionData = {
        'id': _uuid.v4(),
        'user_id': userId,
        'deck_id': deckId,
        'previewed': previewed,
        'total_questions': cards.length,
        'correct_count': 0,
        'started_at': now.toIso8601String(),
      };
      final result = await _supabaseService.insertQuizSession(sessionData);
      _session = QuizSession.fromJson(result);
      _currentCard = _queueController.dequeue();
    } on AppException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void submitAnswer(String userAnswer) {
    if (_currentCard == null) return;

    final isCorrect = _currentCard!.checkAnswer(userAnswer);

    if (!isCorrect) {
      _queueController.requeue(_currentCard!);
      _currentCard = _queueController.dequeue();
      notifyListeners();
    } else {
      _awaitingRating = true;
      _lastUserAnswer = userAnswer;
      notifyListeners();
    }
  }

  Future<void> submitSelfRating(int rating) async {
    if (_currentCard == null || _session == null) return;

    _awaitingRating = false;

    if (rating == 1) {
      // Again — reinsert
      _queueController.requeue(_currentCard!);
    } else {
      // Hard/Good/Easy — save and advance
      final answer = QuizAnswer(
        id: _uuid.v4(),
        sessionId: _session!.id,
        cardId: _currentCard!.id,
        userAnswer: _lastUserAnswer ?? '',
        isCorrect: true,
        selfRating: rating,
        answeredAt: DateTime.now(),
      );
      _answers.add(answer);

      try {
        await _supabaseService.insertQuizAnswer(answer.toJson());
      } on AppException catch (e) {
        _error = e.message;
      }
    }

    if (_queueController.isEmpty) {
      await _completeSession();
    } else {
      _currentCard = _queueController.dequeue();
      notifyListeners();
    }
  }

  Future<void> _completeSession() async {
    if (_session == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final correctCount = _answers.length;
      _session = _session!.copyWith(
        completedAt: DateTime.now(),
        correctCount: correctCount,
      );
      await _supabaseService.updateQuizSession(_session!.id, {
        'completed_at': _session!.completedAt!.toIso8601String(),
        'correct_count': correctCount,
      });

      // Enroll answered cards in FSRS
      for (final answer in _answers) {
        if (answer.selfRating != null && answer.selfRating! > 1) {
          final fsrsState = _fsrsService.enrollCard(
            _session!.userId,
            answer.cardId,
            answer.selfRating!,
          );
          await _hiveService.saveFsrsCard(fsrsState);
          await _supabaseService.upsertFsrsCard(fsrsState.toJson());
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
    _awaitingRating = false;
    _lastUserAnswer = null;
    _isComplete = false;
    _error = null;
    _queueController.clear();
    notifyListeners();
  }
}
