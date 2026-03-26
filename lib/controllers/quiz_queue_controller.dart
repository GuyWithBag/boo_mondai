// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/quiz_queue_controller.dart
// PURPOSE: Manages the quiz question queue — enqueue, dequeue, reinsert
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:collection';
import 'package:boo_mondai/models/deck_card.dart';

class QuizQueueController {
  final Queue<DeckCard> _queue = Queue<DeckCard>();
  int _totalCount = 0;

  void initialize(List<DeckCard> cards) {
    _queue.clear();
    _queue.addAll(cards);
    _totalCount = cards.length;
  }

  DeckCard? dequeue() {
    if (_queue.isEmpty) return null;
    return _queue.removeFirst();
  }

  void requeue(DeckCard card) {
    _queue.addLast(card);
  }

  bool get isEmpty => _queue.isEmpty;
  int get length => _queue.length;
  int get totalCount => _totalCount;

  void clear() {
    _queue.clear();
    _totalCount = 0;
  }
}
