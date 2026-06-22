import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        DeckListing,
        DeckListingInteractionsController,
        AuthService,
        LocalDB,
        RemoteDB,
        VisibilityState,
        ViewDeckListingsController,
        ChangeTrackerController,
        DeckCommentsController,
        DeckVoteReviewsController,
        useDeckCommentsController,
        useDeckVoteReviewsController,
        DiscussionItem;
import 'package:flutter/material.dart' show ValueChanged, ValueNotifier;
import 'package:flutter_hooks/flutter_hooks.dart'
    show useListenable, useState, useMemoized, useEffect;

enum DeckListingSheetMode { editor, preview }

ViewDeckListingSingleController useViewDeckListingSingleController({
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
    void notify() => interactionTick.value++;

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

  final vc = ViewDeckListingSingleController(
    // Public state
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
        ? () =>
              controller.downloadDeck(deck, controller: changeReviewController)
        : null,
    onModeChanged: (value) => mode.value = value,
    error: error,
    // Private dependencies
    activeDeck: deck,
    parentController: controller,
    interactionsController: interactionsController,
    commentsController: commentsController,
    reviewsController: reviewsController,
    modeNotifier: mode,
  );

  return vc;
}

class ViewDeckListingSingleController {
  ViewDeckListingSingleController({
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
    required this.error,
    required Deck activeDeck,
    required ViewDeckListingsController parentController,
    required DeckListingInteractionsController interactionsController,
    required DeckCommentsController commentsController,
    required DeckVoteReviewsController reviewsController,
    required ValueNotifier<DeckListingSheetMode> modeNotifier,
  }) : _activeDeck = activeDeck,
       _parentController = parentController,
       _interactionsController = interactionsController,
       _commentsController = commentsController,
       _reviewsController = reviewsController,
       _modeNotifier = modeNotifier;

  // --- Public state ---

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
  final List<DiscussionItem> reviewItems;
  final List<DiscussionItem> commentItems;
  final List<DiscussionItem> Function(String itemId) reviewRepliesFor;
  final List<DiscussionItem> Function(String itemId) commentRepliesFor;
  final bool Function(DiscussionItem item) canEditCommentItem;
  final bool Function(DiscussionItem item) canEditReviewItem;
  final Future<void> Function()? onUpvotePressed;
  final Future<void> Function()? onDownvotePressed;
  final Future<void> Function()? onFavoritePressed;
  final Future<void> Function()? onDownloadPressed;
  final ValueChanged<DeckListingSheetMode> onModeChanged;
  final Exception? error;

  // --- Private dependencies ---

  final Deck _activeDeck;
  final ViewDeckListingsController _parentController;
  final DeckListingInteractionsController _interactionsController;
  final DeckCommentsController _commentsController;
  final DeckVoteReviewsController _reviewsController;
  final ValueNotifier<DeckListingSheetMode> _modeNotifier;

  // --- Delegated discussion actions ---

  Future<bool> submitReview({
    required int voteValue,
    required String title,
    required String body,
  }) => _reviewsController.addReview(
    voteValue: voteValue,
    title: title,
    body: body,
  );

  Future<bool> replyToReview(String body, {String? parentCommentId}) =>
      _reviewsController.addReviewReply(body, parentCommentId: parentCommentId);

  Future<bool> editReview(DiscussionItem item, String body, {String? title}) =>
      _reviewsController.updateReviewItem(item, body, title: title);

  Future<bool> submitComment(String body, {String? parentCommentId}) =>
      _commentsController.addComment(body, parentCommentId: parentCommentId);

  Future<bool> editComment(DiscussionItem item, String body, {String? title}) =>
      _commentsController.updateCommentItem(item, body, title: title);

  // --- Draft editing ---

  Future<void> updateDraft(Deck updatedDeck) async {
    await LocalDB.deck.upsert(updatedDeck);
    final updatedListing = updatedDeck.listing;
    if (updatedListing != null) {
      await LocalDB.deckListing.upsert(updatedListing);
    }
    _parentController.replaceDeck(updatedDeck);
  }

  Future<void> _updateTextField({
    required String value,
    required bool allowEmpty,
    required String Function(Deck deck) selectCurrentValue,
    required Deck Function(Deck deck, String value) copyWithValue,
  }) async {
    if (!canEdit) return;

    final trimmedValue = value.trim();
    if (!allowEmpty && trimmedValue.isEmpty) return;
    if (trimmedValue == selectCurrentValue(_activeDeck)) return;

    await updateDraft(
      copyWithValue(
        _activeDeck,
        trimmedValue,
      ).copyWith(updatedAt: DateTime.now()),
    );
  }

  Future<void> updateTitle(String value) => _updateTextField(
    value: value,
    allowEmpty: false,
    selectCurrentValue: (deck) => deck.title,
    copyWithValue: (deck, value) => deck.copyWith(title: value),
  );

  Future<void> updateShortDescription(String value) => _updateTextField(
    value: value,
    allowEmpty: true,
    selectCurrentValue: (deck) => deck.shortDescription,
    copyWithValue: (deck, value) => deck.copyWith(shortDescription: value),
  );

  Future<void> updateLongDescription(String value) => _updateTextField(
    value: value,
    allowEmpty: true,
    selectCurrentValue: (deck) => deck.longDescription,
    copyWithValue: (deck, value) => deck.copyWith(longDescription: value),
  );

  // --- Publishing ---

  Future<void> publishDraft() async {
    if (!canPublish) return;
    if (!AuthService.isAuthenticatedRemote) {
      _parentController.setError(
        Exception('Sign in to publish deck listings.'),
      );
      return;
    }

    final now = DateTime.now();
    final listing = _activeDeck.listing;
    final publishedListing =
        (listing ??
                DeckListing(
                  deckId: _activeDeck.id,
                  createdAt: now,
                  updatedAt: now,
                ))
            .copyWith(updatedAt: now);
    final publishedDeck = _activeDeck.copyWith(
      isPublished: true,
      visibilityState: VisibilityState.public,
      listing: publishedListing,
      updatedAt: now,
    );

    await updateDraft(publishedDeck);
    await RemoteDB.deck.upsert(publishedDeck);
    await RemoteDB.deckListing.upsert(publishedListing);
    _modeNotifier.value = DeckListingSheetMode.preview;
  }

  // --- Error handling ---

  void clearErrors() {
    _parentController.setError(null);
    _interactionsController.setError(null);
    _commentsController.clearError();
    _reviewsController.clearError();
  }
}

Deck? _deckById(List<Deck> decks, String deckId) {
  for (final deck in decks) {
    if (deck.id == deckId) return deck;
  }
  return null;
}
