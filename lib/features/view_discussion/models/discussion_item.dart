import 'package:boo_mondai/lib.barrel.dart'
    show
        DiscussionType,
        DeckVoteReviewComment,
        DeckComment,
        DeckVoteReview,
        CachedProfile;

class DiscussionItem {
  const DiscussionItem({
    required this.id,
    required this.userId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.parentCommentId,
    this.title,
    this.isDeleted = false,
    this.userProfile,
    this.type = DiscussionType.comment,
    this.isLiked = false,
  });

  factory DiscussionItem.fromDeckComment(DeckComment comment) {
    return DiscussionItem(
      id: comment.id,
      userId: comment.userId,
      parentCommentId: comment.parentCommentId,
      body: comment.body,
      isDeleted: comment.isDeleted,
      createdAt: comment.createdAt,
      updatedAt: comment.updatedAt,
      userProfile: comment.userProfile,
    );
  }

  factory DiscussionItem.fromReview(
    DeckVoteReview review, {
    bool isLiked = false,
  }) {
    return DiscussionItem(
      id: review.id,
      userId: review.userId,
      title: review.title,
      body: review.body,
      isDeleted: review.isDeleted,
      createdAt: review.createdAt,
      updatedAt: review.updatedAt,
      userProfile: review.userProfile,
      type: DiscussionType.review,
      isLiked: isLiked,
    );
  }

  factory DiscussionItem.fromReviewComment(DeckVoteReviewComment comment) {
    return DiscussionItem(
      id: comment.id,
      userId: comment.userId,
      parentCommentId: comment.parentCommentId,
      body: comment.body,
      isDeleted: comment.isDeleted,
      createdAt: comment.createdAt,
      updatedAt: comment.updatedAt,
      userProfile: comment.userProfile,
    );
  }

  final String id;
  final String userId;
  final String? parentCommentId;
  final String? title;
  final String body;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CachedProfile? userProfile;
  final DiscussionType type;
  final bool isLiked;

  bool get isReview => type == DiscussionType.review;
}
