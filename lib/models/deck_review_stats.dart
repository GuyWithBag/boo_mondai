// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/deck_review_stats.dart
// PURPOSE: Aggregated FSRS stats for a single deck
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class DeckReviewStats {
  final String deckId;
  final String deckTitle;

  // Due counts (The Anki standard)
  final int dueNew;
  final int dueLearning;
  final int dueReview;

  // Historical FSRS ratings
  final int historicalAgain;
  final int historicalHard;
  final int historicalGood;
  final int historicalEasy;

  const DeckReviewStats({
    required this.deckId,
    required this.deckTitle,
    this.dueNew = 0,
    this.dueLearning = 0,
    this.dueReview = 0,
    this.historicalAgain = 0,
    this.historicalHard = 0,
    this.historicalGood = 0,
    this.historicalEasy = 0,
  });

  int get totalDue => dueNew + dueLearning + dueReview;
  int get totalHistorical =>
      historicalAgain + historicalHard + historicalGood + historicalEasy;
}
