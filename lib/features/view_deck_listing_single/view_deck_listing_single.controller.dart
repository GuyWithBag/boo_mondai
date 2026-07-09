import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthService,
        CardTemplate,
        Controller,
        Deck,
        DeckCommentsController,
        DeckListingInteractionsController,
        DecksService,
        DeckVoteReviewsController,
        DiscussionItem,
        LocalDB,
        ViewDeckListingSingleHelper,
        ViewDeckListingsController,
        useDeckCommentsController,
        useDeckVoteReviewsController;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart' show ValueChanged;
import 'package:flutter_hooks/flutter_hooks.dart'
    show useEffect, useListenable, useMemoized;

enum DeckListingSheetState { editor, preview }

ViewDeckListingSingleController useViewDeckListingSingleController({
  required String deckId,
  required Deck initialDeck,
  required DeckListingSheetState initialState,
  required ViewDeckListingsController controller,
}) {
  final sheetController = useMemoized(
    () => ViewDeckListingSingleController(
      deckId: deckId,
      initialDeck: initialDeck,
      initialState: initialState,
      parentController: controller,
    ),
    [deckId, controller],
  );

  useListenable(sheetController);
  useEffect(() => sheetController.dispose, [sheetController]);

  final commentsController = useDeckCommentsController(
    deck: sheetController.deck,
    enabled: sheetController.deck.isPublished,
  );
  final reviewsController = useDeckVoteReviewsController(
    deck: sheetController.deck,
    currentVoteValue: sheetController.voteValue,
    onReviewChanged: sheetController.loadInteractionState,
    enabled: sheetController.deck.isPublished,
  );
  sheetController.bindDiscussionControllers(
    commentsController: commentsController,
    reviewsController: reviewsController,
  );

  return sheetController;
}

class ViewDeckListingSingleController extends Controller {
  ViewDeckListingSingleController({
    required String deckId,
    required Deck initialDeck,
    required DeckListingSheetState initialState,
    required ViewDeckListingsController parentController,
  }) : _deckId = deckId,
       _deck = initialDeck,
       _state = initialState,
       _parentController = parentController,
       _interactionsController = DeckListingInteractionsController(
         deck: initialDeck,
       ) {
    _syncDeckFromParent();
    _parentController.addListener(_syncFromParentController);
    _interactionsController.addListener(notifyListeners);
    if (_interactionsEnabled) {
      _interactionsController.loadInteractionState();
    }
  }

  final String _deckId;
  final ViewDeckListingsController _parentController;
  final DeckListingInteractionsController _interactionsController;
  final ViewDeckListingSingleHelper helper =
      const ViewDeckListingSingleHelper();

  Deck _deck;
  DeckListingSheetState _state;
  DeckCommentsController? _commentsController;
  DeckVoteReviewsController? _reviewsController;

  Deck get deck => _deck;
  DeckListingSheetState get state => _state;

  bool get canEdit {
    final localDeck = LocalDB.deck.selectByPk({'id': _deck.id});
    return localDeck != null && localDeck.isEditable;
  }

  bool get canPublish => canEdit && !_deck.isPublished && _deck.listing != null;
  bool get canUnpublish => canEdit && _deck.isPublished;
  bool get _interactionsEnabled => _deck.isPublished && _deck.listing != null;

  int get upvotesCount => _interactionsController.upvotesCount;
  int get downvotesCount => _interactionsController.downvotesCount;
  int get favoritesCount => _interactionsController.favoritesCount;
  int get commentsCount {
    final commentsController = _commentsController;
    if (commentsController == null) return _deck.listing?.commentsCount ?? 0;

    return commentsController.isLoading
        ? _deck.listing?.commentsCount ?? commentsController.count
        : commentsController.count;
  }

  int get reviewsCount {
    final reviewsController = _reviewsController;
    if (reviewsController == null) return _deck.listing?.reviewsCount ?? 0;

    return reviewsController.isLoading
        ? _deck.listing?.reviewsCount ?? reviewsController.count
        : reviewsController.count;
  }

  int? get voteValue => _interactionsController.voteValue;
  bool get isFavorite => _interactionsController.isFavorite;
  bool get isBusy => _interactionsController.isBusy;
  bool get isDownloading => _parentController.isDownloadingDeck(_deckId);
  bool get isLoadingDiscussion =>
      (_commentsController?.isLoading ?? false) ||
      (_reviewsController?.isLoading ?? false);
  bool get isSubmittingComment => _commentsController?.isSubmitting ?? false;
  bool get isSubmittingReview =>
      _reviewsController?.isSubmittingReview ?? false;
  bool get isSubmittingReviewComment =>
      _reviewsController?.isSubmittingReviewComment ?? false;
  List<DiscussionItem> get reviewItems =>
      _reviewsController?.items ?? const <DiscussionItem>[];
  List<DiscussionItem> get commentItems =>
      _commentsController?.items ?? const <DiscussionItem>[];
  @override
  Exception? get error =>
      _parentController.error ??
      _interactionsController.error ??
      _commentsController?.error ??
      _reviewsController?.error;

