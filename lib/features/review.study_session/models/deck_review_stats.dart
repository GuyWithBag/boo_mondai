// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/deck_review_stats.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// The are not passed to Supabase, these are local ONLY.

import 'package:boo_mondai/lib.barrel.dart' show Deck;

class DeckDueStats {
  final int dueNew;
  final int dueLearning;
  final int dueReview;

  const DeckDueStats({
    this.dueNew = 0,
    this.dueLearning = 0,
    this.dueReview = 0,
  });

  int get totalDue => dueNew + dueLearning + dueReview;
}

class DeckRatingStats {
  final int again;
  final int hard;
  final int good;
  final int easy;

  const DeckRatingStats({
    this.again = 0,
    this.hard = 0,
    this.good = 0,
    this.easy = 0,
  });

  int get totalReviews => again + hard + good + easy;
}

/// The composed model that the UI actually consumes
class DeckReviewStats {
  final Deck deck;
  final DeckDueStats due;
  final DeckRatingStats historical;

  const DeckReviewStats({
    required this.due,
    required this.historical,
    required this.deck,
  });

  String get deckId => deck.id;
  String get deckTitle => deck.title;
  int get totalDue => due.totalDue;
}
