import 'package:boo_mondai/features/change_review/change_review_controller.dart';
import 'package:boo_mondai/features/deck_comments/deck_comments.controller.dart';
import 'package:boo_mondai/features/deck_vote_reviews/deck_vote_reviews.controller.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        DeckCommentItem,
        DeckListingInteractionsController,
        ViewDeckListingsController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ViewDeckListingSingleController {
  const ViewDeckListingSingleController({
    required this.deck,
    required this.upvotesCount,
    required this.downvotesCount,
    required this.favoritesCount,
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
  final int upvotesCount;
  final int downvotesCount;
  final int favoritesCount;
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

ViewDeckListingSingleController useViewDeckListingSingleSheet({
  required String deckId,
  required Deck initialDeck,
  required ViewDeckListingsController controller,
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

  useEffect(() {
    void notify() {
      interactionTick.value++;
    }

    interactionsController.addListener(notify);
    interactionsController.loadInteractionState();

    return () {
      interactionsController.removeListener(notify);
      interactionsController.dispose();
    };
  }, [interactionsController, selectedDeckId]);

  interactionTick.value;

  final listing = deck.listing;
  final commentsController = useDeckCommentsController(deck: deck);
  final reviewsController = useDeckVoteReviewsController(
    deck: deck,
    currentVoteValue: interactionsController.voteValue,
    onReviewChanged: interactionsController.loadInteractionState,
  );

  final error =
      controller.error ??
      interactionsController.error ??
      commentsController.error ??
      reviewsController.error;
  final isLoadingDiscussion =
      commentsController.isLoading || reviewsController.isLoading;

  return ViewDeckListingSingleController(
    deck: deck,
    upvotesCount: interactionsController.upvotesCount,
    downvotesCount: interactionsController.downvotesCount,
    favoritesCount: interactionsController.favoritesCount,
    commentsCount: commentsController.isLoading
        ? listing?.commentsCount ?? commentsController.count
        : commentsController.count,
    reviewsCount: reviewsController.isLoading
        ? listing?.reviewsCount ?? reviewsController.count
        : reviewsController.count,
    voteValue: interactionsController.voteValue,
    isFavorite: interactionsController.isFavorite,
    isBusy: interactionsController.isBusy,
    isDownloading: controller.isDownloadingDeck(deckId),
    isLoadingDiscussion: isLoadingDiscussion,
    isSubmittingComment: commentsController.isSubmitting,
    isSubmittingReview: reviewsController.isSubmittingReview,
    isSubmittingReviewComment: reviewsController.isSubmittingReviewComment,
    reviewItems: reviewsController.items,
    commentItems: commentsController.items,
    reviewRepliesFor: reviewsController.repliesFor,
    commentRepliesFor: commentsController.repliesFor,
    canEditCommentItem: commentsController.canEditItem,
    canEditReviewItem: reviewsController.canEditItem,
    onUpvotePressed: interactionsController.toggleUpvote,
    onDownvotePressed: interactionsController.toggleDownvote,
    onFavoritePressed: interactionsController.toggleFavorite,
    onDownloadPressed: () async {
      await controller.downloadDeck(deck, controller: changeReviewController);
    },
    onReviewSubmitted: reviewsController.addReview,
    onReviewReply: reviewsController.addReviewReply,
    onReviewEdit: reviewsController.updateReviewItem,
    onCommentSubmitted: commentsController.addComment,
    onCommentEdit: commentsController.updateCommentItem,
    error: error,
    clearErrors: () {
      controller.setError(null);
      interactionsController.setError(null);
      commentsController.clearError();
      reviewsController.clearError();
    },
  );
}

Deck? _deckById(List<Deck> decks, String deckId) {
  for (final deck in decks) {
    if (deck.id == deckId) return deck;
  }

  return null;
}
