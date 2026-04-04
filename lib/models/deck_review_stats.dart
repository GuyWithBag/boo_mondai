// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/deck_review_stats.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// The are not passed to Supabase, these are local ONLY.

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

class DeckHistoricalStats {
  final int again;
  final int hard;
  final int good;
  final int easy;

  const DeckHistoricalStats({
    this.again = 0,
    this.hard = 0,
    this.good = 0,
    this.easy = 0,
  });

  int get totalReviews => again + hard + good + easy;
}

/// The composed model that the UI actually consumes
class DeckReviewStats {
  final String deckId;
  final String deckTitle;
  final DeckDueStats due;
  final DeckHistoricalStats historical;

  const DeckReviewStats({
    required this.deckId,
    required this.deckTitle,
    required this.due,
    required this.historical,
  });

  int get totalDue => due.totalDue;
}
