import 'package:boo_mondai/lib.barrel.dart'
    show
        ReviewComment,
        Review,
        Deck,
        ReviewsService,
        AuthService,
        LocalDB,
        DiscussionItem;
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:flutter_hooks/flutter_hooks.dart' show useState, useEffect;

class ReviewsController {
  ReviewsController({
    required this.deck,
    required this.currentVoteValue,
    required ValueNotifier<List<Review>> reviews,
    required ValueNotifier<Map<String, List<ReviewComment>>> reviewComments,
    required ValueNotifier<bool> isLoading,
    required ValueNotifier<bool> isSubmittingReview,
    required ValueNotifier<bool> isSubmittingReviewComment,
    required ValueNotifier<Exception?> error,
    this.onReviewChanged,
  }) : _reviews = reviews,
       _reviewComments = reviewComments,
       _isLoading = isLoading,
       _isSubmittingReview = isSubmittingReview,
       _isSubmittingReviewComment = isSubmittingReviewComment,
       _error = error;

  final Deck deck;
  final int? currentVoteValue;
  final Future<void> Function()? onReviewChanged;

  final ValueNotifier<List<Review>> _reviews;
  final ValueNotifier<Map<String, List<ReviewComment>>> _reviewComments;
  final ValueNotifier<bool> _isLoading;
  final ValueNotifier<bool> _isSubmittingReview;
  final ValueNotifier<bool> _isSubmittingReviewComment;
  final ValueNotifier<Exception?> _error;

  // ─── Read-only state ────────────────────────────────────────────────────

  List<Review> get reviews => _reviews.value;
  Map<String, List<ReviewComment>> get reviewComments => _reviewComments.value;
  bool get isLoading => _isLoading.value;
  bool get isSubmittingReview => _isSubmittingReview.value;
  bool get isSubmittingReviewComment => _isSubmittingReviewComment.value;
  Exception? get error => _error.value;

  int get count => reviews.length;

  List<DiscussionItem> get items =>
      reviews.map(DiscussionItem.fromReview).toList(growable: false);

  void clearError() {
    _error.value = null;
  }

  // ─── Derived lookups ────────────────────────────────────────────────────

  Map<String, Review> get _reviewByItemId => {
    for (final review in reviews) review.id: review,
  };

  Map<String, ReviewComment> get _reviewCommentByItemId => {
    for (final commentsForReview in reviewComments.values)
      for (final comment in commentsForReview) comment.id: comment,
  };

  Map<String, String> get _reviewIdByCommentId => {
    for (final entry in reviewComments.entries)
      for (final comment in entry.value) comment.id: entry.key,
  };

  Set<String> get _reviewIds => reviews.map((review) => review.id).toSet();

  List<DiscussionItem> repliesFor(String itemId) {
    if (_reviewIds.contains(itemId)) {
      return (reviewComments[itemId] ?? const [])
          .where((comment) => comment.parentCommentId == null)
          .map(DiscussionItem.fromReviewComment)
          .toList(growable: false);
    }

    final reviewId = _reviewIdByCommentId[itemId];
    if (reviewId == null) return const [];

    return (reviewComments[reviewId] ?? const [])
        .where((comment) => comment.parentCommentId == itemId)
        .map(DiscussionItem.fromReviewComment)
        .toList(growable: false);
  }

  // ─── Permissions ────────────────────────────────────────────────────────

  bool _canInteract(String message) {
    if (AuthService.isAuthenticatedRemote) return true;

    _error.value = Exception(message);
    return false;
  }

  bool canEditReview(Review review) {
    if (!AuthService.isAuthenticatedRemote || review.isDeleted) return false;

    final profile = LocalDB.profile.getOrCreate();
    return profile.id == review.profileId;
  }

  bool canEditReviewComment(ReviewComment comment) {
    if (!AuthService.isAuthenticatedRemote || comment.isDeleted) return false;

    final profile = LocalDB.profile.getOrCreate();
    return profile.id == comment.profileId;
  }

  bool canEditItem(DiscussionItem item) {
    final review = _reviewByItemId[item.id];
    if (review != null) return canEditReview(review);

    final comment = _reviewCommentByItemId[item.id];
    return comment != null && canEditReviewComment(comment);
  }

  // ─── Loading ────────────────────────────────────────────────────────────

