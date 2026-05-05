// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_deck_service.dart
// PURPOSE: Supabase CRUD for decks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

class DeckRemoteDB extends SupabaseRemoteDB<Deck> {
  @override
  String get tableName => 'decks';

  @override
  Deck Function(Map<String, dynamic>) get fromMap => DeckMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Deck item) => item.toMap();

  Future<List<Deck>> fetchDecks({bool publicOnly = true}) => selectMany(
    filters: publicOnly ? {'is_public': true} : null,
    orderBy: 'created_at',
  );

  Future<List<Deck>> fetchByUserId(String userId) =>
      selectMany(filters: {'author_id': userId}, orderBy: 'created_at');
}
