import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'review_session.dto.mapper.dart';

@MappableClass()
class ReviewSession with ReviewSessionMappable {
  final String id;
  final String profileId;
  final String? deckId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final Deck? deck;
  final int totalCards;
  final int cardsReviewed;

  const ReviewSession({
    required this.id,
    required this.profileId,
    this.deckId,
    required this.startedAt,
    this.completedAt,
    this.deck,
    required this.totalCards,
    this.cardsReviewed = 0,
  });

  bool get isComplete => completedAt != null;

  double get progress =>
      totalCards > 0 ? (cardsReviewed / totalCards).clamp(0.0, 1.0) : 0;
}