  Future<void> Function()? get onUpvotePressed =>
      _interactionsEnabled ? _interactionsController.toggleUpvote : null;
  Future<void> Function()? get onDownvotePressed =>
      _interactionsEnabled ? _interactionsController.toggleDownvote : null;
  Future<void> Function()? get onFavoritePressed =>
      _interactionsEnabled ? _interactionsController.toggleFavorite : null;
  Future<void> Function()? get onDownloadPressed =>
      _deck.isPublished ? () => _parentController.downloadDeck(_deck) : null;
  ValueChanged<DeckListingSheetState> get onModeChanged => setState;

  List<DiscussionItem> reviewRepliesFor(String itemId) {
    return _reviewsController?.repliesFor(itemId) ?? const <DiscussionItem>[];
  }

  List<DiscussionItem> commentRepliesFor(String itemId) {
    return _commentsController?.repliesFor(itemId) ?? const <DiscussionItem>[];
  }

  bool canEditCommentItem(DiscussionItem item) {
    return _commentsController?.canEditItem(item) ?? false;
  }

  bool canEditReviewItem(DiscussionItem item) {
    return _reviewsController?.canEditItem(item) ?? false;
  }

  void bindDiscussionControllers({
    required DeckCommentsController commentsController,
    required DeckVoteReviewsController reviewsController,
  }) {
    _commentsController = commentsController;
    _reviewsController = reviewsController;
  }

  void setState(DeckListingSheetState value) {
    if (_state == value) return;

    _state = value;
    notifyListeners();
  }

  Future<void> loadInteractionState() {
    return _interactionsController.loadInteractionState();
  }

  Future<bool> submitReview({
    required int voteValue,
    required String title,
    required String body,
  }) async {
    return _reviewsController?.addReview(
          voteValue: voteValue,
          title: title,
          body: body,
        ) ??
        false;
  }

  Future<bool> replyToReview(String body, {String? parentCommentId}) async {
    return _reviewsController?.addReviewReply(
          body,
          parentCommentId: parentCommentId,
        ) ??
        false;
  }

  Future<bool> editReview(
    DiscussionItem item,
    String body, {
    String? title,
  }) async {
    return _reviewsController?.updateReviewItem(item, body, title: title) ??
        false;
  }

  Future<bool> submitComment(String body, {String? parentCommentId}) async {
    return _commentsController?.addComment(
          body,
          parentCommentId: parentCommentId,
        ) ??
        false;
  }

  Future<bool> editComment(
    DiscussionItem item,
    String body, {
    String? title,
  }) async {
    return _commentsController?.updateCommentItem(item, body, title: title) ??
        false;
  }

  Future<void> updateTitle(String value) async {
    final updatedDeck = await DecksService.update(deck: _deck, title: value);
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> updateShortDescription(String value) async {
    final updatedDeck = await DecksService.update(
      deck: _deck,
      shortDescription: value,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> updateLongDescription(String value) async {
    final updatedDeck = await DecksService.update(
      deck: _deck,
      longDescription: value,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> updateTags(List<String> tagNames) async {
    final updatedDeck = await DecksService.updateTags(
      deck: _deck,
      tagNames: tagNames,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> updateListingFeaturedImage(int index, PlatformFile file) async {
    final updatedDeck = await DecksService.updateListingFeaturedImage(
      deck: _deck,
      index: index,
      file: file,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  List<CardTemplate> availableFeaturedCardTemplates() {
    final featuredCardIds = {
      for (final card in _deck.listing?.featuredCards ?? const [])
        if (card['id'] case final String id) id,
    };

    return LocalDB.cardTemplate
        .getByDeckId(_deck.id)
        .where((template) => !featuredCardIds.contains(template.id))
        .toList(growable: false);
  }

  Future<void> addListingFeaturedCard(CardTemplate template) async {
    final updatedDeck = await DecksService.addListingFeaturedCard(
      deck: _deck,
      template: template,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> publishDraft() async {
    if (!canPublish) return;
    if (!AuthService.isAuthenticatedRemote) {
      _parentController.setError(
        Exception('Sign in to publish deck listings.'),
      );
      return;
    }

    final publishedDeck = await DecksService.publishListingDraft(_deck);
    _applyUpdatedDeck(publishedDeck);
    setState(DeckListingSheetState.preview);
    await _interactionsController.loadInteractionState();
  }

  Future<void> unpublishDraft() async {
    if (!canUnpublish) return;
    if (!AuthService.isAuthenticatedRemote) {
      _parentController.setError(
        Exception('Sign in to unpublish deck listings.'),
      );
      return;
    }

    final unpublishedDeck = await DecksService.unpublishListingDraft(_deck);
    _applyUpdatedDeck(unpublishedDeck);
  }

  void clearErrors() {
    _parentController.setError(null);
    _interactionsController.setError(null);
    _commentsController?.clearError();
    _reviewsController?.clearError();
  }

  void _syncFromParentController() {
    _syncDeckFromParent();
    notifyListeners();
  }

  bool _syncDeckFromParent() {
    final parentDeck = helper.deckById(_parentController.decks, _deckId);
    if (parentDeck == null || parentDeck == _deck) return false;

    _deck = parentDeck;
    return true;
  }

  void _applyUpdatedDeck(Deck? updatedDeck) {
    if (updatedDeck == null) return;

    _deck = updatedDeck;
    _parentController.replaceDeck(updatedDeck);
    notifyListeners();
  }

  @override
  void dispose() {
    _parentController.removeListener(_syncFromParentController);
    _interactionsController.removeListener(notifyListeners);
    _interactionsController.dispose();
    super.dispose();
  }
}
