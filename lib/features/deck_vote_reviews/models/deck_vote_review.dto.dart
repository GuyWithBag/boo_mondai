import 'package:boo_mondai/features/profile/models/cached_profile.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'deck_vote_review.dto.mapper.dart';

@MappableClass()
class DeckVoteReview with DeckVoteReviewMappable {
  final String id;
  final String deckId;
  final String userId;
  final int voteValueAtCreation;
  final String title;
  final String body;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CachedProfile? userProfile;

  const DeckVoteReview({
    required this.id,
    required this.deckId,
    required this.userId,
    required this.voteValueAtCreation,
    this.title = '',
    required this.body,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.userProfile,
  });

  factory DeckVoteReview.createNow({
    required String id,
    required String deckId,
    required String userId,
    required int voteValueAtCreation,
    required String title,
    required String body,
  }) {
    final now = DateTime.now();
    return DeckVoteReview(
      id: id,
      deckId: deckId,
      userId: userId,
      voteValueAtCreation: voteValueAtCreation,
      title: title,
      body: body,
      createdAt: now,
      updatedAt: now,
    );
  }
}
