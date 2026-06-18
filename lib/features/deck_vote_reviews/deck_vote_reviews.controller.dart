import 'package:boo_mondai/core/database/localdbs.dart';
import 'package:boo_mondai/features/auth/auth.service.dart';
import 'package:boo_mondai/features/deck_comments/deck_comment.widget.dart';
import 'package:boo_mondai/features/deck_vote_reviews/deck_vote_reviews.service.dart';
import 'package:boo_mondai/features/deck_vote_reviews/models/deck_vote_review.dto.dart';
import 'package:boo_mondai/features/deck_vote_reviews/models/deck_vote_review_comment.dto.dart';
import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DeckVoteReviewsController {
  const DeckVoteReviewsController({
    required this.reviews,
    required this.reviewComments,
    required this.isLoading,
    required this.isSubmittingReview,
    required this.isSubmittingReviewComment,
    required this.items,
    required this.repliesFor,
    required this.canEditItem,
    required this.addReview,
    required this.addReviewReply,
    required this.updateReviewItem,
    required this.error,
    required this.clearError,
  });

  final List<DeckVoteReview> reviews;
  final Map<String, List<DeckVoteReviewComment>> reviewComments;
  final bool isLoading;
  final bool isSubmittingReview;
  final bool isSubmittingReviewComment;
  final List<DeckCommentItem> items;
  final List<DeckCommentItem> Function(String itemId) repliesFor;
  final bool Function(DeckCommentItem item) canEditItem;
  final Future<bool> Function({
    required int voteValue,
    required String title,
    required String body,
  })
  addReview;
  final Future<bool> Function(String body, {String? parentCommentId})
  addReviewReply;
  final Future<bool> Function(
    DeckCommentItem item,
    String body, {
    String? title,
  })
  updateReviewItem;
  final Exception? error;
  final VoidCallback clearError;

  int get count => reviews.length;
}

