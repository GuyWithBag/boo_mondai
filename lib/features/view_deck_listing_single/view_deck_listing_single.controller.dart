import 'package:boo_mondai/features/deck_comments/deck_comments.controller.dart';
import 'package:boo_mondai/features/deck_vote_reviews/deck_vote_reviews.controller.dart';
import 'package:boo_mondai/features/change_tracker/change_tracker.controller.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        DeckListing,
        DeckCommentItem,
        DeckListingInteractionsController,
        AuthService,
        LocalDB,
        RemoteDB,
        VisibilityState,
        ViewDeckListingsController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum DeckListingSheetMode { editor, preview }

class ViewDeckListingSingleController {
  const ViewDeckListingSingleController({
    required this.deck,
    required this.mode,
    required this.canEdit,
    required this.canPublish,
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
    required this.onModeChanged,
    required this.onPublishPressed,
    required this.onTitleChanged,
    required this.onShortDescriptionChanged,
    required this.onLongDescriptionChanged,
    required this.onReviewSubmitted,
    required this.onReviewReply,
    required this.onReviewEdit,
    required this.onCommentSubmitted,
    required this.onCommentEdit,
    required this.error,
    required this.clearErrors,
  });

  final Deck? deck;
  final DeckListingSheetMode mode;
  final bool canEdit;
  final bool canPublish;
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
  final ValueChanged<DeckListingSheetMode> onModeChanged;
  final Future<void> Function()? onPublishPressed;
  final Future<void> Function(String value) onTitleChanged;
  final Future<void> Function(String value) onShortDescriptionChanged;
  final Future<void> Function(String value) onLongDescriptionChanged;
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
  required DeckListingSheetMode initialMode,
  required ViewDeckListingsController controller,
  required ChangeTrackerController changeReviewController,
}) {
  useListenable(controller);
  final mode = useState(initialMode);

  final deck = _deckById(controller.decks, deckId) ?? initialDeck;
  final selectedDeckId = deck.id;
  final localDeck = LocalDB.deck.selectByPk({'id': selectedDeckId});
  final canEdit = localDeck != null && localDeck.isEditable;
  final canPublish = canEdit && !deck.isPublished && deck.listing != null;
  final interactionsEnabled = deck.isPublished && deck.listing != null;
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
    if (interactionsEnabled) {
      interactionsController.loadInteractionState();
    }

    return () {
      interactionsController.removeListener(notify);
      interactionsController.dispose();
    };
  }, [interactionsController, selectedDeckId, interactionsEnabled]);

  interactionTick.value;

  final listing = deck.listing;
  final commentsController = useDeckCommentsController(
    deck: deck,
    enabled: deck.isPublished,
  );
  final reviewsController = useDeckVoteReviewsController(
    deck: deck,
    currentVoteValue: interactionsController.voteValue,
    onReviewChanged: interactionsController.loadInteractionState,
    enabled: deck.isPublished,
  );

  final error =
      controller.error ??
      interactionsController.error ??
      commentsController.error ??
      reviewsController.error;
  final isLoadingDiscussion =
      commentsController.isLoading || reviewsController.isLoading;

  Future<void> updateDraft(Deck updatedDeck) async {
    await LocalDB.deck.upsert(updatedDeck);
    final updatedListing = updatedDeck.listing;
    if (updatedListing != null) {
      await LocalDB.deckListing.upsert(updatedListing);
    }
    controller.replaceDeck(updatedDeck);
  }

  Future<void> updateTextField({
    required String value,
    required bool allowEmpty,
    required String Function(Deck deck) selectCurrentValue,
    required Deck Function(Deck deck, String value) copyWithValue,
  }) async {
    if (!canEdit) return;

    final trimmedValue = value.trim();
    if (!allowEmpty && trimmedValue.isEmpty) return;
    if (trimmedValue == selectCurrentValue(deck)) return;

    await updateDraft(
      copyWithValue(deck, trimmedValue).copyWith(updatedAt: DateTime.now()),
    );
  }

  Future<void> publishDraft() async {
    if (!canPublish) return;
    if (!AuthService.isAuthenticatedRemote) {
      controller.setError(Exception('Sign in to publish deck listings.'));
      return;
    }

    final now = DateTime.now();
    final listing = deck.listing;
    final publishedListing =
        (listing ??
                DeckListing(deckId: deck.id, createdAt: now, updatedAt: now))
            .copyWith(updatedAt: now);
    final publishedDeck = deck.copyWith(
      isPublished: true,
      visibilityState: VisibilityState.public,
      listing: publishedListing,
      updatedAt: now,
    );

    await updateDraft(publishedDeck);
    await RemoteDB.deck.upsert(publishedDeck);
    await RemoteDB.deckListing.upsert(publishedListing);
    mode.value = DeckListingSheetMode.preview;
  }

  return ViewDeckListingSingleController(
    deck: deck,
    mode: mode.value,
    canEdit: canEdit,
    canPublish: canPublish,
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
    onUpvotePressed: interactionsEnabled
        ? interactionsController.toggleUpvote
        : null,
    onDownvotePressed: interactionsEnabled
        ? interactionsController.toggleDownvote
        : null,
    onFavoritePressed: interactionsEnabled
        ? interactionsController.toggleFavorite
        : null,
    onDownloadPressed: deck.isPublished
        ? () async {
            await controller.downloadDeck(
              deck,
              controller: changeReviewController,
            );
          }
        : null,
    onModeChanged: (value) {
      mode.value = value;
    },
    onPublishPressed: canPublish ? publishDraft : null,
    onTitleChanged: (value) => updateTextField(
      value: value,
      allowEmpty: false,
      selectCurrentValue: (deck) => deck.title,
      copyWithValue: (deck, value) => deck.copyWith(title: value),
    ),
    onShortDescriptionChanged: (value) => updateTextField(
      value: value,
      allowEmpty: true,
      selectCurrentValue: (deck) => deck.shortDescription,
      copyWithValue: (deck, value) => deck.copyWith(shortDescription: value),
    ),
    onLongDescriptionChanged: (value) => updateTextField(
      value: value,
      allowEmpty: true,
      selectCurrentValue: (deck) => deck.longDescription,
      copyWithValue: (deck, value) => deck.copyWith(longDescription: value),
    ),
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
