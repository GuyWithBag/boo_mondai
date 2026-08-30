import 'package:boo_mondai/lib.barrel.dart'
    show Vote, SupabaseRemoteDB, VoteMapper;

class VotesRemoteDB extends SupabaseRemoteDB<Vote> {
  @override
  String get tableName => 'deck_votes';

  @override
  Vote Function(Map<String, dynamic>) get fromMap => VoteMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Vote item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(Vote item) => {
    'deck_id': item.deckId,
    'profile_id': item.profileId,
  };

  @override
  String get upsertConflictTarget => 'deck_id,profile_id';

  Future<Vote?> getByDeckAndUser({
    required String deckId,
    required String profileId,
  }) => selectOne(filters: {'deck_id': deckId, 'profile_id': profileId});

  Future<void> setVote({
    required String deckId,
    required String profileId,
    required int? voteValue,
  }) async {
    if (voteValue == null) {
      await deleteWhere({'deck_id': deckId, 'profile_id': profileId});
      return;
    }

    final existing = await getByDeckAndUser(
      deckId: deckId,
      profileId: profileId,
    );
    if (existing == null) {
      await insert(
        Vote.createNow(
          deckId: deckId,
          profileId: profileId,
          voteValue: voteValue,
        ),
      );
      return;
    }

    if (existing.voteValue == voteValue) return;

    await update(
      Vote(
        deckId: existing.deckId,
        profileId: existing.profileId,
        voteValue: voteValue,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
      ),
    );
  }
}
