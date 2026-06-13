import 'package:boo_mondai/features/change_review/change_review_controller.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        DeckComment,
        DeckCommentItem,
        DeckCommentsService,
        DeckListingInteractionsController,
        DeckVoteReview,
        DeckVoteReviewComment,
        DeckVoteReviewsService,
        LocalDB,
        Services,
        ViewDecksOnlineController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ViewDeckOnlineSheetState {
  const ViewDeckOnlineSheetState({
    required this.deck,
    required this.title,
    required this.shortDescription,
    required this.longDescription,
    required this.carouselImageUrls,
    required this.profileName,
    required this.profileAvatarUrl,
    required this.upvotesCount,
    required this.downvotesCount,
    required this.downloadsCount,
    required this.favoritesCount,
    required this.forksCount,
    required this.commentsCount,
    required this.reviewsCount,
    required this.voteValue,
    required this.isFavorite,
    required this.isBusy,
    required this.isDownloading,
    required this.isLoadingDiscussion,
    required this.isSubmittingComment,
    required this.isSubmittingReview,
    required this.isSubmittingReviewComment,
    required this.reviewItems,
    required this.commentItems,
    required this.reviewRepliesFor,
    required this.commentRepliesFor,
    required this.canEditCommentItem,
    required this.canEditReviewItem,
    required this.onUpvotePressed,
    required this.onDownvotePressed,
    required this.onFavoritePressed,
    required this.onDownloadPressed,
    required this.onReviewSubmitted,
    required this.onReviewReply,
    required this.onReviewEdit,
    required this.onCommentSubmitted,
    required this.onCommentEdit,
    required this.error,
    required this.clearErrors,
  });

  final Deck? deck;
  final String title;
  final String shortDescription;
  final String longDescription;
  final List<String> carouselImageUrls;
  final String profileName;
  final String? profileAvatarUrl;
  final int upvotesCount;
  final int downvotesCount;
  final int downloadsCount;
  final int favoritesCount;
  final int forksCount;
  final int commentsCount;
  final int reviewsCount;
  final int? voteValue;
  final bool isFavorite;
  final bool isBusy;
  final bool isDownloading;
  final bool isLoadingDiscussion;
  final bool isSubmittingComment;
  final bool isSubmittingReview;
  final bool isSubmittingReviewComment;
  final List<DeckCommentItem> reviewItems;
  final List<DeckCommentItem> commentItems;
  final List<DeckCommentItem> Function(String itemId) reviewRepliesFor;
  final List<DeckCommentItem> Function(String itemId) commentRepliesFor;
  final bool Function(DeckCommentItem item) canEditCommentItem;
  final bool Function(DeckCommentItem item) canEditReviewItem;
  final Future<void> Function()? onUpvotePressed;
  final Future<void> Function()? onDownvotePressed;
  final Future<void> Function()? onFavoritePressed;
  final Future<void> Function()? onDownloadPressed;
  final Future<bool> Function({
    required int voteValue,
    required String title,
    required String body,
  })
  onReviewSubmitted;
  final Future<bool> Function(String body, {String? parentCommentId})
  onReviewReply;
  final Future<bool> Function(
    DeckCommentItem item,
    String body, {
    String? title,
  })
  onReviewEdit;
  final Future<bool> Function(String body, {String? parentCommentId})
  onCommentSubmitted;
  final Future<bool> Function(
    DeckCommentItem item,
    String body, {
    String? title,
  })
  onCommentEdit;
  final Exception? error;
  final VoidCallback clearErrors;
}

