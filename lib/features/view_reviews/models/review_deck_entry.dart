import 'package:boo_mondai/lib.barrel.dart'
    show Deck, DeckReviewStats;

class ReviewDeckEntry {
  const ReviewDeckEntry({
    required this.deck,
    required this.stats,
  });

  final Deck deck;
  final DeckReviewStats stats;

  int get totalDue => stats.totalDue;
}
