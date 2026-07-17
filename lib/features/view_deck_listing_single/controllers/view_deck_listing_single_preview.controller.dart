import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        Deck,
        DeckCommentsController,
        DeckDownloadsService,
        DeckListingInteractionsController,
        DeckVoteReviewsController,
        DiscussionItem,
        Services,
        useDeckCommentsController,
        useDeckVoteReviewsController;
import 'package:flutter_hooks/flutter_hooks.dart'
    show useEffect, useListenable, useMemoized;

ViewDeckListingSinglePreviewController
useViewDeckListingSinglePreviewController({
  required String deckId,
  required Deck initialDeck,
  required Deck Function() deckReader,
}) {
  final controller = useMemoized(
    () => ViewDeckListingSinglePreviewController(
      initialDeck: initialDeck,
      deckReader: deckReader,
    ),
    [deckId],
  );

  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  final deck = deckReader();
  final commentsController = useDeckCommentsController(
    deck: deck,
    enabled: deck.isPublished,
  );
  final reviewsController = useDeckVoteReviewsController(
    deck: deck,
    currentVoteValue: controller.voteValue,
    onReviewChanged: controller.loadInteractionState,
    enabled: deck.isPublished,
  );
  controller.bindDiscussionControllers(
    commentsController: commentsController,
    reviewsController: reviewsController,
  );

  return controller;
}

class ViewDeckListingSinglePreviewController extends Controller {
  ViewDeckListingSinglePreviewController({
    required Deck initialDeck,
    required Deck Function() deckReader,
    DeckDownloadsService? deckDownloadsService,
  }) : _deckReader = deckReader,
       _deckDownloadsService = deckDownloadsService ?? Services.deckDownloads,
       _interactionsController = DeckListingInteractionsController(
         deck: initialDeck,
       ) {
    _interactionsController.addListener(notifyListeners);
    if (_interactionsEnabled) {
      _interactionsController.loadInteractionState();
    }
  }

  final Deck Function() _deckReader;
  final DeckDownloadsService _deckDownloadsService;
  final DeckListingInteractionsController _interactionsController;
  DeckCommentsController? _commentsController;
  DeckVoteReviewsController? _reviewsController;
  bool _isDownloading = false;

  Deck get _deck => _deckReader();
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
  bool get isDownloading => _isDownloading;
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
      _deck.isPublished ? downloadDeck : null;

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

  Future<void> loadInteractionState() {
    return _interactionsController.loadInteractionState();
  }

  Future<void> downloadDeck() async {
    if (_isDownloading) return;

    _isDownloading = true;
    setError(null);
    notifyListeners();

    try {
      await _deckDownloadsService.downloadDeck(_deck);
    } on Exception catch (e) {
      setError(e);
    } catch (e) {
      setError(Exception(e.toString()));
    } finally {
      _isDownloading = false;
      notifyListeners();
    }
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

  void clearErrors() {
    _interactionsController.setError(null);
    _commentsController?.clearError();
    _reviewsController?.clearError();
  }

  @override
  void dispose() {
    _interactionsController.removeListener(notifyListeners);
    _interactionsController.dispose();
    super.dispose();
  }
}
