import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        Deck,
        DeckComment,
        DeckInteractionsRemoteDB,
        DeckVoteReview,
        DeckVoteReviewComment,
        DeckCommentsService,
        DeckVoteReviewsService,
        LocalDB,
        Services;

class DeckDiscussionController extends Controller {
  DeckDiscussionController({
    required this.deck,
    DeckInteractionsRemoteDB? interactionsRemoteDB,
  }) : _interactionsRemoteDB =
           interactionsRemoteDB ?? DeckInteractionsRemoteDB();

  final Deck deck;
  final DeckInteractionsRemoteDB _interactionsRemoteDB;

  List<DeckComment> comments = [];
  List<DeckVoteReview> reviews = [];
  Map<String, List<DeckVoteReviewComment>> reviewComments = {};
  int? voteValue;
  bool isSubmittingComment = false;
  bool isSubmittingReviewComment = false;
  bool isSubmittingReview = false;

  bool get isAuthenticated => Services.auth.isAuthenticatedRemote;

  Future<void> load() async {
    setLoading(true);
    try {
      final loadedComments = await DeckCommentsService.getByDeck(deck.id);
      final loadedReviews = await DeckVoteReviewsService.getByDeck(deck.id);
      comments = loadedComments;
      reviews = loadedReviews;
      reviewComments = {
        for (final review in loadedReviews)
          review.id: await DeckVoteReviewsService.getComments(review.id),
      };

      if (isAuthenticated) {
        final profile = LocalDB.profile.getOrCreate();
        final state = await _interactionsRemoteDB.getState(
          deckId: deck.id,
          userId: profile.id,
        );
        voteValue = state.voteValue;
      }
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  List<DeckComment> repliesFor(String commentId) => comments
      .where((comment) => comment.parentCommentId == commentId)
      .toList(growable: false);

  List<DeckVoteReviewComment> reviewRootComments(String reviewId) =>
      (reviewComments[reviewId] ?? const [])
          .where((comment) => comment.parentCommentId == null)
          .toList(growable: false);

  List<DeckVoteReviewComment> reviewCommentReplies({
    required String reviewId,
    required String commentId,
  }) => (reviewComments[reviewId] ?? const [])
      .where((comment) => comment.parentCommentId == commentId)
      .toList(growable: false);

  Future<bool> addComment(String body, {String? parentCommentId}) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return false;
    if (!_canInteract('Sign in to comment on decks.')) return false;

    isSubmittingComment = true;
    notifyListeners();

    try {
      final profile = LocalDB.profile.getOrCreate();
      await DeckCommentsService.addComment(
        deckId: deck.id,
        userId: profile.id,
        body: trimmedBody,
        parentCommentId: parentCommentId,
      );
      await _reloadComments();
      return true;
    } on Exception catch (e) {
      setError(e);
      return false;
    } finally {
      isSubmittingComment = false;
      notifyListeners();
    }
  }

  Future<bool> addReview({
    required int voteValue,
    required String title,
    required String body,
  }) async {
    final trimmedTitle = title.trim();
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return false;
    if (!_canInteract('Sign in to review decks.')) return false;

    isSubmittingReview = true;
    notifyListeners();

    try {
      final profile = LocalDB.profile.getOrCreate();
      await DeckVoteReviewsService.upsertReview(
        deckId: deck.id,
        userId: profile.id,
        voteValue: voteValue,
        title: trimmedTitle,
        body: trimmedBody,
      );
      this.voteValue = voteValue;
      await _reloadReviews();
      return true;
    } on Exception catch (e) {
      setError(e);
      return false;
    } finally {
      isSubmittingReview = false;
      notifyListeners();
    }
  }

  Future<bool> addReviewComment({
    required String reviewId,
    required String body,
    String? parentCommentId,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return false;
    if (!_canInteract('Sign in to reply to reviews.')) return false;

    isSubmittingReviewComment = true;
    notifyListeners();

    try {
      final profile = LocalDB.profile.getOrCreate();
      await DeckVoteReviewsService.addComment(
        reviewId: reviewId,
        userId: profile.id,
        body: trimmedBody,
        parentCommentId: parentCommentId,
      );
      await _reloadReviewComments(reviewId);
      return true;
    } on Exception catch (e) {
      setError(e);
      return false;
    } finally {
      isSubmittingReviewComment = false;
      notifyListeners();
    }
  }

  Future<void> _reloadReviews() async {
    reviews = await DeckVoteReviewsService.getByDeck(deck.id);
    for (final review in reviews) {
      await _reloadReviewComments(review.id);
    }
  }

  Future<void> _reloadComments() async {
    comments = await DeckCommentsService.getByDeck(deck.id);
  }

  Future<void> _reloadReviewComments(String reviewId) async {
    reviewComments = {
      ...reviewComments,
      reviewId: await DeckVoteReviewsService.getComments(reviewId),
    };
  }

  bool _canInteract(String message) {
    if (isAuthenticated) return true;

    setError(Exception(message));
    return false;
  }
}
