import 'package:boo_mondai/features/profile/models/cached_profile.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'deck_vote_review_comment.dto.mapper.dart';

@MappableClass()
class DeckVoteReviewComment with DeckVoteReviewCommentMappable {
  final String id;
  final String reviewId;
  final String userId;
  final String? parentCommentId;
  final String body;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CachedProfile? userProfile;

  const DeckVoteReviewComment({
    required this.id,
    required this.reviewId,
    required this.userId,
    this.parentCommentId,
    required this.body,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.userProfile,
  });

  factory DeckVoteReviewComment.createNow({
    required String id,
    required String reviewId,
    required String userId,
    String? parentCommentId,
    required String body,
  }) {
    final now = DateTime.now();
    return DeckVoteReviewComment(
      id: id,
      reviewId: reviewId,
      userId: userId,
      parentCommentId: parentCommentId,
      body: body,
      createdAt: now,
      updatedAt: now,
    );
  }
}
