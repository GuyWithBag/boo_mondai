import 'package:boo_mondai/controllers/controller.dart';
import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';

class DeckListingInteractionsController extends Controller {
  DeckListingInteractionsController({
    required this.deck,
    DeckInteractionsRemoteDB? remoteDB,
  }) : _remoteDB = remoteDB ?? DeckInteractionsRemoteDB() {
    final listing = deck.listing;
    upvotesCount = listing?.upvotesCount ?? 0;
    downvotesCount = listing?.downvotesCount ?? 0;
    favoritesCount = listing?.favoritesCount ?? 0;
  }

  final Deck deck;
  final DeckInteractionsRemoteDB _remoteDB;

  int upvotesCount = 0;
  int downvotesCount = 0;
  int favoritesCount = 0;
  int? voteValue;
  bool isFavorite = false;
  bool isBusy = false;

  bool get isAuthenticated => Services.auth.isAuthenticatedRemote;

  Future<void> loadInteractionState() async {
    if (!isAuthenticated) return;

    final profile = LocalDB.profile.getOrCreate();
    try {
      final state = await _remoteDB.getState(
        deckId: deck.id,
        userId: profile.id,
      );
      voteValue = state.voteValue;
      isFavorite = state.isFavorite;
      notifyListeners();
    } on Exception catch (e) {
      setError(e);
    }
  }

  Future<void> toggleUpvote() => _setVote(voteValue == 1 ? null : 1);

  Future<void> toggleDownvote() => _setVote(voteValue == -1 ? null : -1);

  Future<void> toggleFavorite() async {
    if (!_canInteract()) return;

    final previousFavorite = isFavorite;
    final previousFavoritesCount = favoritesCount;
    final nextFavorite = !isFavorite;

    isFavorite = nextFavorite;
    favoritesCount += nextFavorite ? 1 : -1;
    _setBusy(true);

    try {
      await _remoteDB.setFavorite(
        deckId: deck.id,
        userId: LocalDB.profile.getOrCreate().id,
        isFavorite: nextFavorite,
      );
    } on Exception catch (e) {
      isFavorite = previousFavorite;
      favoritesCount = previousFavoritesCount;
      setError(e);
    } finally {
      _setBusy(false);
    }
  }

  Future<void> _setVote(int? nextVoteValue) async {
    if (!_canInteract()) return;

    final previousVoteValue = voteValue;
    final previousUpvotesCount = upvotesCount;
    final previousDownvotesCount = downvotesCount;

    _applyVoteCountChange(from: previousVoteValue, to: nextVoteValue);
    voteValue = nextVoteValue;
    _setBusy(true);

    try {
      await _remoteDB.setVote(
        deckId: deck.id,
        userId: LocalDB.profile.getOrCreate().id,
        voteValue: nextVoteValue,
      );
    } on Exception catch (e) {
      voteValue = previousVoteValue;
      upvotesCount = previousUpvotesCount;
      downvotesCount = previousDownvotesCount;
      setError(e);
    } finally {
      _setBusy(false);
    }
  }

  bool _canInteract() {
    if (isBusy) return false;

    if (!isAuthenticated) {
      setError(Exception('Sign in to vote or favorite decks.'));
      return false;
    }

    return true;
  }

  void _applyVoteCountChange({required int? from, required int? to}) {
    if (from == to) return;

    if (from == 1) upvotesCount--;
    if (from == -1) downvotesCount--;
    if (to == 1) upvotesCount++;
    if (to == -1) downvotesCount++;
  }

  void _setBusy(bool value) {
    isBusy = value;
    notifyListeners();
  }
}
