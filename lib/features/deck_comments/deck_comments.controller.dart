import 'package:boo_mondai/core/database/localdbs.dart';
import 'package:boo_mondai/features/auth/auth.service.dart';
import 'package:boo_mondai/features/deck_comments/deck_comment.widget.dart';
import 'package:boo_mondai/features/deck_comments/deck_comments.service.dart';
import 'package:boo_mondai/features/deck_comments/models/deck_comment.dto.dart';
import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DeckCommentsController {
  const DeckCommentsController({
    required this.comments,
    required this.isLoading,
    required this.isSubmitting,
    required this.items,
    required this.repliesFor,
    required this.canEditItem,
    required this.addComment,
    required this.updateCommentItem,
    required this.error,
    required this.clearError,
  });

  final List<DeckComment> comments;
  final bool isLoading;
  final bool isSubmitting;
  final List<DeckCommentItem> items;
  final List<DeckCommentItem> Function(String itemId) repliesFor;
  final bool Function(DeckCommentItem item) canEditItem;
  final Future<bool> Function(String body, {String? parentCommentId})
  addComment;
  final Future<bool> Function(
    DeckCommentItem item,
    String body, {
    String? title,
  })
  updateCommentItem;
  final Exception? error;
  final VoidCallback clearError;

  int get count => comments.length;
}

DeckCommentsController useDeckCommentsController({required Deck deck}) {
  final comments = useState(const <DeckComment>[]);
  final isLoading = useState(false);
  final isSubmitting = useState(false);
  final error = useState<Exception?>(null);

  useEffect(() {
    Future<void> loadComments() async {
      isLoading.value = true;
      error.value = null;

      try {
        comments.value = await DeckCommentsService.getByDeck(deck.id);
      } on Exception catch (e) {
        error.value = e;
      } finally {
        isLoading.value = false;
      }
    }

    loadComments();
    return null;
  }, [deck.id]);

  final commentByItemId = {
    for (final comment in comments.value) comment.id: comment,
  };

  Future<void> reloadComments() async {
    comments.value = await DeckCommentsService.getByDeck(deck.id);
  }

  bool canInteract(String message) {
    if (AuthService.isAuthenticatedRemote) return true;

    error.value = Exception(message);
    return false;
  }

  bool canEditComment(DeckComment comment) {
    if (!AuthService.isAuthenticatedRemote || comment.isDeleted) return false;

    final profile = LocalDB.profile.getOrCreate();
    return profile.id == comment.userId;
  }

  List<DeckCommentItem> repliesFor(String itemId) {
    return comments.value
        .where((comment) => comment.parentCommentId == itemId)
        .map(DeckCommentItem.fromDeckComment)
        .toList(growable: false);
  }

  Future<bool> addComment(String body, {String? parentCommentId}) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return false;
    if (!canInteract('Sign in to comment on decks.')) return false;

    isSubmitting.value = true;
    error.value = null;

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
      error.value = e;
      return false;
    } finally {
      isSubmitting.value = false;
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
      error.value = Exception('You can only edit your own comments.');
      return false;
    }

    isSubmitting.value = true;
    error.value = null;

    try {
      await DeckCommentsService.updateComment(
        commentId: comment.id,
        body: trimmedBody,
      );
      await reloadComments();
      return true;
    } on Exception catch (e) {
      error.value = e;
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  return DeckCommentsController(
    comments: comments.value,
    isLoading: isLoading.value,
    isSubmitting: isSubmitting.value,
    items: comments.value
        .where((comment) => comment.parentCommentId == null)
        .map(DeckCommentItem.fromDeckComment)
        .toList(growable: false),
    repliesFor: repliesFor,
    canEditItem: (item) {
      final comment = commentByItemId[item.id];
      return comment != null && canEditComment(comment);
    },
    addComment: addComment,
    updateCommentItem: updateCommentItem,
    error: error.value,
    clearError: () {
      error.value = null;
    },
  );
}
