import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        Deck,
        LocalDB,
        AuthService,
        DeckListing,
        RemoteDB,
        DeckFavorite,
        Vote;
import 'package:signals/signals_core.dart';

class DeckListingTileController extends Controller {
  DeckListingTileController({required Deck deckArg}) {
    deck.value = deckArg;
    deckListing.value = deck.value.listing!;
    favorite.value = deckListing.value.;
    vote.value = ;
  }

  late final Signal<Deck> deck;
  late final Signal<DeckListing> deckListing;
  late final Signal<DeckFavorite> favorite;
  late final Signal<Vote> vote;

  Future<void> loadInteractionState() async {
    if (!AuthService.isAuthenticatedRemote) return;

    final profile = LocalDB.profile.getOrCreate();
    try {
      // final state = await RemoteDB.deckInteractions.getState(
      //   deckId: deck.value.id,
      //   profileId: profile.id,
      // );
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
      await RemoteDB.deckInteractions.setFavorite(
        deckId: deck.id,
        profileId: LocalDB.profile.getOrCreate().id,
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
      await RemoteDB.deckVotes.setVote(
        deckId: deck.value.id,
        profileId: LocalDB.profile.getOrCreate().id,
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

    if (!AuthService.isAuthenticatedRemote) {
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
  }
}