DeckVoteReviewsController useDeckVoteReviewsController({
  required Deck deck,
  required int? currentVoteValue,
  Future<void> Function()? onReviewChanged,
}) {
  final reviews = useState(const <DeckVoteReview>[]);
  final reviewComments = useState(
    const <String, List<DeckVoteReviewComment>>{},
  );
  final isLoading = useState(false);
  final isSubmittingReview = useState(false);
  final isSubmittingReviewComment = useState(false);
  final error = useState<Exception?>(null);

  useEffect(() {
    Future<void> loadReviews() async {
      isLoading.value = true;
      error.value = null;

      try {
        final loadedReviews = await DeckVoteReviewsService.getByDeck(deck.id);
        final loadedReviewComments = <String, List<DeckVoteReviewComment>>{};
        for (final review in loadedReviews) {
          loadedReviewComments[review.id] =
              await DeckVoteReviewsService.getComments(review.id);
        }

        reviews.value = loadedReviews;
        reviewComments.value = loadedReviewComments;
      } on Exception catch (e) {
        error.value = e;
      } finally {
        isLoading.value = false;
      }
    }

    loadReviews();
    return null;
  }, [deck.id]);

  final reviewByItemId = {
    for (final review in reviews.value) review.id: review,
  };
  final reviewCommentByItemId = {
    for (final commentsForReview in reviewComments.value.values)
      for (final comment in commentsForReview) comment.id: comment,
  };
  final reviewIdByCommentId = {
    for (final entry in reviewComments.value.entries)
      for (final comment in entry.value) comment.id: entry.key,
  };
  final reviewIds = reviews.value.map((review) => review.id).toSet();

  Future<void> reloadReviewComments(String reviewId) async {
    reviewComments.value = {
      ...reviewComments.value,
      reviewId: await DeckVoteReviewsService.getComments(reviewId),
    };
  }

  Future<void> reloadReviews() async {
    final loadedReviews = await DeckVoteReviewsService.getByDeck(deck.id);
    final loadedReviewComments = <String, List<DeckVoteReviewComment>>{};
    for (final review in loadedReviews) {
      loadedReviewComments[review.id] =
          await DeckVoteReviewsService.getComments(review.id);
    }

    reviews.value = loadedReviews;
    reviewComments.value = loadedReviewComments;
  }

  bool canInteract(String message) {
    if (AuthService.isAuthenticatedRemote) return true;

    error.value = Exception(message);
    return false;
  }

  bool canEditReview(DeckVoteReview review) {
    if (!AuthService.isAuthenticatedRemote || review.isDeleted) return false;

    final profile = LocalDB.profile.getOrCreate();
    return profile.id == review.userId;
  }

  bool canEditReviewComment(DeckVoteReviewComment comment) {
    if (!AuthService.isAuthenticatedRemote || comment.isDeleted) return false;

    final profile = LocalDB.profile.getOrCreate();
    return profile.id == comment.userId;
  }

  List<DeckCommentItem> repliesFor(String itemId) {
    if (reviewIds.contains(itemId)) {
      return (reviewComments.value[itemId] ?? const [])
          .where((comment) => comment.parentCommentId == null)
          .map(DeckCommentItem.fromReviewComment)
          .toList(growable: false);
    }

    final reviewId = reviewIdByCommentId[itemId];
    if (reviewId == null) return const [];

    return (reviewComments.value[reviewId] ?? const [])
        .where((comment) => comment.parentCommentId == itemId)
        .map(DeckCommentItem.fromReviewComment)
        .toList(growable: false);
  }

  Future<bool> addReview({
    required int voteValue,
    required String title,
    required String body,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return false;
    if (!canInteract('Sign in to review decks.')) return false;

    isSubmittingReview.value = true;
    error.value = null;

    try {
      final profile = LocalDB.profile.getOrCreate();
      await DeckVoteReviewsService.upsertReview(
        deckId: deck.id,
        userId: profile.id,
        voteValue: voteValue,
        title: title.trim(),
        body: trimmedBody,
      );
      await reloadReviews();
      await onReviewChanged?.call();
      return true;
    } on Exception catch (e) {
      error.value = e;
      return false;
    } finally {
      isSubmittingReview.value = false;
    }
  }

  Future<bool> updateReviewItem(
    DeckCommentItem item,
    String body, {
    String? title,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return false;

    final review = reviewByItemId[item.id];
    if (review != null) {
      if (!canEditReview(review)) {
        error.value = Exception('You can only edit your own reviews.');
        return false;
      }

      isSubmittingReview.value = true;
      error.value = null;

      try {
        await DeckVoteReviewsService.updateReview(
          reviewId: review.id,
          voteValue: currentVoteValue ?? review.voteValueAtCreation,
          title: title ?? '',
          body: trimmedBody,
        );
        await reloadReviews();
        return true;
      } on Exception catch (e) {
        error.value = e;
        return false;
      } finally {
        isSubmittingReview.value = false;
      }
    }

    final comment = reviewCommentByItemId[item.id];
    if (comment == null) return false;
    if (!canEditReviewComment(comment)) {
      error.value = Exception('You can only edit your own review comments.');
      return false;
    }

    isSubmittingReviewComment.value = true;
    error.value = null;

    try {
      await DeckVoteReviewsService.updateComment(
        commentId: comment.id,
        body: trimmedBody,
      );
      await reloadReviewComments(comment.reviewId);
      return true;
    } on Exception catch (e) {
      error.value = e;
      return false;
    } finally {
      isSubmittingReviewComment.value = false;
    }
  }

  Future<bool> addReviewReply(String body, {String? parentCommentId}) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty || parentCommentId == null) return false;
    if (!canInteract('Sign in to reply to reviews.')) return false;

    final isReplyingToReview = reviewIds.contains(parentCommentId);
    final reviewId = isReplyingToReview
        ? parentCommentId
        : reviewIdByCommentId[parentCommentId];
    if (reviewId == null) return false;

    isSubmittingReviewComment.value = true;
    error.value = null;

    try {
      final profile = LocalDB.profile.getOrCreate();
      await DeckVoteReviewsService.addComment(
        reviewId: reviewId,
        userId: profile.id,
        body: trimmedBody,
        parentCommentId: isReplyingToReview ? null : parentCommentId,
      );
      await reloadReviewComments(reviewId);
      return true;
    } on Exception catch (e) {
      error.value = e;
      return false;
    } finally {
      isSubmittingReviewComment.value = false;
    }
  }

  return DeckVoteReviewsController(
    reviews: reviews.value,
    reviewComments: reviewComments.value,
    isLoading: isLoading.value,
    isSubmittingReview: isSubmittingReview.value,
    isSubmittingReviewComment: isSubmittingReviewComment.value,
    items: reviews.value
        .map(DeckCommentItem.fromReview)
        .toList(growable: false),
    repliesFor: repliesFor,
    canEditItem: (item) {
      final review = reviewByItemId[item.id];
      if (review != null) return canEditReview(review);

      final comment = reviewCommentByItemId[item.id];
      return comment != null && canEditReviewComment(comment);
    },
    addReview: addReview,
    addReviewReply: addReviewReply,
    updateReviewItem: updateReviewItem,
    error: error.value,
    clearError: () {
      error.value = null;
    },
  );
}