ViewDeckOnlineSheetState useViewDeckOnlineSheet({
  required String deckId,
  required Deck initialDeck,
  required ViewDecksOnlineController controller,
  required ChangeReviewController changeReviewController,
}) {
  useListenable(controller);

  final deck = _deckById(controller.decks, deckId) ?? initialDeck;
  final selectedDeckId = deck.id;
  final interactionsController = useMemoized(
    () => DeckListingInteractionsController(deck: deck),
    [selectedDeckId],
  );
  final interactionTick = useState(0);
  final comments = useState(const <DeckComment>[]);
  final reviews = useState(const <DeckVoteReview>[]);
  final reviewComments = useState(
    const <String, List<DeckVoteReviewComment>>{},
  );
  final isLoadingDiscussion = useState(false);
  final isSubmittingComment = useState(false);
  final isSubmittingReview = useState(false);
  final isSubmittingReviewComment = useState(false);
  final discussionError = useState<Exception?>(null);

  useEffect(() {
    void notify() {
      interactionTick.value++;
    }

    interactionsController.addListener(notify);
    interactionsController.loadInteractionState();

    Future<void> loadDiscussion() async {
      isLoadingDiscussion.value = true;
      discussionError.value = null;

      try {
        final loadedComments = await DeckCommentsService.getByDeck(deck.id);
        final loadedReviews = await DeckVoteReviewsService.getByDeck(deck.id);
        final loadedReviewComments = <String, List<DeckVoteReviewComment>>{};
        for (final review in loadedReviews) {
          loadedReviewComments[review.id] =
              await DeckVoteReviewsService.getComments(review.id);
        }

        comments.value = loadedComments;
        reviews.value = loadedReviews;
        reviewComments.value = loadedReviewComments;
      } on Exception catch (e) {
        discussionError.value = e;
      } finally {
        isLoadingDiscussion.value = false;
      }
    }

    loadDiscussion();

    return () {
      interactionsController.removeListener(notify);
      interactionsController.dispose();
    };
  }, [interactionsController, selectedDeckId]);

  interactionTick.value;

  final listing = deck.listing;
  final commentByItemId = {
    for (final comment in comments.value) comment.id: comment,
  };
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

  Future<void> reloadComments() async {
    comments.value = await DeckCommentsService.getByDeck(deck.id);
  }

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
    if (Services.auth.isAuthenticatedRemote) return true;

    discussionError.value = Exception(message);
    return false;
  }

  bool canEditComment(DeckComment comment) {
    if (!Services.auth.isAuthenticatedRemote || comment.isDeleted) return false;

    final profile = LocalDB.profile.getOrCreate();
    return profile.id == comment.userId;
  }

  bool canEditReview(DeckVoteReview review) {
    if (!Services.auth.isAuthenticatedRemote || review.isDeleted) return false;

    final profile = LocalDB.profile.getOrCreate();
    return profile.id == review.userId;
  }

  bool canEditReviewComment(DeckVoteReviewComment comment) {
    if (!Services.auth.isAuthenticatedRemote || comment.isDeleted) return false;

    final profile = LocalDB.profile.getOrCreate();
    return profile.id == comment.userId;
  }

  List<DeckCommentItem> reviewRepliesFor(String itemId) {
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

  List<DeckCommentItem> commentRepliesFor(String itemId) {
    return comments.value
        .where((comment) => comment.parentCommentId == itemId)
        .map(DeckCommentItem.fromDeckComment)
        .toList(growable: false);
  }

  Future<bool> addComment(String body, {String? parentCommentId}) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return false;
    if (!canInteract('Sign in to comment on decks.')) return false;

    isSubmittingComment.value = true;
    discussionError.value = null;

    try {
      final profile = LocalDB.profile.getOrCreate();
      await DeckCommentsService.addComment(
        deckId: deck.id,
        userId: profile.id,
        body: trimmedBody,
        parentCommentId: parentCommentId,
      );
      await reloadComments();
      return true;
    } on Exception catch (e) {
      discussionError.value = e;
      return false;
    } finally {
      isSubmittingComment.value = false;
    }
  }

  Future<bool> updateCommentItem(
    DeckCommentItem item,
    String body, {
    String? title,
  }) async {
    final trimmedBody = body.trim();
    final comment = commentByItemId[item.id];
    if (comment == null || trimmedBody.isEmpty) return false;
    if (!canEditComment(comment)) {
      discussionError.value = Exception('You can only edit your own comments.');
      return false;
    }

    isSubmittingComment.value = true;
    discussionError.value = null;

    try {
      await DeckCommentsService.updateComment(
        commentId: comment.id,
        body: trimmedBody,
      );
      await reloadComments();
      return true;
    } on Exception catch (e) {
      discussionError.value = e;
      return false;
    } finally {
      isSubmittingComment.value = false;
    }
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
    discussionError.value = null;

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
      await interactionsController.loadInteractionState();
      return true;
    } on Exception catch (e) {
      discussionError.value = e;
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
        discussionError.value = Exception(
          'You can only edit your own reviews.',
        );
        return false;
      }

      isSubmittingReview.value = true;
      discussionError.value = null;

      try {
        await DeckVoteReviewsService.updateReview(
          reviewId: review.id,
          voteValue:
              interactionsController.voteValue ?? review.voteValueAtCreation,
          title: title ?? '',
          body: trimmedBody,
        );
        await reloadReviews();
        return true;
      } on Exception catch (e) {
        discussionError.value = e;
        return false;
      } finally {
        isSubmittingReview.value = false;
      }
    }

    final comment = reviewCommentByItemId[item.id];
    if (comment == null) return false;
    if (!canEditReviewComment(comment)) {
      discussionError.value = Exception(
        'You can only edit your own review comments.',
      );
      return false;
    }

    isSubmittingReviewComment.value = true;
    discussionError.value = null;

    try {
      await DeckVoteReviewsService.updateComment(
        commentId: comment.id,
        body: trimmedBody,
      );
      await reloadReviewComments(comment.reviewId);
      return true;
    } on Exception catch (e) {
      discussionError.value = e;
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
    discussionError.value = null;

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
      discussionError.value = e;
      return false;
    } finally {
      isSubmittingReviewComment.value = false;
    }
  }

  final error =
      controller.error ?? interactionsController.error ?? discussionError.value;

  return ViewDeckOnlineSheetState(
    deck: deck,
    title: _defaultText(deck.title, 'Untitled deck'),
    shortDescription: _defaultText(
      deck.shortDescription,
      'No short description yet.',
    ),
    longDescription: _defaultText(
      deck.longDescription,
      'No long description yet.',
    ),
    carouselImageUrls: _carouselImageUrls(deck),
    profileName: _defaultText(deck.userProfile?.username, 'Unknown author'),
    profileAvatarUrl: _nonEmptyOrNull(deck.userProfile?.avatarUrl),
    upvotesCount: interactionsController.upvotesCount,
    downvotesCount: interactionsController.downvotesCount,
    downloadsCount: listing?.downloadsCount ?? 0,
    favoritesCount: interactionsController.favoritesCount,
    forksCount: listing?.forksCount ?? 0,
    commentsCount: isLoadingDiscussion.value
        ? listing?.commentsCount ?? comments.value.length
        : comments.value.length,
    reviewsCount: isLoadingDiscussion.value
        ? listing?.reviewsCount ?? reviews.value.length
        : reviews.value.length,
    voteValue: interactionsController.voteValue,
    isFavorite: interactionsController.isFavorite,
    isBusy: interactionsController.isBusy,
    isDownloading: controller.isDownloadingDeck(deckId),
    isLoadingDiscussion: isLoadingDiscussion.value,
    isSubmittingComment: isSubmittingComment.value,
    isSubmittingReview: isSubmittingReview.value,
    isSubmittingReviewComment: isSubmittingReviewComment.value,
    reviewItems: reviews.value
        .map(DeckCommentItem.fromReview)
        .toList(growable: false),
    commentItems: comments.value
        .where((comment) => comment.parentCommentId == null)
        .map(DeckCommentItem.fromDeckComment)
        .toList(growable: false),
    reviewRepliesFor: reviewRepliesFor,
    commentRepliesFor: commentRepliesFor,
    canEditCommentItem: (item) {
      final comment = commentByItemId[item.id];
      return comment != null && canEditComment(comment);
    },
    canEditReviewItem: (item) {
      final review = reviewByItemId[item.id];
      if (review != null) return canEditReview(review);

      final comment = reviewCommentByItemId[item.id];
      return comment != null && canEditReviewComment(comment);
    },
    onUpvotePressed: interactionsController.toggleUpvote,
    onDownvotePressed: interactionsController.toggleDownvote,
    onFavoritePressed: interactionsController.toggleFavorite,
    onDownloadPressed: () async {
      await controller.downloadDeck(deck, controller: changeReviewController);
    },
    onReviewSubmitted: addReview,
    onReviewReply: addReviewReply,
    onReviewEdit: updateReviewItem,
    onCommentSubmitted: addComment,
    onCommentEdit: updateCommentItem,
    error: error,
    clearErrors: () {
      controller.setError(null);
      interactionsController.setError(null);
      discussionError.value = null;
    },
  );
}

Deck? _deckById(List<Deck> decks, String deckId) {
  for (final deck in decks) {
    if (deck.id == deckId) return deck;
  }

  return null;
}

List<String> _carouselImageUrls(Deck? deck) {
  final imageUrls =
      <String>[...?deck?.listing?.featuredImages, ?deck?.coverImageUrl]
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .toSet()
          .toList(growable: false);

  if (imageUrls.isNotEmpty) return imageUrls;

  return const [_fallbackImageUrl];
}

String _defaultText(String? value, String fallback) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return fallback;

  return trimmed;
}

String? _nonEmptyOrNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;

  return trimmed;
}

const _fallbackImageUrl = "https://i.redd.it/jvu7xrv8qug11.jpg";
