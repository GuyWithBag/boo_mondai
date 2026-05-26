// 3. Define ReviewSession, extending StudySession
import 'package:boo_mondai/features/study_session/models/study_session.dto.dart';
import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/profile/models/cached_profile.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'review_session.dto.mapper.dart';

@MappableClass()
class ReviewSession extends StudySession with ReviewSessionMappable {
  final int totalCards;
  final int cardsReviewed;

  const ReviewSession({
    // Use 'super' to pass the shared properties up to the base class
    required super.id,
    required super.userId,
    super.deckId,
    required super.startedAt,
    super.completedAt,
    super.userProfile,
    super.deck,

    // Subclass specific properties
    required this.totalCards,
    this.cardsReviewed = 0,
  });

  double get progress =>
      totalCards > 0 ? (cardsReviewed / totalCards).clamp(0.0, 1.0) : 0;
}
