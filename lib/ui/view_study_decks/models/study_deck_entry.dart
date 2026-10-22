import 'package:boo_mondai/lib.barrel.dart' show Deck, DeckReviewStats;

class StudyDeckEntry {
  const StudyDeckEntry({required this.deck, required this.stats});

  final Deck deck;
  final DeckReviewStats stats;

  int get totalDue => stats.totalDue;
}
