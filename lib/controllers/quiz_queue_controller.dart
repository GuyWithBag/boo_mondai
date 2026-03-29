// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/quiz_queue_controller.dart
// PURPOSE: Manages the quiz question queue — enqueue, dequeue, reinsert
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:collection';
import 'package:boo_mondai/models/models.barrel.dart';

class QuizQueueController {
  static const int maxStrikes = 3;

  final Queue<DeckCard> _queue = Queue<DeckCard>();
  final Set<String> _seenIds = {};
  Set<String> _originalIds = {};
  int _totalCount = 0;
  final Map<String, int> _wrongCounts = {};

  void initialize(List<DeckCard> cards) {
    _queue.clear();
    _seenIds.clear();
    _wrongCounts.clear();
    _queue.addAll(cards);
    _originalIds = cards.map((c) => c.id).toSet();
    _totalCount = cards.length;
  }

  DeckCard? dequeue() {
    if (_queue.isEmpty) return null;
    final card = _queue.removeFirst();
    _seenIds.add(card.id);
    return card;
  }

  void requeue(DeckCard card) {
    _queue.addLast(card);
  }

  /// Records a wrong answer for [cardId].
  /// Returns `true` when the card has reached [maxStrikes] — the caller must
  /// eject it (enroll in FSRS with Again) instead of requeueing.
  bool recordWrong(String cardId) {
    _wrongCounts[cardId] = (_wrongCounts[cardId] ?? 0) + 1;
    return _wrongCounts[cardId]! >= maxStrikes;
  }

  /// How many wrong attempts have been recorded for [cardId] this session.
  int strikeCount(String cardId) => _wrongCounts[cardId] ?? 0;

  /// True once every unique card has been dequeued at least once.
  bool get firstPassComplete =>
      _originalIds.isNotEmpty && _seenIds.containsAll(_originalIds);

  bool get isEmpty => _queue.isEmpty;
  int get length => _queue.length;
  int get totalCount => _totalCount;

  void clear() {
    _queue.clear();
    _seenIds.clear();
    _wrongCounts.clear();
    _originalIds = {};
    _totalCount = 0;
  }
}