  Future<void> loadReviews() async {
    _isLoading.value = true;
    _error.value = null;

    try {
      await _reloadReviews();
    } on Exception catch (e) {
      _error.value = e;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _reloadReviews() async {
    final loadedReviews = await ReviewsService.getByDeck(deck.id);
    final loadedReviewComments = <String, List<ReviewComment>>{};
    for (final review in loadedReviews) {
      loadedReviewComments[review.id] = await ReviewsService.getComments(
        review.id,
      );
    }

    _reviews.value = loadedReviews;
    _reviewComments.value = loadedReviewComments;
  }

  Future<void> _reloadReviewComments(String reviewId) async {
    _reviewComments.value = {
      ..._reviewComments.value,
      reviewId: await ReviewsService.getComments(reviewId),
    };
  }

  // ─── Mutations ──────────────────────────────────────────────────────────

  Future<bool> addReview({
    required int voteValue,
    required String title,
    required String body,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return false;
    if (!_canInteract('Sign in to review decks.')) return false;

    _isSubmittingReview.value = true;
    _error.value = null;

    try {
      final profile = LocalDB.profile.getOrCreate();
      await ReviewsService.upsertReview(
        deckId: deck.id,
        profileId: profile.id,
        voteValue: voteValue,
        title: title.trim(),
        body: trimmedBody,
      );
      await _reloadReviews();
      await onReviewChanged?.call();
      return true;
    } on Exception catch (e) {
      _error.value = e;
      return false;
    } finally {
      _isSubmittingReview.value = false;
    }
  }

  Future<bool> updateReviewItem(
    DiscussionItem item,
    String body, {
    String? title,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return false;

    final review = _reviewByItemId[item.id];
    if (review != null) {
      return _updateReview(review, trimmedBody, title: title);
    }

    final comment = _reviewCommentByItemId[item.id];
    if (comment == null) return false;
    return _updateReviewComment(comment, trimmedBody);
  }

  Future<bool> _updateReview(
    Review review,
    String trimmedBody, {
    String? title,
  }) async {
    if (!canEditReview(review)) {
      _error.value = Exception('You can only edit your own reviews.');
      return false;
    }

    _isSubmittingReview.value = true;
    _error.value = null;

    try {
      await ReviewsService.updateReview(
        reviewId: review.id,
        voteValue: currentVoteValue ?? review.voteValueAtCreation,
        title: title ?? '',
        body: trimmedBody,
      );
      await _reloadReviews();
      return true;
    } on Exception catch (e) {
      _error.value = e;
      return false;
    } finally {
      _isSubmittingReview.value = false;
    }
  }

  Future<bool> _updateReviewComment(
    ReviewComment comment,
    String trimmedBody,
  ) async {
    if (!canEditReviewComment(comment)) {
      _error.value = Exception('You can only edit your own review comments.');
      return false;
    }

    _isSubmittingReviewComment.value = true;
    _error.value = null;

    try {
      await ReviewsService.updateComment(
        commentId: comment.id,
        body: trimmedBody,
      );
      await _reloadReviewComments(comment.reviewId);
      return true;
    } on Exception catch (e) {
      _error.value = e;
      return false;
    } finally {
      _isSubmittingReviewComment.value = false;
    }
  }

  Future<bool> addReviewReply(String body, {String? parentCommentId}) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty || parentCommentId == null) return false;
    if (!_canInteract('Sign in to reply to reviews.')) return false;

    final isReplyingToReview = _reviewIds.contains(parentCommentId);
    final reviewId = isReplyingToReview
        ? parentCommentId
        : _reviewIdByCommentId[parentCommentId];
    if (reviewId == null) return false;

    _isSubmittingReviewComment.value = true;
    _error.value = null;

    try {
      final profile = LocalDB.profile.getOrCreate();
      await ReviewsService.addComment(
        reviewId: reviewId,
        profileId: profile.id,
        body: trimmedBody,
        parentCommentId: isReplyingToReview ? null : parentCommentId,
      );
      await _reloadReviewComments(reviewId);
      return true;
    } on Exception catch (e) {
      _error.value = e;
      return false;
    } finally {
      _isSubmittingReviewComment.value = false;
    }
  }
}

ReviewsController useReviewsController({
  required Deck deck,
  required int? currentVoteValue,
  Future<void> Function()? onReviewChanged,
  bool enabled = true,
}) {
  final reviews = useState(const <Review>[]);
  final reviewComments = useState(const <String, List<ReviewComment>>{});
  final isLoading = useState(false);
  final isSubmittingReview = useState(false);
  final isSubmittingReviewComment = useState(false);
  final error = useState<Exception?>(null);

  final controller = ReviewsController(
    deck: deck,
    currentVoteValue: currentVoteValue,
    reviews: reviews,
    reviewComments: reviewComments,
    isLoading: isLoading,
    isSubmittingReview: isSubmittingReview,
    isSubmittingReviewComment: isSubmittingReviewComment,
    error: error,
    onReviewChanged: onReviewChanged,
  );

  useEffect(() {
    if (enabled) {
      controller.loadReviews();
    }
    return null;
  }, [deck.id, enabled]);

  return controller;
}
