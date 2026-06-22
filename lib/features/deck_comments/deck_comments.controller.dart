import 'package:boo_mondai/lib.barrel.dart'
    show
        DiscussionItem,
        DeckComment,
        Deck,
        DeckCommentsService,
        AuthService,
        LocalDB;
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:flutter_hooks/flutter_hooks.dart' show useState, useEffect;

class DeckCommentsController {
  DeckCommentsController({
    required this.deck,
    required ValueNotifier<List<DeckComment>> comments,
    required ValueNotifier<bool> isLoading,
    required ValueNotifier<bool> isSubmitting,
    required ValueNotifier<Exception?> error,
  }) : _comments = comments,
       _isLoading = isLoading,
       _isSubmitting = isSubmitting,
       _error = error;

  final Deck deck;

  final ValueNotifier<List<DeckComment>> _comments;
  final ValueNotifier<bool> _isLoading;
  final ValueNotifier<bool> _isSubmitting;
  final ValueNotifier<Exception?> _error;

  // ─── Read-only state ────────────────────────────────────────────────────

  List<DeckComment> get comments => _comments.value;
  bool get isLoading => _isLoading.value;
  bool get isSubmitting => _isSubmitting.value;
  Exception? get error => _error.value;

  int get count => comments.length;

  List<DiscussionItem> get items => comments
      .where((comment) => comment.parentCommentId == null)
      .map(DiscussionItem.fromDeckComment)
      .toList(growable: false);

  void clearError() {
    _error.value = null;
  }

  // ─── Derived lookups ────────────────────────────────────────────────────

  Map<String, DeckComment> get _commentByItemId => {
    for (final comment in comments) comment.id: comment,
  };

  List<DiscussionItem> repliesFor(String itemId) {
    return comments
        .where((comment) => comment.parentCommentId == itemId)
        .map(DiscussionItem.fromDeckComment)
        .toList(growable: false);
  }

  // ─── Permissions ────────────────────────────────────────────────────────

  bool _canInteract(String message) {
    if (AuthService.isAuthenticatedRemote) return true;

    _error.value = Exception(message);
    return false;
  }

  bool canEditComment(DeckComment comment) {
    if (!AuthService.isAuthenticatedRemote || comment.isDeleted) return false;

    final profile = LocalDB.profile.getOrCreate();
    return profile.id == comment.userId;
  }

  bool canEditItem(DiscussionItem item) {
    final comment = _commentByItemId[item.id];
    return comment != null && canEditComment(comment);
  }

  // ─── Loading ────────────────────────────────────────────────────────────

  Future<void> loadComments() async {
    _isLoading.value = true;
    _error.value = null;

    try {
      await _reloadComments();
    } on Exception catch (e) {
      _error.value = e;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _reloadComments() async {
    _comments.value = await DeckCommentsService.getByDeck(deck.id);
  }

  // ─── Mutations ──────────────────────────────────────────────────────────

  Future<bool> addComment(String body, {String? parentCommentId}) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return false;
    if (!_canInteract('Sign in to comment on decks.')) return false;

    _isSubmitting.value = true;
    _error.value = null;

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
      _error.value = e;
      return false;
    } finally {
      _isSubmitting.value = false;
    }
  }

  Future<bool> updateCommentItem(
    DiscussionItem item,
    String body, {
    String? title,
  }) async {
    final trimmedBody = body.trim();
    final comment = _commentByItemId[item.id];
    if (comment == null || trimmedBody.isEmpty) return false;
    if (!canEditComment(comment)) {
      _error.value = Exception('You can only edit your own comments.');
      return false;
    }

    _isSubmitting.value = true;
    _error.value = null;

    try {
      await DeckCommentsService.updateComment(
        commentId: comment.id,
        body: trimmedBody,
      );
      await _reloadComments();
      return true;
    } on Exception catch (e) {
      _error.value = e;
      return false;
    } finally {
      _isSubmitting.value = false;
    }
  }
}

DeckCommentsController useDeckCommentsController({
  required Deck deck,
  bool enabled = true,
}) {
  final comments = useState(const <DeckComment>[]);
  final isLoading = useState(false);
  final isSubmitting = useState(false);
  final error = useState<Exception?>(null);

  final controller = DeckCommentsController(
    deck: deck,
    comments: comments,
    isLoading: isLoading,
    isSubmitting: isSubmitting,
    error: error,
  );

  useEffect(() {
    if (enabled) {
      controller.loadComments();
    }
    return null;
  }, [deck.id, enabled]);

  return controller;
}
