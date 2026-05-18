// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/deck_remote_db.dart
// PURPOSE: Supabase CRUD for decks
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

class DecksRemoteDB extends SupabaseRemoteDB<Deck> {
  @override
  String get tableName => 'decks';

  @override
  Deck Function(Map<String, dynamic>) get fromMap => DeckMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Deck item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(Deck item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  /// Fetches decks where visibility_state is 'public'.
  /// Also joins the tags using Supabase many-to-many syntax.
  Future<List<Deck>> selectManyPublic({int? limit, int offset = 0}) =>
      selectMany(
        select: '*, tags(*)',
        filters: {'visibility_state': 'public'},
        orderBy: 'created_at',
        ascending: false,
        limit: limit,
        offset: offset,
      );

  Future<Deck?> selectById(String deckId) => selectOne(filters: {'id': deckId});

  Future<List<Deck>> selectManyByUserId(String profileId) => selectMany(
    filters: {'user_id': profileId},
    orderBy: 'updated_at',
    ascending: false,
  );
}
