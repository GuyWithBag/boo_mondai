import 'package:boo_mondai/lib.barrel.dart'
    show Vote, SupabaseRemoteDB, VoteMapper;

class VotesRemoteDB extends SupabaseRemoteDB<Vote> {
  @override
  String get tableName => 'votes';

  @override
  Vote Function(Map<String, dynamic>) get fromMap => VoteMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Vote item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(Vote item) => {
    'content_id': item.contentId,
  };

  Future<Vote?> getByDeckAndUser({
    required String deckId,
    required String profileId,
  }) => selectOne(filters: {'deck_id': deckId, 'profile_id': profileId});
}
