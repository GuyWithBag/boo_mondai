import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

class DeckInteractionState {
  const DeckInteractionState({this.voteValue, required this.isFavorite});

  final int? voteValue;
  final bool isFavorite;
}

class DeckVotesRemoteDB extends SupabaseRemoteDB<DeckVote> {
  @override
  String get tableName => 'deck_votes';

  @override
  DeckVote Function(Map<String, dynamic>) get fromMap => DeckVoteMapper.fromMap;

  @override
  Map<String, dynamic> toMap(DeckVote item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(DeckVote item) => {
    'deck_id': item.deckId,
    'user_id': item.userId,
  };

  @override
  String get upsertConflictTarget => 'deck_id,user_id';

  Future<DeckVote?> getByDeckAndUser({
    required String deckId,
    required String userId,
  }) => selectOne(filters: {'deck_id': deckId, 'user_id': userId});

  Future<void> setVote({
    required String deckId,
    required String userId,
    required int? voteValue,
  }) async {
    if (voteValue == null) {
      await deleteWhere({'deck_id': deckId, 'user_id': userId});
      return;
    }

    final existing = await getByDeckAndUser(deckId: deckId, userId: userId);
    if (existing == null) {
      await insert(
        DeckVote.createNow(
          deckId: deckId,
          userId: userId,
          voteValue: voteValue,
        ),
      );
      return;
    }

    if (existing.voteValue == voteValue) return;

    await update(
      DeckVote(
        deckId: existing.deckId,
        userId: existing.userId,
        voteValue: voteValue,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
      ),
    );
  }
}

class DeckFavoritesRemoteDB extends SupabaseRemoteDB<DeckFavorite> {
  @override
  String get tableName => 'deck_favorites';

  @override
  DeckFavorite Function(Map<String, dynamic>) get fromMap =>
      DeckFavoriteMapper.fromMap;

  @override
  Map<String, dynamic> toMap(DeckFavorite item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(DeckFavorite item) => {
    'deck_id': item.deckId,
    'user_id': item.userId,
  };

  @override
  String get upsertConflictTarget => 'deck_id,user_id';

  Future<DeckFavorite?> getByDeckAndUser({
    required String deckId,
    required String userId,
  }) => selectOne(filters: {'deck_id': deckId, 'user_id': userId});

  Future<void> setFavorite({
    required String deckId,
    required String userId,
    required bool isFavorite,
  }) async {
    final existing = await getByDeckAndUser(deckId: deckId, userId: userId);

    if (!isFavorite) {
      if (existing == null) return;
      await delete(existing);
      return;
    }

    if (existing != null) return;

    await insert(DeckFavorite.createNow(deckId: deckId, userId: userId));
  }
}

class DeckInteractionsRemoteDB {
  DeckInteractionsRemoteDB({
    DeckVotesRemoteDB? votes,
    DeckFavoritesRemoteDB? favorites,
  }) : _votes = votes ?? DeckVotesRemoteDB(),
       _favorites = favorites ?? DeckFavoritesRemoteDB();

  final DeckVotesRemoteDB _votes;
  final DeckFavoritesRemoteDB _favorites;

  Future<DeckInteractionState> getState({
    required String deckId,
    required String userId,
  }) async {
    final vote = await _votes.getByDeckAndUser(deckId: deckId, userId: userId);
    final favorite = await _favorites.getByDeckAndUser(
      deckId: deckId,
      userId: userId,
    );

    return DeckInteractionState(
      voteValue: vote?.voteValue,
      isFavorite: favorite != null,
    );
  }

  Future<void> setVote({
    required String deckId,
    required String userId,
    required int? voteValue,
  }) => _votes.setVote(deckId: deckId, userId: userId, voteValue: voteValue);

  Future<void> setFavorite({
    required String deckId,
    required String userId,
    required bool isFavorite,
  }) => _favorites.setFavorite(
    deckId: deckId,
    userId: userId,
    isFavorite: isFavorite,
  );
}
