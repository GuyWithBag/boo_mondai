import 'package:boo_mondai/lib.barrel.dart'
    show Deck, DeckDueStats, DeckRatingStats;

class DeckReviewStats {
  final Deck deck;
  final DeckDueStats due;
  final DeckRatingStats ratingStats;

  const DeckReviewStats({
    required this.due,
    required this.ratingStats,
    required this.deck,
  });

  String get deckId => deck.id;
  String get deckTitle => deck.title;
  int get totalDue => due.totalDue;
}
